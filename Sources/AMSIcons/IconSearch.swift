import Foundation

/// One heading of the picker and the icons under it, in the picker's order.
public struct IconSection: Identifiable, Hashable, Sendable {
    /// "hand.travel" or "symbol.work": stable, for `ForEach` and for test ids.
    public let id: String
    /// Which set the icons come from.
    public let kind: IconChoice.Kind
    /// The whole heading: "Hand-drawn · Travel" or "Apple symbols · Work and projects".
    public let title: String
    /// The group's own title alone: "Travel" or "Work and projects".
    public let groupTitle: String
    /// The icons, in the catalog's order.
    public let refs: [IconChoice]

    public init(id: String, kind: IconChoice.Kind, title: String, groupTitle: String, refs: [IconChoice]) {
        self.id = id
        self.kind = kind
        self.title = title
        self.groupTitle = groupTitle
        self.refs = refs
    }
}

/// Every icon in the package, looked up and searched in one place.
///
/// The search finds an icon by its label (what the picker writes under it), by its key or
/// symbol name, and by its hidden words (English, and the Swedish he might type). The group
/// headings are not searched: "food" must not bring a whole heading.
///
/// How a word matches, as in the Packing app's picker:
/// - Capitals do not count, and spaces around the words do not count.
/// - A word may stand anywhere inside a longer word: "cykel" finds "elcykel".
/// - An accent left OUT does not count: "tradgard" finds "trädgård", "fjall" finds "fjäll".
/// - An accent TYPED does count, because in Swedish å, ä and ö are letters of their own:
///   "båt" finds a boat and never "bath".
/// - With several words, every word must match (each anywhere in the icon's words), so
///   "open book" narrows "book".
/// - An empty search finds every icon.
public enum IconLibrary {
    /// The first half of a hand-drawn heading: "Hand-drawn · Travel".
    public static let handHeading = "Hand-drawn"
    /// The first half of an Apple heading: "Apple symbols · Work and projects".
    public static let symbolHeading = "Apple symbols"

    /// Every hand-drawn icon, in the catalog's order.
    public static var hand: [HandIcon] { HandIconCatalog.all }

    /// Every chosen SF Symbol, in the catalog's order.
    public static var symbols: [SymbolIcon] { SymbolCatalog.all }

    /// Every icon as what would be stored: the hand-drawn ones first, then Apple's.
    public static var allRefs: [IconChoice] {
        HandIconCatalog.all.map(\.ref) + SymbolCatalog.all.map(\.ref)
    }

    private static let handByKey: [String: HandIcon] = Dictionary(
        HandIconCatalog.all.map { ($0.key, $0) },
        uniquingKeysWith: { first, _ in first }
    )

    private static let symbolByName: [String: SymbolIcon] = Dictionary(
        SymbolCatalog.all.map { ($0.name, $0) },
        uniquingKeysWith: { first, _ in first }
    )

    /// The hand-drawn icon with this key, or nil.
    public static func handIcon(_ key: String) -> HandIcon? {
        handByKey[key]
    }

    /// The chosen SF Symbol with this name, or nil (a symbol that is not in the catalog).
    public static func symbolIcon(_ name: String) -> SymbolIcon? {
        symbolByName[name]
    }

    /// The hand-drawn icon a ref points at, or nil (an Apple symbol, or an unknown key).
    public static func handIcon(for ref: IconChoice) -> HandIcon? {
        ref.kind == .hand ? handByKey[ref.name] : nil
    }

    /// The SF Symbol a ref points at, or nil (a hand-drawn icon, or a name not in the catalog).
    public static func symbolIcon(for ref: IconChoice) -> SymbolIcon? {
        ref.kind == .symbol ? symbolByName[ref.name] : nil
    }

    /// What the picker writes under this icon, or nil when it is not in the catalog.
    public static func label(for ref: IconChoice) -> String? {
        switch ref.kind {
        case .hand: return handByKey[ref.name]?.label
        case .symbol: return symbolByName[ref.name]?.label
        }
    }

    /// Is this icon in the package's catalog? (Whether this device's system can draw an Apple
    /// symbol is a different question, answered by the views.)
    public static func exists(_ ref: IconChoice) -> Bool {
        label(for: ref) != nil
    }

    /// The hidden words this icon is found by. Never shown.
    public static func hiddenWords(for ref: IconChoice) -> [String] {
        switch ref.kind {
        case .hand: return HandIconKeywords.words[ref.name] ?? []
        case .symbol: return symbolByName[ref.name]?.words ?? []
        }
    }

    /// Does this icon answer the search? Every icon does for an empty search.
    public static func matches(_ ref: IconChoice, _ query: String) -> Bool {
        let needles = Needle.all(in: query)
        if needles.isEmpty { return true }
        return matches(texts(for: ref), needles)
    }

    /// The picker's headings with the icons the search finds under each: the hand-drawn
    /// headings first, then Apple's, each in its own order. A heading with nothing found is left
    /// out. An empty search gives every heading with every icon.
    public static func search(_ query: String) -> [IconSection] {
        search(query, keeping: { _ in true })
    }

    /// The same, keeping only the icons `keep` says yes to (the picker uses it to leave out an
    /// Apple symbol this device's system cannot draw). A heading left empty is left out.
    public static func search(_ query: String, keeping keep: (IconChoice) -> Bool) -> [IconSection] {
        let needles = Needle.all(in: query)
        var sections: [IconSection] = []
        for group in HandIconGroup.allCases {
            var refs: [IconChoice] = []
            for icon in HandIconCatalog.all where icon.group == group {
                let ref = icon.ref
                guard keep(ref), matches(texts(of: icon), needles) else { continue }
                refs.append(ref)
            }
            if refs.isEmpty { continue }
            sections.append(IconSection(
                id: "hand.\(group.rawValue)",
                kind: .hand,
                title: "\(handHeading) · \(group.title)",
                groupTitle: group.title,
                refs: refs
            ))
        }
        for group in SymbolGroup.allCases {
            var refs: [IconChoice] = []
            for symbol in SymbolCatalog.all where symbol.group == group {
                let ref = symbol.ref
                guard keep(ref), matches(texts(of: symbol), needles) else { continue }
                refs.append(ref)
            }
            if refs.isEmpty { continue }
            sections.append(IconSection(
                id: "symbol.\(group.rawValue)",
                kind: .symbol,
                title: "\(symbolHeading) · \(group.title)",
                groupTitle: group.title,
                refs: refs
            ))
        }
        return sections
    }

    // MARK: - Matching

    /// One word of a search, with the way it is compared.
    struct Needle {
        let text: String
        let options: String.CompareOptions

        init(_ text: String) {
            self.text = text
            // An accent typed counts; one left out does not (see the top of this type).
            let plain = text.folding(options: .diacriticInsensitive, locale: nil) == text
            self.options = plain ? [.caseInsensitive, .diacriticInsensitive] : [.caseInsensitive]
        }

        /// The words of a search: split at spaces and commas, curly quotes made straight.
        static func all(in query: String) -> [Needle] {
            query
                .split(whereSeparator: { $0.isWhitespace || $0 == "," })
                .map { Needle(straightened(String($0))) }
                .filter { !$0.text.isEmpty }
        }

        func isIn(_ haystack: String) -> Bool {
            haystack.range(of: text, options: options) != nil
        }

        /// Curly quotes and primes as the straight ones, so a search typed with a curly quote (as a
        /// phone types it) finds a word stored with a straight one. Only the search is straightened,
        /// never the icon's words.
        private static func straightened(_ s: String) -> String {
            var out = String.UnicodeScalarView()
            for u in s.unicodeScalars {
                switch u.value {
                case 0x2018, 0x2019, 0x201B, 0x2032: out.append("'")
                case 0x201C, 0x201D, 0x201E, 0x2033: out.append("\"")
                default: out.append(u)
                }
            }
            return String(out)
        }
    }

    /// Every word of the search is somewhere in the icon's words.
    static func matches(_ texts: [String], _ needles: [Needle]) -> Bool {
        needles.allSatisfy { needle in texts.contains(where: { needle.isIn($0) }) }
    }

    /// What a hand-drawn icon is found by: its label, its key and its hidden words.
    static func texts(of icon: HandIcon) -> [String] {
        [icon.label, icon.key] + (HandIconKeywords.words[icon.key] ?? [])
    }

    /// What an Apple symbol is found by: its label, its name and its hidden words.
    static func texts(of symbol: SymbolIcon) -> [String] {
        [symbol.label, symbol.name] + symbol.words
    }

    /// The same for any ref; an icon not in the catalog is found by its name alone.
    static func texts(for ref: IconChoice) -> [String] {
        switch ref.kind {
        case .hand:
            guard let icon = handByKey[ref.name] else { return [ref.name] }
            return texts(of: icon)
        case .symbol:
            guard let symbol = symbolByName[ref.name] else { return [ref.name] }
            return texts(of: symbol)
        }
    }
}
