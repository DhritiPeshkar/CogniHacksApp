import Foundation
import SwiftData

@Model
class Item {
    var timestamp: Date
    var name: String
    var durationHours: Int
    var durationMinutes: Int

    init(timestamp: Date, name: String = "", durationHours: Int = 0, durationMinutes: Int = 0) {
        self.timestamp = timestamp
        self.name = name
        self.durationHours = durationHours
        self.durationMinutes = durationMinutes
    }
}
