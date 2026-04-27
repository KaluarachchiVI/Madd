import Foundation

enum NurseryFormatters {
    private static let timeShortGB: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_GB")
        f.timeStyle = .short
        f.dateStyle = .none
        return f
    }()

    static func shortTime(_ date: Date?) -> String? {
        guard let date else { return nil }
        return timeShortGB.string(from: date)
    }
}

extension String {
    /// Initials for avatar (e.g. "Aarav Perera" -> "AP").
    func displayInitials(maxParts: Int = 2) -> String {
        let parts = split(separator: " ").filter { !$0.isEmpty }
        let letters = parts.prefix(maxParts).compactMap { $0.first.map(String.init) }
        return letters.joined().uppercased()
    }
}
