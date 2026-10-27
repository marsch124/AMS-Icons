import XCTest
@testable import AMSIcons
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

/// The chosen SF Symbols: about 300 of them, each a name the system knows, each with a plain
/// English label and hidden words (English and Swedish) the search finds it by.
final class SymbolCatalogTests: XCTestCase {
    private var all: [SymbolIcon] { SymbolCatalog.all }

    func testThereAreAboutThreeHundred() {
        XCTAssertGreaterThanOrEqual(all.count, 280, "There should be about 300 symbols; there are \(all.count).")
        XCTAssertLessThanOrEqual(all.count, 330, "There should be about 300 symbols; there are \(all.count).")
    }

    func testEveryNameIsUnique() {
        var seen: Set<String> = []
        var twice: [String] = []
        for symbol in all {
            if !seen.insert(symbol.name).inserted {
                twice.append(symbol.name)
            }
        }
        XCTAssertEqual(twice, [], "These names are in the list more than once.")
    }

    func testEveryNameIsWrittenTheWayTheSystemSpellsIt() {
        let allowed = Set("abcdefghijklmnopqrstuvwxyz0123456789.")
        for symbol in all {
            let name = symbol.name
            XCTAssertFalse(name.isEmpty, "A symbol has no name.")
            XCTAssertTrue(name.allSatisfy { allowed.contains($0) },
                          "'\(name)' has a character no SF Symbol name has (capitals, spaces, accents).")
            XCTAssertFalse(name.hasPrefix(".") || name.hasSuffix(".") || name.contains(".."),
                           "'\(name)' has a dot in the wrong place.")
        }
    }

    func testNoLogosAndNoProducts() {
        // Apple's logo and product pictures are trademarks; they are not icons for a project.
        let products = ["apple", "iphone", "ipad", "ipod", "airpod", "homepod", "airtag", "visionpro",
                        "icloud", "facetime", "safari", "shareplay", "macbook", "macmini", "macpro"]
        for symbol in all {
            let name = symbol.name
            XCTAssertFalse(name.split(separator: ".").contains("logo"), "'\(name)' is a logo.")
            for product in products {
                XCTAssertFalse(name.hasPrefix(product), "'\(name)' is a logo or a product.")
            }
        }
    }

    func testTheOutlineIsChosenWhereThereIsOne() {
        // So they sit well beside the hand-drawn line icons. A filled form is only here when
        // SF Symbols has no outline of that picture; add a name below only for that reason.
        let filled = all.map(\.name).filter { $0.split(separator: ".").contains("fill") }
        XCTAssertEqual(filled, ["flashlight.on.fill"], "A filled symbol was chosen where an outline exists.")
    }

    func testEveryLabelIsOneToThreePlainWords() {
        for symbol in all {
            let label = symbol.label
            XCTAssertFalse(label.isEmpty, "'\(symbol.name)' has no label.")
            XCTAssertEqual(label, label.trimmingCharacters(in: .whitespacesAndNewlines),
                           "'\(symbol.name)' has spaces around its label.")
            let words = label.split(separator: " ")
            XCTAssertTrue((1...3).contains(words.count),
                          "'\(symbol.name)' has a label of \(words.count) words: '\(label)'.")
            XCTAssertTrue(label.unicodeScalars.allSatisfy { $0.isASCII },
                          "'\(symbol.name)' has a label that is not plain English: '\(label)'.")
            if let first = label.first {
                XCTAssertTrue(first.isUppercase || first.isNumber,
                              "'\(symbol.name)' has a label that does not start with a capital: '\(label)'.")
            }
        }
    }

    func testNoTwoSymbolsShareALabel() {
        var seen: Set<String> = []
        var twice: [String] = []
        for symbol in all {
            if !seen.insert(symbol.label.lowercased()).inserted {
                twice.append(symbol.label)
            }
        }
        XCTAssertEqual(twice, [], "Two symbols with one label cannot be told apart in the picker.")
    }

    func testEverySymbolHasAtLeastTwoHiddenWords() {
        for symbol in all {
            XCTAssertGreaterThanOrEqual(symbol.words.count, 2, "'\(symbol.name)' has too few hidden words.")
            XCTAssertEqual(Set(symbol.words).count, symbol.words.count,
                           "'\(symbol.name)' has the same hidden word twice.")
            for word in symbol.words {
                XCTAssertFalse(word.isEmpty, "'\(symbol.name)' has an empty hidden word.")
                XCTAssertEqual(word, word.trimmingCharacters(in: .whitespacesAndNewlines),
                               "'\(symbol.name)' has spaces around the word '\(word)'.")
                XCTAssertEqual(word, word.lowercased(),
                               "'\(symbol.name)' has a word with capitals: '\(word)'.")
            }
        }
    }

    func testEveryGroupHasIcons() {
        for group in SymbolGroup.allCases {
            let count = all.filter { $0.group == group }.count
            XCTAssertGreaterThanOrEqual(count, 15, "'\(group.title)' has only \(count) symbols.")
            XCTAssertLessThanOrEqual(count, 30, "'\(group.title)' has \(count) symbols; that is a long heading.")
        }
    }

    func testTheListIsInThePickersOrder() {
        let order = SymbolGroup.allCases
        var last = 0
        for symbol in all {
            guard let index = order.firstIndex(of: symbol.group) else {
                XCTFail("'\(symbol.name)' is in a group the picker does not show.")
                continue
            }
            XCTAssertGreaterThanOrEqual(index, last,
                                        "'\(symbol.name)' stands outside its heading, '\(symbol.group.title)'.")
            last = index
        }
    }

    func testTheLibraryKnowsEverySymbol() {
        for symbol in all {
            XCTAssertTrue(IconLibrary.exists(symbol.ref), "'\(symbol.name)' is not found by the library.")
            XCTAssertEqual(IconLibrary.label(for: symbol.ref), symbol.label)
            XCTAssertEqual(IconLibrary.symbolIcon(symbol.name), symbol)
            XCTAssertEqual(IconChoice(stored: symbol.ref.stored), symbol.ref,
                           "'\(symbol.name)' does not come back the same after it is stored.")
        }
    }

    func testTheWordsHeWouldTypeFindTheSymbol() {
        let pairs: [(query: String, name: String)] = [
            ("cykel", "bicycle"),
            ("båt", "ferry"),
            ("segelbåt", "sailboat"),
            ("trädgård", "sprinkler.and.droplets"),
            ("tradgard", "camera.macro"),
            ("bok", "book"),
            ("läsa", "book"),
            ("hälsa", "heart"),
            ("pengar", "banknote"),
            ("löpning", "figure.run"),
            ("simning", "figure.pool.swim"),
            ("triathlon", "figure.outdoor.cycle"),
            ("fridykning", "lungs"),
            ("andning", "lungs"),
            ("kall dusch", "shower"),
            ("isbad", "snowflake"),
            ("styrketräning", "dumbbell"),
            ("längdskidor", "figure.skiing.crosscountry"),
            ("fjall", "mountain.2"),
            ("kaffe", "cup.and.saucer"),
            ("familj", "figure.2.and.child.holdinghands"),
            ("verktyg", "wrench.and.screwdriver"),
            ("meditation", "figure.mind.and.body"),
            ("artificiell intelligens", "point.3.connected.trianglepath.dotted"),
            ("open book", "book"),
        ]
        for pair in pairs {
            XCTAssertNotNil(IconLibrary.symbolIcon(pair.name), "'\(pair.name)' is not in the list.")
            XCTAssertTrue(IconLibrary.matches(.symbol(pair.name), pair.query),
                          "'\(pair.query)' does not find '\(pair.name)'.")
        }
        // An accent typed counts: a boat is not a bath.
        XCTAssertFalse(IconLibrary.matches(.symbol("bathtub"), "båt"))
    }

    #if canImport(AppKit)
    /// The test that catches a misspelt name. It asks this Mac for every symbol in the list.
    /// It cannot catch a name newer than SF Symbols 5 when the Mac running it is newer than
    /// macOS 14: such a name exists here and not on an iOS 17 or macOS 14 device.
    @MainActor
    func testEveryNameIsASymbolThisMacCanDraw() {
        let missing = all.map(\.name).filter {
            NSImage(systemSymbolName: $0, accessibilityDescription: nil) == nil
        }
        XCTAssertEqual(missing, [], "This Mac has no SF Symbol with these names. Each one is misspelt or too new.")
    }
    #elseif canImport(UIKit)
    /// The same question asked of an iPhone or iPad when the tests run there.
    @MainActor
    func testEveryNameIsASymbolThisDeviceCanDraw() {
        let missing = all.map(\.name).filter { UIImage(systemName: $0) == nil }
        XCTAssertEqual(missing, [], "This device has no SF Symbol with these names. Each one is misspelt or too new.")
    }
    #endif
}
