import SwiftUI

extension Color {
    init?(hex: String) {
        guard hex.hasPrefix("#"), hex.count == 7 else { return nil }
        let scanner = Scanner(string: String(hex.dropFirst()))
        var hexNumber: UInt64 = 0
        guard scanner.scanHexInt64(&hexNumber) else { return nil }
        self.init(
            red: CGFloat((hexNumber & 0xff0000) >> 16) / 255,
            green: CGFloat((hexNumber & 0x00ff00) >> 8) / 255,
            blue: CGFloat(hexNumber & 0x0000ff) / 255
        )
    }

    func toHex() -> String {
        let uiColor = UIColor(self)
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: nil)
        let rgb: Int = (Int)(red * 255) << 16 | (Int)(green * 255) << 8 | (Int)(blue * 255)
        return String(format: "#%06x", rgb)
    }

    static let volumeQuiet = Color(hex: "#0A84FF") ?? .blue
    static let volumeMedium = Color(hex: "#30D158") ?? .green
    static let volumeLoud = Color(hex: "#FF9F0A") ?? .orange
    static let volumeMax = Color(hex: "#FF453A") ?? .red

    static func volumeColor(for volume: Float) -> Color {
        switch volume {
        case 0..<0.3: return .volumeQuiet
        case 0.3..<0.6: return .volumeMedium
        case 0.6..<0.8: return .volumeLoud
        default: return .volumeMax
        }
    }
}
