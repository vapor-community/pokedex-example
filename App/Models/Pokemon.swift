import Vapor
import Fluent
import Foundation

final class Pokemon: Model {
    var id: Node?
    var name: String
    var time: Int

    convenience init(name: String) {
        let date = Date()
        self.init(name: name, time: Int(date.timeIntervalSince1970))
    }

    init(name: String, time: Int) {
        self.name = name
        self.time = time
    }
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        name = try node.extract("name")
        time = try node.extract("time")
    }
    
    func makeNode() throws -> Node {
        return try Node(node: [
            "id"  : id,
            "name": name,
            "time": time
        ])
    }
    static func prepare(_ database: Database) throws {
        //
    }
    
    static func revert(_ database: Database) throws {
        //
    }
    
}

// MARK: Date

extension Pokemon {
    var date: Date {
        return Date(timeIntervalSince1970: Double(time))
    }

    var readableDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
