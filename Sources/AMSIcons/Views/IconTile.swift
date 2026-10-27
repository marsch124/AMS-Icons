import SwiftUI

/// The rounded square in a colour with the icon on it: the Packing app's template cover, for
/// any AMS app (a project's or an area's mark in PARAGON).
///
/// The icon is drawn in the colour's own ink: white on the deep colours, dark on the light ones
/// (Yellow, Green, Sand …), where white cannot be read (`IconColour.markInk(for:)`). Automatic
/// (`colour` nil) fills the tile with `fallbackTint`, the app's own colour, with the icon in
/// white.
///
/// With no icon, or one this device cannot draw, the tile shows the first letter of `letter`
/// (a title, say) instead; with no letter either, the dashed "no icon" circle. Never an emoji:
/// the letter is the first real letter or digit, so a title that starts with an emoji still
/// gives a letter.
public struct IconTile: View {
    /// The icon on the tile. Nil shows the letter.
    public let ref: IconRef?
    /// The tile's colour. Nil is Automatic: `fallbackTint`.
    public let colour: IconColour?
    /// What Automatic looks like: the app's own colour for this kind of thing.
    public let fallbackTint: Color
    /// The words whose first letter is shown when there is no icon to draw.
    public let letter: String?
    /// The tile's width and height.
    public let size: CGFloat

    public init(_ ref: IconRef?, colour: IconColour? = nil, fallbackTint: Color,
                letter: String? = nil, size: CGFloat = 40) {
        self.ref = ref
        self.colour = colour
        self.fallbackTint = fallbackTint
        self.letter = letter
        self.size = size
    }

    public var body: some View {
        let ink = IconColour.markInk(for: colour)
        ZStack {
            RoundedRectangle(cornerRadius: size * 0.28)
                .fill(IconColour.fill(for: colour, automatic: fallbackTint))
            face(ink: ink)
        }
        .frame(width: size, height: size)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text(spokenName))
        .accessibilityAddTraits(.isImage)
    }

    /// The icon, else the letter, else the "no icon" circle.
    @ViewBuilder
    private func face(ink: Color) -> some View {
        if let ref, IconLibrary.canDraw(ref) {
            IconMark(ref, size: size * 0.66, colour: ink)
        } else if let initial = TileLetter.of(letter) {
            Text(initial)
                .font(.system(size: size * 0.46, weight: .heavy))
                .foregroundStyle(ink)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        } else {
            IconMark(nil, size: size * 0.66, colour: ink)
        }
    }

    /// What VoiceOver says: the icon's label when it is drawn, else "No icon".
    private var spokenName: String {
        if let ref, IconLibrary.canDraw(ref) {
            return IconLibrary.label(for: ref) ?? "Icon"
        }
        return "No icon"
    }
}

/// The letter a tile shows when it has no icon.
enum TileLetter {
    /// The first letter or digit of `text`, in capitals; nil when there is none. An emoji is
    /// never taken: a keycap digit ("1" with its frame) is not a plain digit.
    static func of(_ text: String?) -> String? {
        guard let text else { return nil }
        let found = text.first { character in
            character.isLetter || (character.isNumber && character.unicodeScalars.count == 1)
        }
        guard let character = found else { return nil }
        return String(character).uppercased()
    }
}
