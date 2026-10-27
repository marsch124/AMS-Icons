import Foundation
import SwiftUI

/// One colour of the icon palette: the fill an icon's tile is painted in, and the colour the
/// icon is drawn in on that fill.
///
/// The palette is the AMS Packing app's (`TemplateColour.swift`) with the same keys, names and
/// colours, so a colour means the same thing in every AMS app. A key never changes once it is
/// stored; a new colour may be added, none renamed or taken away.
///
/// "Automatic" is not in the palette: it is `nil` everywhere here, and each app decides what it
/// looks like (PARAGON: the colour of the note's kind).
public struct IconColour: Identifiable, Hashable, Sendable {
    /// What is stored, and the end of the picker's id (`icon.colour.<key>`).
    public let key: String
    /// Its word: written under the swatch and said by VoiceOver.
    public let name: String
    /// The fill, "#rrggbb".
    public let hex: String
    /// The icon on that fill, "#rrggbb": white on the deep colours, dark on the light ones
    /// (yellow, green, sand …), where white cannot be read.
    public let ink: String

    public init(key: String, name: String, hex: String, ink: String) {
        self.key = key
        self.name = name
        self.hex = hex
        self.ink = ink
    }

    public var id: String { key }

    /// The fill as a SwiftUI colour.
    public var fillColor: Color { Color(hex: hex) }

    /// The icon's colour on this fill.
    public var inkColor: Color { Color(hex: ink) }

    /// The palette, in the picker's order: the six workout colours first (the same as AMS
    /// Workout Sync and the Packing app), then the calm deep ones round the colour wheel. No teal.
    public static let palette: [IconColour] = [
        IconColour(key: "blue", name: "Blue", hex: "#0a84ff", ink: "#ffffff"),
        IconColour(key: "yellow", name: "Yellow", hex: "#ffd60a", ink: "#3d3000"),
        IconColour(key: "green", name: "Green", hex: "#30d158", ink: "#0b3a17"),
        IconColour(key: "orange", name: "Orange", hex: "#ff8c1a", ink: "#4a2300"),
        IconColour(key: "lavender", name: "Lavender", hex: "#bf9cff", ink: "#2e1a5c"),
        IconColour(key: "pink", name: "Pink", hex: "#ff6fa8", ink: "#5a0f2e"),
        IconColour(key: "red", name: "Red", hex: "#dc3d43", ink: "#ffffff"),
        IconColour(key: "plum", name: "Plum", hex: "#9c3d8c", ink: "#ffffff"),
        IconColour(key: "violet", name: "Violet", hex: "#7c5cd6", ink: "#ffffff"),
        IconColour(key: "indigo", name: "Indigo", hex: "#4f46e5", ink: "#ffffff"),
        IconColour(key: "navy", name: "Navy", hex: "#2a5194", ink: "#ffffff"),
        IconColour(key: "olive", name: "Olive", hex: "#6e7b1f", ink: "#ffffff"),
        IconColour(key: "sand", name: "Sand", hex: "#d9b98c", ink: "#3d2a10"),
        IconColour(key: "brown", name: "Brown", hex: "#8b5e3c", ink: "#ffffff"),
        IconColour(key: "slate", name: "Grey", hex: "#64748b", ink: "#ffffff"),
    ]

    /// The swatch that means "no colour of my own" (`icon.colour.auto`).
    public static let automaticKey = "auto"
    /// Its word under the swatch.
    public static let automaticName = "Automatic"

    /// The picker shows Automatic and the palette in exactly this many rows …
    public static let pickerRowCount = 2

    /// … so this many swatches to a row: Automatic and fifteen make eight.
    public static var pickerColumnCount: Int {
        (palette.count + 1 + pickerRowCount - 1) / pickerRowCount
    }

    /// Automatic (`nil`) first, then the palette, in the picker's rows: two rows of eight.
    public static var pickerRows: [[IconColour?]] {
        var swatches: [IconColour?] = [nil]
        swatches.append(contentsOf: palette.map { colour -> IconColour? in colour })
        let columns = pickerColumnCount
        return stride(from: 0, to: swatches.count, by: columns).map { start in
            Array(swatches[start..<min(start + columns, swatches.count)])
        }
    }

    /// The palette colour with this key. Nil for Automatic ("auto"), for nothing, and for a key
    /// that is not in the palette. Spaces and capitals do not count.
    public static func of(key: String?) -> IconColour? {
        guard let wanted = key?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(),
              !wanted.isEmpty else { return nil }
        return palette.first { $0.key == wanted }
    }

    /// The palette colour with this fill ("#0A84FF" and "#0a84ff" alike), if it is one.
    public static func of(hex: String?) -> IconColour? {
        guard let wanted = hex?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(),
              !wanted.isEmpty else { return nil }
        return palette.first { $0.hex == wanted }
    }

    /// The fill to paint: the chosen colour, or the app's own colour for Automatic.
    public static func fill(for colour: IconColour?, automatic: Color) -> Color {
        colour?.fillColor ?? automatic
    }

    /// The icon's colour on that fill: the palette's ink, white for Automatic.
    public static func markInk(for colour: IconColour?) -> Color {
        colour?.inkColor ?? .white
    }
}

extension Color {
    /// "#7c5cd6" (or "7c5cd6", or "#abc") to a colour. Anything unreadable is the palette's grey.
    init(hex: String) {
        var text = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if text.hasPrefix("#") { text.removeFirst() }
        if text.count == 3 { text = text.map { "\($0)\($0)" }.joined() }
        let value = UInt32(text.prefix(6), radix: 16) ?? 0x64748b
        self.init(
            .sRGB,
            red: Double((value >> 16) & 0xff) / 255,
            green: Double((value >> 8) & 0xff) / 255,
            blue: Double(value & 0xff) / 255,
            opacity: 1
        )
    }
}
