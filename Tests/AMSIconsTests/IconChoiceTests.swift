import XCTest
@testable import AMSIcons

/// A record an app might save, with an icon that may not have been chosen.
private struct Saved: Codable, Equatable {
    var title: String
    var icon: IconChoice?
}

/// What an app stores for an icon: one string, "hand:<key>" or "symbol:<name>".
final class IconChoiceTests: XCTestCase {
    func testAHandDrawnIconRoundTrips() {
        let ref = IconChoice.hand("bike")
        XCTAssertEqual(ref.kind, .hand)
        XCTAssertEqual(ref.name, "bike")
        XCTAssertEqual(ref.stored, "hand:bike")
        XCTAssertEqual(IconChoice(stored: ref.stored), ref)
    }

    func testAnAppleSymbolRoundTrips() {
        let ref = IconChoice.symbol("figure.run")
        XCTAssertEqual(ref.kind, .symbol)
        XCTAssertEqual(ref.name, "figure.run")
        XCTAssertEqual(ref.stored, "symbol:figure.run")
        XCTAssertEqual(IconChoice(stored: "symbol:figure.run"), ref)
        XCTAssertEqual(IconChoice(kind: .symbol, name: "figure.run"), ref)
    }

    func testSpacesAroundDoNotCount() {
        XCTAssertEqual(IconChoice(stored: "  hand:bike \n"), .hand("bike"))
        XCTAssertEqual(IconChoice(stored: "symbol: book "), .symbol("book"))
        XCTAssertEqual(IconChoice(kind: .hand, name: " bike "), .hand("bike"))
    }

    func testAnythingElseIsNotAnIcon() {
        let bad = ["", "   ", "bike", "figure.run", "hand:", "symbol:", "hand:   ", "symbol: \n",
                   "emoji:bike", "Hand:bike", "SYMBOL:book", ":bike", "hand", "symbol", "hand bike"]
        for text in bad {
            XCTAssertNil(IconChoice(stored: text), "'\(text)' was read as an icon")
        }
    }

    func testItIsStoredAsOneString() throws {
        let refs: [IconChoice] = [.hand("bike"), .symbol("book")]
        let data = try JSONEncoder().encode(refs)
        XCTAssertEqual(String(data: data, encoding: .utf8), #"["hand:bike","symbol:book"]"#)
        XCTAssertEqual(try JSONDecoder().decode([IconChoice].self, from: data), refs)
    }

    func testABareWordCannotBeDecoded() {
        let data = Data(#"["bike"]"#.utf8)
        XCTAssertThrowsError(try JSONDecoder().decode([IconChoice].self, from: data))
    }

    func testTheIdAndDescriptionAreTheStoredString() {
        let ref = IconChoice.symbol("leaf")
        XCTAssertEqual(ref.id, "symbol:leaf")
        XCTAssertEqual(ref.description, "symbol:leaf")
        XCTAssertEqual(IconChoice.Kind.hand.prefix, "hand:")
        XCTAssertEqual(IconChoice.Kind.symbol.prefix, "symbol:")
    }

    func testAHandAndASymbolOfTheSameNameAreDifferent() {
        XCTAssertNotEqual(IconChoice.hand("book"), IconChoice.symbol("book"))
        XCTAssertEqual(Set([IconChoice.hand("book"), .symbol("book"), .hand("book")]).count, 2)
    }

    func testThePrefixAloneDecidesTheKind() {
        // "car" is a hand-drawn key and also the name of an Apple symbol: the prefix says which.
        XCTAssertEqual(IconChoice(stored: "hand:car")?.kind, .hand)
        XCTAssertEqual(IconChoice(stored: "symbol:car")?.kind, .symbol)
        XCTAssertEqual(IconChoice(stored: "symbol:car")?.name, "car")
        XCTAssertNotEqual(IconChoice(stored: "hand:car"), IconChoice(stored: "symbol:car"))
    }

    func testEveryIconInThePackageIsStoredAndReadBackAsItself() throws {
        let refs = IconLibrary.allRefs
        XCTAssertEqual(refs.count, IconLibrary.hand.count + IconLibrary.symbols.count)
        XCTAssertEqual(Set(refs).count, refs.count, "two icons store the same string")
        for ref in refs {
            XCTAssertEqual(IconChoice(stored: ref.stored), ref, ref.stored)
            XCTAssertTrue(ref.stored.hasPrefix(ref.kind.prefix), ref.stored)
            // No space inside a name, so a stored icon reads back the same from any settings line.
            XCTAssertFalse(ref.name.contains(where: { $0.isWhitespace }), "'\(ref.stored)' has a space in it")
        }
        let data = try JSONEncoder().encode(refs)
        XCTAssertEqual(try JSONDecoder().decode([IconChoice].self, from: data), refs)
    }

    func testAnIconInARecordIsOneStringAndMayBeLeftOut() throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        let hiking = Saved(title: "Hiking", icon: .hand("hiking"))
        let data = try encoder.encode(hiking)
        XCTAssertEqual(String(data: data, encoding: .utf8), #"{"icon":"hand:hiking","title":"Hiking"}"#)
        XCTAssertEqual(try JSONDecoder().decode(Saved.self, from: data), hiking)
        // No icon chosen: nothing is written, and nothing read back.
        let plain = try encoder.encode(Saved(title: "Plain", icon: nil))
        XCTAssertEqual(String(data: plain, encoding: .utf8), #"{"title":"Plain"}"#)
        XCTAssertNil(try JSONDecoder().decode(Saved.self, from: plain).icon)
        // An old bare word is not an icon: the app decides what it meant, the package does not guess.
        let old = Data(#"{"title":"Old","icon":"bike"}"#.utf8)
        XCTAssertThrowsError(try JSONDecoder().decode(Saved.self, from: old))
    }

    func testAnIconThisCopyOfThePackageDoesNotKnowIsStillRead() {
        // A newer app may have stored an icon this copy of the package does not have yet. It is
        // read and kept, not thrown away; the package only says it is not in the catalog.
        let ref = IconChoice(stored: "hand:not-drawn-yet")
        XCTAssertEqual(ref, .hand("not-drawn-yet"))
        XCTAssertEqual(ref?.stored, "hand:not-drawn-yet")
        XCTAssertFalse(IconLibrary.exists(.hand("not-drawn-yet")))
        XCTAssertNil(IconLibrary.label(for: .hand("not-drawn-yet")))
        XCTAssertFalse(IconLibrary.exists(.symbol("not.a.symbol.name")))
        XCTAssertTrue(IconLibrary.exists(.hand("bike")))
    }
}
