import SwiftUI
#if os(macOS)
import AppKit
#else
import UIKit
#endif

/// One icon, drawn at any size in one colour: what every AMS app shows where an icon was chosen.
///
/// - A hand-drawn icon is its 24-point drawing, stroked with round caps and joins at 1.9 points
///   on the 24-point box and scaled with it, so it looks the same at 14 points and at 60.
/// - An Apple symbol is drawn by the system (`Image(systemName:)`) at about the same size and
///   weight, in the same one colour.
/// - Nothing to draw (no icon, a hand-drawn key that is not in the catalog, or an Apple symbol
///   this device's system does not have) is a dashed circle, never an empty space: an empty
///   space looks like a fault, a circle looks like "no icon here".
///
/// The colour is `colour` when it is given, else the foreground style around it, so
/// `IconMark(ref).foregroundStyle(.white)` works as it does for text. VoiceOver reads the
/// icon's label ("Bicycle"); a row that says the same in words can hide it.
public struct IconMark: View {
    /// What to draw. Nil draws the "no icon" circle.
    public let ref: IconChoice?
    /// The width and height of the square it is drawn in.
    public let size: CGFloat
    /// Its colour. Nil takes the foreground style around it.
    public let colour: Color?
    /// The hand-drawn stroke on the 24-point box. 1.9 is the Packing app's.
    public let lineWidth: CGFloat

    public init(_ ref: IconChoice?, size: CGFloat = 24, colour: Color? = nil, lineWidth: CGFloat = 1.9) {
        self.ref = ref
        self.size = size
        self.colour = colour
        self.lineWidth = lineWidth
    }

    public var body: some View {
        drawing
            .frame(width: size, height: size)
            .modifier(OptionalForeground(colour: colour))
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(Text(spokenName))
            .accessibilityAddTraits(.isImage)
    }

    @ViewBuilder
    private var drawing: some View {
        if let ref, ref.kind == .hand, let icon = IconLibrary.handIcon(ref.name) {
            GridShape(d: icon.path)
                .stroke(style: StrokeStyle(lineWidth: lineWidth * size / 24, lineCap: .round, lineJoin: .round))
        } else if let ref, ref.kind == .symbol, SystemSymbols.has(ref.name) {
            Image(systemName: ref.name)
                .symbolRenderingMode(.monochrome)
                .font(.system(size: size * 0.8, weight: .medium))
        } else {
            IconPlaceholder(size: size, lineWidth: lineWidth)
        }
    }

    /// What VoiceOver says: the icon's label, else "No icon" or "Icon".
    private var spokenName: String {
        guard let ref else { return "No icon" }
        return IconLibrary.label(for: ref) ?? "Icon"
    }
}

/// The dashed circle drawn where there is no icon to draw.
struct IconPlaceholder: View {
    let size: CGFloat
    let lineWidth: CGFloat

    var body: some View {
        let width = lineWidth * size / 24
        Circle()
            .stroke(style: StrokeStyle(lineWidth: width, lineCap: .round, dash: [width * 1.6, width * 1.6]))
            .frame(width: size * 0.6, height: size * 0.6)
            .opacity(0.6)
    }
}

/// A colour when one is given; else the view keeps the foreground style around it.
private struct OptionalForeground: ViewModifier {
    let colour: Color?

    @ViewBuilder
    func body(content: Content) -> some View {
        if let colour {
            content.foregroundStyle(colour)
        } else {
            content
        }
    }
}

extension IconLibrary {
    /// Can this device draw this icon? A hand-drawn icon can when its key is in the catalog. An
    /// Apple symbol can when this device's system has a symbol of that name: an older iPhone or
    /// Mac may lack a newer symbol, and the picker leaves such a symbol out. The system is asked
    /// once per name; the answer is kept for as long as the app runs.
    public static func canDraw(_ ref: IconChoice) -> Bool {
        switch ref.kind {
        case .hand: return handIcon(ref.name) != nil
        case .symbol: return SystemSymbols.has(ref.name)
        }
    }
}

/// Which SF Symbols this device's system has, asked once per name.
enum SystemSymbols {
    /// The answers so far. A class with a lock, so the picker and a background thread can both
    /// ask. `@unchecked Sendable` because the lock is what keeps the dictionary safe.
    private final class Memory: @unchecked Sendable {
        private let lock = NSLock()
        private var answers: [String: Bool] = [:]

        func answer(for name: String) -> Bool? {
            lock.lock()
            defer { lock.unlock() }
            return answers[name]
        }

        func remember(_ answer: Bool, for name: String) {
            lock.lock()
            defer { lock.unlock() }
            answers[name] = answer
        }
    }

    private static let memory = Memory()

    static func has(_ name: String) -> Bool {
        guard !name.isEmpty else { return false }
        if let answer = memory.answer(for: name) {
            return answer
        }
        let answer = askSystem(name)
        memory.remember(answer, for: name)
        return answer
    }

    private static func askSystem(_ name: String) -> Bool {
        #if os(macOS)
        return NSImage(systemSymbolName: name, accessibilityDescription: nil) != nil
        #else
        return UIImage(systemName: name) != nil
        #endif
    }
}
