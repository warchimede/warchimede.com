import Foundation

extension Date {
  private static let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US")
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter
  }()

  var formatted: String { Self.formatter.string(from: self) }
}