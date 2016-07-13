import Vapor
import Foundation

final class Pokemon: Model {
    var id: FluentValue?
    var name: String
    var time: Int

    convenience init(name: String) {
        let date = Date()
        self.init(name: name, time: Int(date.timeIntervalSince1970))
    }

    init(name: String, time: Int) {
        id = nil
        self.name = name
        self.time = time
    }

    init(serialized: [String: FluentValue]) {
        id = serialized["id"]
        name = serialized["name"].string ?? ""
        time = serialized["time"].int ?? 0
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
