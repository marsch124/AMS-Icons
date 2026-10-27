import Foundation

/// The icon a note, a template or a list has chosen — what an app stores.
///
/// Stored as ONE string, so it fits in a settings line, a JSON field or a key-value store:
/// `hand:<key>` for one of the hand-drawn icons (`HandIconCatalog`), `symbol:<name>` for one of
/// Apple's SF Symbols (`SymbolCatalog`). Codable writes and reads that same string.
///
/// A bare word with no prefix ("bike") is NOT read as an icon: what an older value means is for
/// the app to decide, never guessed here. A hand-drawn key never changes once it has been stored.
///
/// The name is not `IconRef` on purpose: Apple's CoreServices already has a type called that, and
/// on the Mac an app that imports both would find the name ambiguous.
public struct IconChoice: Hashable, Codable, Sendable, Identifiable, CustomStringConvertible {
    /// Which of the two sets the icon comes from.
    public enum Kind: String, CaseIterable, Codable, Sendable {
        case hand
        case symbol

        /// What the stored string starts with: "hand:" or "symbol:".
        public var prefix: String { rawValue + ":" }
    }

    public let kind: Kind
    /// The hand-drawn icon's key ("bike"), or the SF Symbol's name ("figure.run").
    public let name: String

    /// Spaces and line breaks around the name are taken off.
    public init(kind: Kind, name: String) {
        self.kind = kind
        self.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// One of the hand-drawn icons, by its key.
    public static func hand(_ key: String) -> IconChoice { IconChoice(kind: .hand, name: key) }

    /// One of Apple's SF Symbols, by its system name.
    public static func symbol(_ name: String) -> IconChoice { IconChoice(kind: .symbol, name: name) }

    /// Reads a stored string. Spaces around it, and around the name, do not count. Nil for
    /// anything else: an empty string, a prefix with no name, an unknown prefix ("emoji:…",
    /// "Hand:…" — the prefix is written in small letters) or a bare word with no prefix.
    /// Whether the icon is in the catalog is not checked here: see `IconLibrary.exists(_:)`.
    public init?(stored: String) {
        let text = stored.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let kind = Kind.allCases.first(where: { text.hasPrefix($0.prefix) }) else { return nil }
        let name = String(text.dropFirst(kind.prefix.count)).trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty else { return nil }
        self.kind = kind
        self.name = name
    }

    /// The string to store: "hand:bike" or "symbol:figure.run".
    public var stored: String { kind.prefix + name }

    public var id: String { stored }

    public var description: String { stored }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let text = try container.decode(String.self)
        guard let ref = IconChoice(stored: text) else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "\"\(text)\" is not an icon. It must start with hand: or symbol:."
            )
        }
        self = ref
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(stored)
    }
}
