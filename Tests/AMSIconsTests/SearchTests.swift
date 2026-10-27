import Foundation
import XCTest
@testable import AMSIcons

/// The one search every AMS app's picker uses, over both sets of icons: what an empty search
/// gives, the order of the headings, words in English and Swedish, accents, several words at
/// once, and what the picker leaves out on a device that cannot draw a symbol.
///
/// The hand-drawn icons are the Packing app's and are certain, so most of the words here are
/// theirs. A check on one of Apple's symbols is only made when that symbol is in the catalog.
final class SearchTests: XCTestCase {
    private static func isHand(_ ref: IconRef) -> Bool {
        ref.kind == .hand
    }

    /// Every icon a search finds, in the picker's order.
    private func found(_ query: String) -> [IconRef] {
        IconLibrary.search(query).flatMap { $0.refs }
    }

    /// The keys of the hand-drawn icons a search finds, in the picker's order.
    private func handKeys(_ query: String) -> [String] {
        IconLibrary.search(query, keeping: Self.isHand).flatMap { $0.refs }.map { $0.name }
    }

    /// Every heading the picker can show, in its order: the hand-drawn groups, then Apple's.
    private var headingOrder: [String] {
        let hand = HandIconGroup.allCases.map { "hand." + $0.rawValue }
        let apple = SymbolGroup.allCases.map { "symbol." + $0.rawValue }
        return hand + apple
    }

    /// The headings an empty search gives: every group that has an icon, in the picker's order.
    private var everyHeading: [String] {
        let hand = HandIconGroup.allCases.filter { group in
            HandIconCatalog.all.contains { $0.group == group }
        }
        let apple = SymbolGroup.allCases.filter { group in
            SymbolCatalog.all.contains { $0.group == group }
        }
        let handIDs = hand.map { "hand." + $0.rawValue }
        let appleIDs = apple.map { "symbol." + $0.rawValue }
        return handIDs + appleIDs
    }

    // MARK: - Everything, in the picker's order

    func testAnEmptySearchGivesEveryHeadingAndEveryIcon() {
        let sections = IconLibrary.search("")
        XCTAssertEqual(sections.map(\.id), everyHeading)
        XCTAssertEqual(sections.flatMap { $0.refs }, IconLibrary.allRefs, "an empty search left an icon out or moved one")
        XCTAssertEqual(IconLibrary.allRefs.count, HandIconCatalog.all.count + SymbolCatalog.all.count)
        XCTAssertFalse(sections.contains { $0.refs.isEmpty }, "a heading with nothing under it")
        // Spaces, commas and line breaks alone are no search.
        for blank in [" ", "   ", ",", " , ,", "\n"] {
            XCTAssertEqual(IconLibrary.search(blank).map(\.id), everyHeading, "'\(blank)' was taken as a search")
        }
    }

    func testEveryHeadingIsNamedForItsSetAndItsGroup() {
        XCTAssertEqual(IconLibrary.handHeading, "Hand-drawn")
        XCTAssertEqual(IconLibrary.symbolHeading, "Apple symbols")
        let dot = " \u{00B7} "
        for section in IconLibrary.search("") {
            switch section.kind {
            case .hand:
                let group = HandIconGroup.allCases.first { "hand." + $0.rawValue == section.id }
                XCTAssertNotNil(group, "an unknown heading: \(section.id)")
                XCTAssertEqual(section.groupTitle, group?.title, section.id)
                XCTAssertEqual(section.title, IconLibrary.handHeading + dot + section.groupTitle)
                XCTAssertTrue(section.refs.allSatisfy { IconLibrary.handIcon(for: $0)?.group == group },
                              "\(section.id) holds an icon of another heading")
            case .symbol:
                let group = SymbolGroup.allCases.first { "symbol." + $0.rawValue == section.id }
                XCTAssertNotNil(group, "an unknown heading: \(section.id)")
                XCTAssertEqual(section.groupTitle, group?.title, section.id)
                XCTAssertEqual(section.title, IconLibrary.symbolHeading + dot + section.groupTitle)
                XCTAssertTrue(section.refs.allSatisfy { IconLibrary.symbolIcon(for: $0)?.group == group },
                              "\(section.id) holds an icon of another heading")
            }
        }
    }

    func testTheHandDrawnHeadingsComeFirstInEverySearch() {
        let order = headingOrder
        for query in ["", "book", "bok", "cykel", "båt", "sun", "a", "e", "travel", "flyg", "heart"] {
            let ids = IconLibrary.search(query).map(\.id)
            let places = ids.compactMap { order.firstIndex(of: $0) }
            XCTAssertEqual(places.count, ids.count, "'\(query)': a heading the picker does not know: \(ids)")
            XCTAssertEqual(places, places.sorted(), "'\(query)': the headings are out of order: \(ids)")
            XCTAssertEqual(Set(ids).count, ids.count, "'\(query)': a heading twice: \(ids)")
        }
    }

    /// `matches` and `search` give the same answer, so a picker that filters by one and a test
    /// that asks the other cannot disagree.
    func testMatchesAndSearchAgree() {
        for query in ["", "bike", "cykel", "båt", "bat", "open book", "beach,ball", "zzzqxw"] {
            let byMatches = Set(IconLibrary.allRefs.filter { IconLibrary.matches($0, query) })
            XCTAssertEqual(byMatches, Set(found(query)), "'\(query)'")
        }
    }

    // MARK: - Words he types

    func testEnglishWordsFindTheHandDrawnIcon() {
        let wanted: [(typed: String, key: String)] = [
            ("bike", "bike"), ("bicycle", "bike"), ("plane", "plane"), ("airplane", "plane"),
            ("tent", "tent"), ("car", "car"), ("book", "book"), ("coffee", "coffee"),
            ("beach", "beach"), ("shoes", "shoes"), ("kids", "kids"),
        ]
        for want in wanted {
            let keys = handKeys(want.typed)
            XCTAssertTrue(keys.contains(want.key), "'\(want.typed)' does not find \(want.key): \(keys)")
        }
    }

    func testSwedishWordsFindTheHandDrawnIcon() {
        let wanted: [(typed: String, key: String)] = [
            ("cykel", "bike"), ("tält", "tent"), ("bil", "car"), ("bok", "book"), ("läsa", "book"),
            ("båt", "ferry"), ("båt", "sail"), ("kaffe", "coffee"), ("pengar", "wallet"),
            ("hälsa", "heart"), ("tåg", "train"), ("flyg", "plane"), ("barn", "kids"),
        ]
        for want in wanted {
            let keys = handKeys(want.typed)
            XCTAssertTrue(keys.contains(want.key), "'\(want.typed)' does not find \(want.key): \(keys)")
        }
    }

    /// One word finds both kinds, and the hand-drawn one comes first.
    func testOneWordFindsBothKindsWithTheHandDrawnFirst() throws {
        try XCTSkipIf(SymbolCatalog.all.isEmpty, "Apple's symbols are not in the catalog yet")
        let wanted: [(typed: String, hand: String, symbol: String)] = [
            ("cykel", "bike", "bicycle"), ("bok", "book", "book"), ("läsa", "book", "book"),
            ("pengar", "wallet", "banknote"), ("hälsa", "heart", "heart"), ("båt", "ferry", "ferry"),
            ("flyg", "plane", "airplane"), ("airplane", "plane", "airplane"),
        ]
        for want in wanted {
            guard IconLibrary.symbolIcon(want.symbol) != nil else { continue }
            let refs = found(want.typed)
            let hand = refs.firstIndex(of: .hand(want.hand))
            let apple = refs.firstIndex(of: .symbol(want.symbol))
            XCTAssertNotNil(hand, "'\(want.typed)' does not find the hand-drawn \(want.hand)")
            XCTAssertNotNil(apple, "'\(want.typed)' does not find Apple's \(want.symbol)")
            if let hand, let apple {
                XCTAssertLessThan(hand, apple, "'\(want.typed)': Apple's \(want.symbol) came before the hand-drawn \(want.hand)")
            }
        }
        // There is no hand-drawn garden, so a garden is one of Apple's.
        for typed in ["trädgård", "tradgard"] {
            let apple = found(typed).filter { $0.kind == .symbol }
            XCTAssertFalse(apple.isEmpty, "'\(typed)' finds no symbol: add the word to a garden symbol")
        }
    }

    // MARK: - Capitals, accents and spaces

    func testCapitalsAndSpacesAroundTheWordsDoNotCount() {
        XCTAssertFalse(found("cykel").isEmpty)
        XCTAssertEqual(found("CYKEL"), found("cykel"))
        XCTAssertEqual(found("Cykel"), found("cykel"))
        XCTAssertEqual(found("Båt"), found("båt"))
        XCTAssertEqual(found("  tält  "), found("tält"))
        XCTAssertEqual(found("Beach Ball"), found("beach ball"))
    }

    /// "tradgard" finds "trädgård": an accent left out does not count. So a word typed without
    /// its accents finds at least what it finds with them.
    func testAnAccentLeftOutDoesNotCount() {
        XCTAssertTrue(handKeys("talt").contains("tent"))
        XCTAssertTrue(handKeys("lasa").contains("book"))
        XCTAssertTrue(handKeys("halsa").contains("heart"))
        XCTAssertTrue(handKeys("fjall").contains("mountain"))
        XCTAssertTrue(handKeys("tag").contains("train"))
        let pairs: [(typed: String, plain: String)] = [
            ("tält", "talt"), ("läsa", "lasa"), ("båt", "bat"), ("hälsa", "halsa"),
            ("fjäll", "fjall"), ("trädgård", "tradgard"), ("tåg", "tag"),
        ]
        for pair in pairs {
            let withAccent = Set(found(pair.typed))
            let without = Set(found(pair.plain))
            XCTAssertTrue(withAccent.isSubset(of: without),
                          "'\(pair.plain)' misses what '\(pair.typed)' finds: \(withAccent.subtracting(without))")
        }
    }

    /// An accent typed does count: in Swedish å, ä and ö are letters of their own, and a boat
    /// is never a bath.
    func testAnAccentTypedCounts() {
        XCTAssertTrue(handKeys("bat").contains("icebath"), "the check below would prove nothing")
        XCTAssertFalse(handKeys("båt").contains("icebath"), "båt found the ice bath")
        XCTAssertFalse(handKeys("båt").contains("swim"), "båt found a bath")
        for typed in ["båt", "tält", "läsa", "hälsa", "tåg", "fjäll", "trädgård"] {
            for ref in found(typed) {
                let texts = IconLibrary.texts(for: ref)
                XCTAssertTrue(texts.contains { $0.range(of: typed, options: .caseInsensitive) != nil },
                              "'\(typed)' found \(ref) by a word without its accent: \(texts)")
            }
        }
    }

    /// Curly quotes are the straight ones, so a word typed on a phone (which curls them) finds
    /// the word written with straight ones.
    func testCurlyQuotesAreTheStraightOnes() {
        XCTAssertTrue(IconLibrary.matches(.hand("children's"), "children\u{2019}s"))
        XCTAssertTrue(IconLibrary.matches(.hand("children's"), "children\u{2018}s"))
        XCTAssertTrue(IconLibrary.matches(.hand("\"quiet\""), "\u{201C}quiet\u{201D}"))
        XCTAssertEqual(found("children\u{2019}s"), found("children's"))
    }

    // MARK: - Several words

    func testEveryWordMustBeFound() {
        XCTAssertEqual(handKeys("beach ball"), ["beachball"])
        XCTAssertEqual(handKeys("sun glasses"), ["glasses"])
        XCTAssertEqual(handKeys("flyg tåg"), [], "no icon is both a plane and a train")
        XCTAssertLessThan(handKeys("beach ball").count, handKeys("beach").count, "a second word did not narrow")
        XCTAssertEqual(IconLibrary.search("bike zzzqxw"), [], "a word that is nowhere still found something")
        // Each word may be found in a different one of the icon's words.
        XCTAssertEqual(handKeys("plane flyg"), ["plane"], "its label and a hidden word")
        XCTAssertEqual(handKeys("weekendbag helg"), ["weekendbag"], "its key and a hidden word")
        XCTAssertEqual(handKeys("cykel fahrrad"), ["bike"], "two of its hidden words")
        // The order of the words does not count, and a comma is a space.
        XCTAssertEqual(found("ball beach"), found("beach ball"))
        XCTAssertEqual(found("beach,ball"), found("beach ball"))
        XCTAssertEqual(found("sun, glasses"), found("sun glasses"))
    }

    /// Two words find what both words find, each on its own, over both sets of icons.
    func testTwoWordsFindWhatEachWordFinds() {
        let pairs: [(one: String, other: String)] = [
            ("beach", "ball"), ("sun", "glasses"), ("cykel", "fahrrad"), ("book", "open"),
            ("bok", "läsa"), ("flyg", "tåg"), ("run", "shoes"), ("bike", "helmet"), ("heart", "hälsa"),
        ]
        for pair in pairs {
            let both = found(pair.one + " " + pair.other)
            let other = Set(found(pair.other))
            let expected = found(pair.one).filter { other.contains($0) }
            XCTAssertEqual(both, expected, "'\(pair.one) \(pair.other)'")
        }
    }

    func testTheHeadingsAreNotSearched() {
        // "Outdoors" and "Everyday" are headings of hand-drawn icons, and no icon has the word.
        XCTAssertEqual(handKeys("outdoors"), [])
        XCTAssertEqual(handKeys("Everyday"), [])
    }

    func testNonsenseFindsNothing() {
        XCTAssertEqual(IconLibrary.search("zzzqxw"), [])
        XCTAssertEqual(found("zzzqxw"), [])
    }

    // MARK: - Every icon

    /// Every icon in both sets is found by its label, its key or name, and each hidden word,
    /// and under its own heading.
    func testEveryIconIsFoundByItsOwnWordsUnderItsOwnHeading() {
        for ref in IconLibrary.allRefs {
            guard let label = IconLibrary.label(for: ref) else {
                XCTFail("\(ref) is in the library with no label")
                continue
            }
            XCTAssertTrue(IconLibrary.matches(ref, label), "\(ref): its label '\(label)' does not find it")
            XCTAssertTrue(IconLibrary.matches(ref, ref.name), "\(ref): its name does not find it")
            for word in IconLibrary.hiddenWords(for: ref) {
                XCTAssertTrue(IconLibrary.matches(ref, word), "\(ref): its word '\(word)' does not find it")
            }
        }
        for icon in HandIconCatalog.all {
            let sections = IconLibrary.search(icon.key, keeping: { $0 == icon.ref })
            XCTAssertEqual(sections.map(\.id), ["hand." + icon.group.rawValue], icon.key)
        }
        for symbol in SymbolCatalog.all {
            let sections = IconLibrary.search(symbol.name, keeping: { $0 == symbol.ref })
            XCTAssertEqual(sections.map(\.id), ["symbol." + symbol.group.rawValue], symbol.name)
        }
    }

    // MARK: - What this device can draw

    func testThePickerLeavesOutOnlyWhatThisDeviceCannotDraw() {
        XCTAssertTrue(IconLibrary.canDraw(.hand("bike")))
        XCTAssertFalse(IconLibrary.canDraw(.hand("no-such-icon")))
        XCTAssertTrue(IconLibrary.canDraw(.symbol("star")), "this system has no star")
        XCTAssertFalse(IconLibrary.canDraw(.symbol("no.such.symbol.anywhere")))
        XCTAssertFalse(IconLibrary.canDraw(.symbol("")))
        // Asked again, the same answers: the second ones come from what was kept.
        XCTAssertTrue(IconLibrary.canDraw(.symbol("star")))
        XCTAssertFalse(IconLibrary.canDraw(.symbol("no.such.symbol.anywhere")))
        // The picker's grid: every hand-drawn icon, and every symbol this system has.
        let kept = IconLibrary.search("", keeping: IconLibrary.canDraw).flatMap { $0.refs }
        XCTAssertEqual(kept.filter { $0.kind == .hand }, HandIconCatalog.all.map(\.ref))
        XCTAssertEqual(kept, IconLibrary.allRefs.filter { IconLibrary.canDraw($0) })
        let cannot = IconLibrary.allRefs.filter { !IconLibrary.canDraw($0) }
        XCTAssertTrue(cannot.allSatisfy { $0.kind == .symbol }, "a hand-drawn icon cannot be drawn: \(cannot)")
    }
}
