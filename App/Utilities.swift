import Vapor

extension Sequence where Iterator.Element == Pokemon {
    func makeJSON() -> JSON {
        return .array(self.map { $0.makeJSON() })
    }

    func makeResponse(request: Request) -> Response {
        return try! makeJSON().makeResponse(for: request)
    }
}
