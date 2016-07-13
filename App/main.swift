import Vapor
import VaporMustache
import VaporMySQL

let mustache = VaporMustache.Provider(withIncludes: [
    "header": "Includes/header.mustache",
    "footer": "Includes/footer.mustache"
])

let mysql = try VaporMySQL.Provider(host: "localhost", user: "root", password: "", database: "pokedex")

let drop = Droplet(providers: [mustache, mysql], preparations: [Pokemon.self])

drop.get("pokemon") { request in
    return try Pokemon.all().makeResponse(request: request)
}

drop.post("pokemon") { request in
    guard let name = request.data["name"].string else {
        throw Abort.custom(status: .badRequest, message: "Please include a name.")
    }

    if let pokemon = try Pokemon.filter("name", name).first() {
        throw Abort.custom(status: .badRequest, message: "Duplicate Pokémon.")
    }

    let response = try drop.client.get("http://pokeapi.co/api/v2/pokemon/\(name.lowercased())/")
    guard let id = response.data["id"].int else {
        throw Abort.custom(status: .badRequest, message: "Invalid Pokémon name.")
    }
    drop.console.info("Id: \(id)")

    var pokemon = Pokemon(name: name)

    try pokemon.save()

    return pokemon
}

drop.get("pokemon", Pokemon.self) { request, pokemon in
    let response = try drop.client.get("http://pokeapi.co/api/v2/pokemon/\(pokemon.name.lowercased())/")

    guard let image = response.data["sprites", "front_default"].string else {
        throw Abort.custom(status: .badRequest, message: "Invalid Pokémon name.")
    }

    return try drop.view("pokemon.mustache", context: [
        "image": image,
        "name": pokemon.name,
        "date": pokemon.readableDate
    ])
}

class InvalidParameterMiddleware: Middleware {
    init() {}

    func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        do {
            return try next.respond(to: request)
        } catch Abort.invalidParameter(_, let type) where type is Pokemon.Type {
            return try drop.view("not-found.mustache").makeResponse(for: request)
        }
    }
}

let middleware = InvalidParameterMiddleware()

drop.globalMiddleware.append(middleware)

drop.serve()
