import Vapor
import HTTP

extension Sequence where Iterator.Element == Pokemon {
    func makeJSON() -> JSON {
        return .array(self.map { $0.makeJSON() })
    }

    func makeResponse(request: Request) throws -> Response {
        return try makeJSON().makeResponse()
    }
}
