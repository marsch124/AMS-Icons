import Foundation
import SwiftUI
import XCTest
@testable import AMSIcons

/// The icon palette: the Packing app's, with the same keys, names and colours, so a colour
/// means the same thing in every AMS app; Automatic and the fifteen fill exactly two rows of
/// eight in the picker; and the icon can be seen on every colour.
final class ColourTests: XCTestCase {
    /// One colour of the Packing app's palette (`TemplateColour.palette` in AMS Packing 0.100),
    /// as a Packing template may have stored it.
    private struct Packing {
        let key: String
        let name: String
        let hex: String
        let ink: String
    }

    /// The Packing app's palette, in its order. A key and its fill never change once stored.
    private static let packing: [Packing] = [
        Packing(key: "blue", name: "Blue", hex: "#0a84ff", ink: "#ffffff"),
        Packing(key: "yellow", name: "Yellow", hex: "#ffd60a", ink: "#3d3000"),
        Packing(key: "green", name: "Green", hex: "#30d158", ink: "#0b3a17"),
        Packing(key: "orange", name: "Orange", hex: "#ff8c1a", ink: "#4a2300"),
        Packing(key: "lavender", name: "Lavender", hex: "#bf9cff", ink: "#2e1a5c"),
        Packing(key: "pink", name: "Pink", hex: "#ff6fa8", ink: "#5a0f2e"),
        Packing(key: "red", name: "Red", hex: "#dc3d43", ink: "#ffffff"),
        Packing(key: "plum", name: "Plum", hex: "#9c3d8c", ink: "#ffffff"),
        Packing(key: "violet", name: "Violet", hex: "#7c5cd6", ink: "#ffffff"),
        Packing(key: "indigo", name: "Indigo", hex: "#4f46e5", ink: "#ffffff"),
        Packing(key: "navy", name: "Navy", hex: "#2a5194", ink: "#ffffff"),
        Packing(key: "olive", name: "Olive", hex: "#6e7b1f", ink: "#ffffff"),
        Packing(key: "sand", name: "Sand", hex: "#d9b98c", ink: "#3d2a10"),
        Packing(key: "brown", name: "Brown", hex: "#8b5e3c", ink: "#ffffff"),
        Packing(key: "slate", name: "Grey", hex: "#64748b", ink: "#ffffff"),
    ]

    // MARK: - The palette

    func testThePaletteIsThePackingAppsInItsOrder() {
        let palette = IconColour.palette
        XCTAssertEqual(palette.count, 15, "Automatic and fifteen: two rows of eight")
        XCTAssertEqual(palette.map(\.key), Self.packing.map { $0.key }, "a key changed, moved or went")
        XCTAssertEqual(palette.map(\.name), Self.packing.map { $0.name })
        XCTAssertEqual(palette.map(\.hex), Self.packing.map { $0.hex }, "a stored colour would ring nothing")
        XCTAssertEqual(palette.map(\.ink), Self.packing.map { $0.ink })
        for colour in palette {
            XCTAssertEqual(colour.id, colour.key)
        }
    }

    func testEveryKeyNameAndColourIsItsOwn() {
        let palette = IconColour.palette
        XCTAssertEqual(Set(palette.map(\.key)).count, palette.count, "two colours share a key")
        XCTAssertEqual(Set(palette.map(\.name)).count, palette.count, "two colours share a name")
        XCTAssertEqual(Set(palette.map(\.hex)).count, palette.count, "two colours share a fill")
        XCTAssertFalse(palette.contains { $0.key == IconColour.automaticKey }, "a colour took Automatic's key")
        XCTAssertFalse(palette.contains { $0.name == IconColour.automaticName }, "a colour took Automatic's name")
        XCTAssertEqual(IconColour.automaticKey, "auto", "the Packing app stores Automatic as auto")
        XCTAssertEqual(IconColour.automaticName, "Automatic")
        for colour in palette {
            // Small letters a to z, so `icon.colour.<key>` and a stored key can never be misread.
            XCTAssertTrue(colour.key.allSatisfy { $0.isASCII && $0.isLowercase }, "'\(colour.key)' is not small letters")
            XCTAssertTrue(Self.isStoredColour(colour.hex), "\(colour.key): \(colour.hex) is not written #rrggbb")
            XCTAssertTrue(Self.isStoredColour(colour.ink), "\(colour.key): its ink \(colour.ink) is not written #rrggbb")
            XCTAssertFalse(colour.name.isEmpty, "\(colour.key) has no name")
        }
    }

    /// The icon on its own tile: 3.5 : 1 or better, the Packing app's rule for a drawing. Dark
    /// ink on the light colours, where white cannot be read; white on the deep ones.
    func testTheIconCanBeSeenOnEveryColour() {
        for colour in IconColour.palette {
            let ratio = Self.contrast(colour.ink, colour.hex)
            XCTAssertGreaterThanOrEqual(ratio, 3.5, "\(colour.key): its icon does not read on it (\(ratio))")
        }
        let light: Set<String> = ["yellow", "green", "orange", "lavender", "pink", "sand"]
        for colour in IconColour.palette {
            if light.contains(colour.key) {
                XCTAssertNotEqual(colour.ink, "#ffffff", "\(colour.key) is light: white cannot be read on it")
            } else {
                XCTAssertEqual(colour.ink, "#ffffff", "\(colour.key) is deep: the icon is white on it")
            }
        }
    }

    // MARK: - The picker's two rows

    func testAutomaticAndTheFifteenFillTwoRowsOfEight() {
        XCTAssertEqual(IconColour.pickerRowCount, 2)
        XCTAssertEqual(IconColour.pickerColumnCount, 8)
        let rows = IconColour.pickerRows
        XCTAssertEqual(rows.count, 2, "the picker shows the colours in two rows")
        XCTAssertEqual(rows.map { $0.count }, [8, 8], "not two full rows of eight")
        let swatches = rows.flatMap { $0 }
        // `first` is an optional of an optional: no swatch at all, or a swatch that is nil.
        // Automatic is the nil one, and it comes first.
        guard let firstSwatch = swatches.first else {
            XCTFail("the picker has no swatches")
            return
        }
        XCTAssertTrue(firstSwatch == nil, "Automatic is not the first swatch")
        XCTAssertEqual(swatches.filter { $0 == nil }.count, 1, "Automatic is there once")
        XCTAssertEqual(swatches.compactMap { $0 }, IconColour.palette, "the palette is not in the rows, in its order")
        XCTAssertEqual(IconColour.pickerColumnCount * IconColour.pickerRowCount, IconColour.palette.count + 1)
    }

    // MARK: - Finding a stored colour

    func testAColourIsFoundByItsKey() {
        XCTAssertEqual(IconColour.of(key: "blue")?.name, "Blue")
        XCTAssertEqual(IconColour.of(key: " Blue ")?.key, "blue", "spaces and capitals count")
        XCTAssertEqual(IconColour.of(key: "SAND")?.key, "sand")
        XCTAssertEqual(IconColour.of(key: "slate")?.name, "Grey", "the grey is stored as slate, as in the Packing app")
        XCTAssertNil(IconColour.of(key: "auto"), "Automatic is no palette colour")
        XCTAssertNil(IconColour.of(key: ""))
        XCTAssertNil(IconColour.of(key: "   "))
        XCTAssertNil(IconColour.of(key: nil))
        XCTAssertNil(IconColour.of(key: "teal"), "there is no teal")
        for colour in IconColour.palette {
            XCTAssertEqual(IconColour.of(key: colour.key), colour, colour.key)
        }
    }

    func testAColourIsFoundByItsFill() {
        XCTAssertEqual(IconColour.of(hex: "#0A84FF")?.key, "blue", "capitals count")
        XCTAssertEqual(IconColour.of(hex: " #ffd60a ")?.key, "yellow", "spaces count")
        XCTAssertNil(IconColour.of(hex: "#123456"), "a colour from elsewhere is none of the palette")
        XCTAssertNil(IconColour.of(hex: ""))
        XCTAssertNil(IconColour.of(hex: nil))
        for colour in IconColour.palette {
            XCTAssertEqual(IconColour.of(hex: colour.hex), colour, colour.key)
        }
    }

    // MARK: - Automatic

    func testAutomaticIsTheAppsOwnColourWithAWhiteIcon() {
        XCTAssertEqual(IconColour.fill(for: nil, automatic: .orange), .orange)
        XCTAssertEqual(IconColour.markInk(for: nil), .white)
        let blue = IconColour.palette[0]
        XCTAssertNotEqual(IconColour.fill(for: blue, automatic: .orange), .orange, "a chosen colour lost to Automatic")
    }

    // MARK: - Helpers

    /// "#" and six small hex digits.
    private static func isStoredColour(_ text: String) -> Bool {
        guard text.count == 7, text.hasPrefix("#") else { return false }
        return text.dropFirst().allSatisfy { "0123456789abcdef".contains($0) }
    }

    /// WCAG relative luminance of "#rrggbb".
    private static func luminance(_ hex: String) -> Double {
        let value = UInt32(hex.dropFirst(), radix: 16) ?? 0
        func channel(_ shift: UInt32) -> Double {
            let c = Double((value >> shift) & 0xff) / 255
            return c <= 0.04045 ? c / 12.92 : pow((c + 0.055) / 1.055, 2.4)
        }
        return 0.2126 * channel(16) + 0.7152 * channel(8) + 0.0722 * channel(0)
    }

    /// WCAG contrast ratio of two "#rrggbb" colours.
    private static func contrast(_ a: String, _ b: String) -> Double {
        let la = luminance(a)
        let lb = luminance(b)
        return (max(la, lb) + 0.05) / (min(la, lb) + 0.05)
    }
}
