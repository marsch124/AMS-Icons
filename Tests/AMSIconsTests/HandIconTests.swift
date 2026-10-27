import XCTest
import SwiftUI
@testable import AMSIcons

/// The hand-drawn icons, held to the rules the AMS Packing app holds them to: the 132 of that
/// app with their keys, labels, headings and order; a key of its own each, which never changes;
/// a label of its own; a drawing the package's own reader can read in full, inside the 24-point
/// box; and hidden words that find each icon, in English, Swedish and German.
final class HandIconTests: XCTestCase {
    /// Every key an app may have stored, under its heading, in the picker's order: the Packing
    /// app's, copied. A key is never renamed, moved to another heading or taken away. A new icon
    /// goes at the end of its heading, and its key is added at the end of that list here.
    private static let storedKeys: [(group: HandIconGroup, keys: [String])] = [
        (group: .travel, keys: [
            "car", "plane", "rv", "train", "bus", "motorbike", "ferry", "suitcase", "weekendbag", "backpack",
            "box", "passport", "ticket", "map", "hotel", "cottage", "globe", "pillow", "scooter",
        ]),
        (group: .outdoors, keys: [
            "hiking", "walk", "mountain", "compass", "tent", "fire", "headlamp", "ski", "snow", "rain",
            "fishing", "xcski", "skate", "sled", "sleepingbag", "binoculars", "thermos", "mittens", "jacket",
            "mushroom",
        ]),
        (group: .sport, keys: [
            "run", "bike", "swim", "triathlon", "diving", "fin", "kayak", "climb", "golf", "racket",
            "strength", "kettlebell", "mobility", "yoga", "lotus", "breath", "sauna", "icebath", "watch",
            "bottle", "rowing", "stopwatch", "pulse", "trophy", "helmet", "pump", "wetsuit", "tank",
            "yogamat", "sup", "lifejacket",
        ]),
        (group: .beach, keys: [
            "sun", "lounger", "beach", "palm", "glasses", "sunhat", "suncream", "flipflops", "towel",
            "beachball", "swimring", "shell", "surf", "sail", "kite", "icecream", "bucket", "anchor",
            "midsummer",
        ]),
        (group: .city, keys: [
            "city", "restaurant", "food", "coffee", "wine", "picnic", "bbq", "shopping", "party", "gift",
            "music", "camera", "book", "pizza", "museum", "cake", "rings", "xmastree", "cinema",
            "ferriswheel",
        ]),
        (group: .everyday, keys: [
            "laptop", "briefcase", "phone", "plug", "headphones", "wallet", "keys", "clothes", "shoes",
            "laundry", "toiletry", "pill", "firstaid", "heart", "sleep", "kids", "paw", "toothbrush",
            "battery", "badge", "notebook", "suit", "pram",
        ]),
    ]

    /// Only the hand-drawn icons, so these tests mean the same once Apple's symbols are in the
    /// catalog too.
    private static func isHand(_ ref: IconChoice) -> Bool {
        ref.kind == .hand
    }

    /// The keys of the hand-drawn icons a search finds, in the picker's order.
    private func handKeys(_ query: String) -> [String] {
        IconLibrary.search(query, keeping: Self.isHand).flatMap { $0.refs }.map { $0.name }
    }

    // MARK: - The catalog

    func testTheyAreThe132OfThePackingAppInTheirOrder() {
        let all = HandIconCatalog.all
        XCTAssertEqual(all.count, 132, "the Packing app has 132; a new drawing changes this number on purpose")
        XCTAssertEqual(IconLibrary.hand, all)
        XCTAssertEqual(Self.storedKeys.map { $0.group }, HandIconGroup.allCases)
        XCTAssertEqual(Self.storedKeys.flatMap { $0.keys }.count, 132)
        for entry in Self.storedKeys {
            let here = all.filter { $0.group == entry.group }.map(\.key)
            XCTAssertEqual(Array(here.prefix(entry.keys.count)), entry.keys,
                           "\(entry.group.title): a stored key moved, changed heading or went")
        }
    }

    func testEveryKeyIsItsOwnAndCanBeStored() {
        let keys = HandIconCatalog.all.map(\.key)
        let twice = Dictionary(grouping: keys, by: { $0 }).filter { $0.value.count > 1 }.keys.sorted()
        XCTAssertTrue(twice.isEmpty, "a key used twice: \(twice)")
        for key in keys {
            // Small letters a to z only, so "hand:<key>" can never be misread or cut short.
            XCTAssertFalse(key.isEmpty, "an icon with no key")
            XCTAssertTrue(key.allSatisfy { $0.isASCII && $0.isLowercase }, "'\(key)' is not small letters a to z")
            XCTAssertEqual(IconChoice(stored: "hand:" + key), .hand(key), key)
        }
    }

    func testEachIconIsFoundByItsKeyAndItsRef() {
        for icon in HandIconCatalog.all {
            XCTAssertEqual(icon.id, icon.key)
            XCTAssertEqual(icon.ref, .hand(icon.key))
            XCTAssertEqual(icon.ref.stored, "hand:" + icon.key)
            XCTAssertEqual(IconLibrary.handIcon(icon.key), icon, icon.key)
            XCTAssertEqual(IconLibrary.handIcon(for: icon.ref), icon, icon.key)
            XCTAssertNil(IconLibrary.symbolIcon(for: icon.ref), icon.key)
            XCTAssertEqual(IconLibrary.label(for: icon.ref), icon.label, icon.key)
            XCTAssertTrue(IconLibrary.exists(icon.ref), icon.key)
            XCTAssertEqual(IconLibrary.hiddenWords(for: icon.ref), HandIconKeywords.words[icon.key] ?? [], icon.key)
        }
        XCTAssertNil(IconLibrary.handIcon("nope"))
        XCTAssertNil(IconLibrary.handIcon(for: .hand("nope")))
        XCTAssertNil(IconLibrary.handIcon(for: .symbol("car")), "an Apple symbol is never a hand-drawn icon")
        XCTAssertNil(IconLibrary.label(for: .hand("nope")))
        XCTAssertFalse(IconLibrary.exists(.hand("nope")))
    }

    func testEveryIconHasALabelOfItsOwn() {
        let all = HandIconCatalog.all
        XCTAssertEqual(Set(all.map(\.label)).count, all.count, "two icons with the same label")
        for icon in all {
            XCTAssertFalse(icon.label.trimmingCharacters(in: .whitespaces).isEmpty, "\(icon.key) has no label")
            XCTAssertEqual(icon.label, icon.label.trimmingCharacters(in: .whitespacesAndNewlines),
                           "\(icon.key)'s label has spaces around it")
            XCTAssertNil(icon.label.unicodeScalars.first { $0.properties.isEmojiPresentation },
                         "\(icon.key)'s label has an emoji")
        }
        // As in the Packing app, the traps first: the suitcase is Travel, the yoga figure is
        // Stretch and the lotus is Yoga.
        let labels: [(key: String, label: String)] = [
            ("suitcase", "Travel"), ("weekendbag", "Weekend bag"), ("lounger", "On the beach"),
            ("yoga", "Stretch"), ("lotus", "Yoga"), ("laptop", "Work"), ("paw", "Dog"), ("fin", "Freediving"),
            ("box", "Boxes"), ("globe", "Abroad"), ("rings", "Wedding"), ("cake", "Birthday"),
        ]
        for expected in labels {
            XCTAssertEqual(IconLibrary.handIcon(expected.key)?.label, expected.label, expected.key)
        }
    }

    func testTheHeadingsAreThePackingAppsAndHoldEveryIconOnce() {
        XCTAssertEqual(HandIconGroup.allCases.map(\.title),
                       ["Travel", "Outdoors", "Sport", "Beach and summer", "City, food and fun", "Everyday"])
        let all = HandIconCatalog.all
        for group in HandIconGroup.allCases {
            XCTAssertFalse(all.filter { $0.group == group }.isEmpty, "\(group.title) has no icons")
        }
        // Each heading's icons stand together, the headings in the picker's order.
        let byHeading = HandIconGroup.allCases.flatMap { group in all.filter { $0.group == group } }
        XCTAssertEqual(byHeading.map(\.key), all.map(\.key), "a heading's icons do not stand together")
        // An empty search gives every heading, in that order, with every icon under it.
        let sections = IconLibrary.search("", keeping: Self.isHand)
        XCTAssertEqual(sections.map(\.id), HandIconGroup.allCases.map { "hand.\($0.rawValue)" })
        XCTAssertEqual(sections.map(\.title), HandIconGroup.allCases.map { "Hand-drawn · \($0.title)" })
        XCTAssertEqual(sections.map(\.groupTitle), HandIconGroup.allCases.map(\.title))
        XCTAssertTrue(sections.allSatisfy { $0.kind == .hand })
        XCTAssertEqual(sections.flatMap { $0.refs }, all.map(\.ref))
    }

    // MARK: - The drawings

    func testEveryDrawingUsesOnlyTheCommandsThePackageCanDraw() {
        XCTAssertEqual(SVGPath.commands, Set("MLHVCSQAZ"))
        let allowed = Set("MLHVCSQAZmlhvcsqaz0123456789 ,.-")
        for icon in HandIconCatalog.all {
            let other = icon.path.filter { !allowed.contains($0) }
            XCTAssertTrue(other.isEmpty, "\(icon.key) has '\(other)' in its drawing")
        }
    }

    func testEveryDrawingIsReadInFullByThePackagesOwnReader() {
        for icon in HandIconCatalog.all {
            let fault = SVGPath.fault(in: icon.path)
            XCTAssertNil(fault, "\(icon.key): \(fault ?? "")")
            // Drawing one with an unknown command would stop on the reader's assertion.
            guard fault == nil else { continue }
            XCTAssertFalse(SVGPath.path(icon.path).isEmpty, "\(icon.key) draws nothing")
        }
    }

    func testEveryDrawingKeepsInsideTheBox() {
        for icon in HandIconCatalog.all {
            let fault = Self.boxFault(icon.path)
            XCTAssertNil(fault, "\(icon.key): \(fault ?? "")")
        }
    }

    /// The two checks above have teeth: each finds a drawing at fault.
    func testTheChecksFindADrawingAtFault() {
        XCTAssertEqual(SVGPath.fault(in: ""), "has no drawing")
        XCTAssertEqual(SVGPath.fault(in: "2 2"), "does not start with a command")
        XCTAssertEqual(SVGPath.fault(in: "M2 2C3 3"), "'C' is short of numbers")
        XCTAssertEqual(SVGPath.fault(in: "M2 2Z 3 3"), "numbers after Z")
        XCTAssertEqual(SVGPath.fault(in: "M2 2X5"), "cannot draw 'X'")
        XCTAssertNil(SVGPath.fault(in: "M2 2L5 5Z"))
        XCTAssertNotNil(Self.boxFault("M0 0L5 5"), "a point outside the box")
        XCTAssertNotNil(Self.boxFault("M2 2l22 0"), "a point outside the box, reached by a relative line")
        XCTAssertNotNil(Self.boxFault("L5 5"), "does not start with M")
        XCTAssertNotNil(Self.boxFault("M2 2"), "nothing drawn")
        XCTAssertNil(Self.boxFault("M2 2L5 5"))
    }

    func testEveryDrawingIsItsOwnAndIsThePackingAppsOwn() {
        let paths = HandIconCatalog.all.map(\.path)
        XCTAssertEqual(Set(paths).count, paths.count, "two icons share a drawing")
        // Copied, not redrawn: the first, the last and the weekend bag, character for character.
        XCTAssertEqual(IconLibrary.handIcon("car")?.path,
                       "M4 16.5V12.8L6.2 8.2c.3-.6.8-.9 1.5-.9h8.6c.7 0 1.2.3 1.5.9L20 12.8v3.7Z M4 12.8h16 M6.5 16.5v2.2 M17.5 16.5v2.2 M7.5 14.6h1 M15.5 14.6h1")
        XCTAssertEqual(IconLibrary.handIcon("pram")?.path,
                       "M3.5 11h13c0 2.8-2.5 5-5.5 5h-2c-3 0-5.5-2.2-5.5-5Z M3.5 11a6.5 6.5 0 0 1 6.5-6.5V11 M16.5 11 18.5 6.5h2 M5 20a1.8 1.8 0 1 0 3.6 0a1.8 1.8 0 1 0 -3.6 0 M12.4 20a1.8 1.8 0 1 0 3.6 0a1.8 1.8 0 1 0 -3.6 0")
        XCTAssertEqual(IconLibrary.handIcon("weekendbag")?.path,
                       "M6.5 9.5h11a4 4 0 0 1 4 4v2a4 4 0 0 1-4 4h-11a4 4 0 0 1-4-4v-2a4 4 0 0 1 4-4Z M6.5 9.5a5.5 5.5 0 0 1 11 0 M9.5 9.5a2.5 2.5 0 0 1 5 0 M6 13.2h12 M15.5 13.2v2.2")
    }

    /// The Packing app's own check of a drawing: only M L H V C S Q A Z, each with its numbers, and
    /// every point it reaches inside the 24-point box with a point to spare (a stroke 1.9 wide needs
    /// about one point of room). Nil when the drawing keeps to that.
    static func boxFault(_ d: String) -> String? {
        let counts: [Character: Int] = ["M": 2, "L": 2, "H": 1, "V": 1, "C": 6, "S": 4, "Q": 4, "A": 7, "Z": 0]
        var tokens: [String] = []
        var cur = ""
        func flush() { if !cur.isEmpty { tokens.append(cur); cur = "" } }
        for ch in d {
            if ch.isLetter { flush(); tokens.append(String(ch)) }
            else if ch == " " || ch == "," { flush() }
            else if ch == "-" || ch == "+" { flush(); cur = String(ch) }
            else if ch == "." && cur.contains(".") { flush(); cur = "." }
            else { cur.append(ch) }
        }
        flush()
        guard let first = tokens.first, first == "M" || first == "m" else { return "does not start with M" }
        var i = 0, cmd: Character = " ", x = 0.0, y = 0.0, sx = 0.0, sy = 0.0, drew = 0
        func inBox(_ px: Double, _ py: Double) -> Bool { px >= 1 && px <= 23 && py >= 1 && py <= 23 }
        while i < tokens.count {
            if let c = tokens[i].first, c.isLetter {
                guard counts[Character(c.uppercased())] != nil else { return "cannot draw '\(c)'" }
                cmd = c; i += 1
                if c == "Z" || c == "z" { x = sx; y = sy; continue }
            }
            let up = Character(cmd.uppercased())
            guard let n = counts[up], n > 0 else { return "numbers after Z" }
            var nums: [Double] = []
            for _ in 0..<n {
                guard i < tokens.count, let v = Double(tokens[i]) else { return "'\(cmd)' is short of numbers" }
                nums.append(v); i += 1
            }
            let rel = cmd.isLowercase
            switch up {
            case "H": x = rel ? x + nums[0] : nums[0]
            case "V": y = rel ? y + nums[0] : nums[0]
            case "A":
                guard nums[3] == 0 || nums[3] == 1, nums[4] == 0 || nums[4] == 1 else { return "an arc flag that is not 0 or 1" }
                x = rel ? x + nums[5] : nums[5]; y = rel ? y + nums[6] : nums[6]
            default:
                x = rel ? x + nums[n - 2] : nums[n - 2]; y = rel ? y + nums[n - 1] : nums[n - 1]
            }
            if up == "M" { sx = x; sy = y; if cmd == "M" { cmd = "L" } else { cmd = "l" } }
            guard inBox(x, y) else { return "a point outside the box: (\(x), \(y))" }
            drew += 1
        }
        return drew > 1 ? nil : "nothing drawn"
    }

    // MARK: - The hidden words

    func testEveryIconHasItsHiddenWordsAndEachFindsIt() {
        let known = Set(HandIconCatalog.all.map(\.key))
        for key in HandIconKeywords.words.keys {
            XCTAssertTrue(known.contains(key), "hidden words for an icon that is not there: \(key)")
        }
        XCTAssertEqual(HandIconKeywords.words.count, HandIconCatalog.all.count, "an icon with no hidden words")
        // The Packing app's 1065 words were all copied; more may be added, none lost by accident.
        XCTAssertGreaterThanOrEqual(HandIconKeywords.words.values.reduce(0) { $0 + $1.count }, 1065,
                                    "fewer hidden words than the Packing app's 1065")
        for icon in HandIconCatalog.all {
            let words = HandIconKeywords.words[icon.key] ?? []
            XCTAssertGreaterThanOrEqual(words.count, 3, "\(icon.key) has only \(words.count) hidden words")
            XCTAssertEqual(Set(words).count, words.count, "\(icon.key) has a word twice: \(words)")
            for word in words {
                XCTAssertFalse(word.trimmingCharacters(in: .whitespaces).isEmpty, "\(icon.key) has a blank word")
                XCTAssertEqual(word, Self.asMatched(word), "\(icon.key): '\(word)' is not written as it is matched")
                XCTAssertNil(word.unicodeScalars.first { $0.properties.isEmojiPresentation }, "\(icon.key): an emoji")
                // A word that does not find its own icon would be of no use.
                XCTAssertTrue(IconLibrary.matches(icon.ref, word), "\(icon.key): its word '\(word)' does not find it")
            }
        }
    }

    /// Small letters, nothing around it, one space between its words.
    private static func asMatched(_ word: String) -> String {
        word.lowercased().split(whereSeparator: { $0.isWhitespace }).joined(separator: " ")
    }

    // MARK: - The Packing app's searches

    /// The words he might type in the Packing app, each still finding the icon he means here.
    func testHisWordsFindTheIconInEnglishSwedishAndGerman() {
        let wanted: [(typed: String, key: String)] = [
            ("flyg", "plane"), ("Flug", "plane"), ("airport", "plane"), ("flight", "plane"),
            ("bil", "car"), ("Auto", "car"),
            ("husbil", "rv"), ("Wohnmobil", "rv"), ("camper", "rv"),
            ("cykel", "bike"), ("Fahrrad", "bike"), ("cycling", "bike"),
            ("simma", "swim"), ("schwimmen", "swim"), ("pool", "swim"), ("bad", "swim"),
            ("vandring", "hiking"), ("wandern", "hiking"), ("trek", "hiking"),
            ("strand", "lounger"), ("strand", "beach"), ("sea", "beach"),
            ("tåg", "train"), ("Zug", "train"), ("färja", "ferry"), ("tält", "tent"), ("Zelt", "tent"),
            ("skidor", "ski"), ("löpning", "run"), ("styrka", "strength"), ("gym", "strength"),
            ("bastu", "sauna"), ("isbad", "icebath"), ("solkräm", "suncream"), ("Sonnencreme", "suncream"),
            ("kaffe", "coffee"), ("fika", "coffee"), ("hund", "paw"), ("dog", "paw"), ("barn", "kids"),
            ("laddare", "plug"), ("charger", "plug"), ("medicin", "pill"), ("tvätt", "laundry"),
            ("jobb", "laptop"), ("work", "laptop"), ("helg", "weekendbag"), ("weekend", "weekendbag"),
            ("on the beach", "lounger"), ("Racket", "racket"),
        ]
        for want in wanted {
            let found = handKeys(want.typed)
            XCTAssertTrue(found.contains(want.key), "'\(want.typed)' does not find \(want.key): \(found)")
        }
    }

    func testTheNewerIconsAreFoundByTheirOwnWords() {
        let wanted: [(typed: String, key: String)] = [
            ("skridskor", "skate"), ("pulka", "sled"), ("längdskidor", "xcski"), ("vasaloppet", "xcski"),
            ("sovsäck", "sleepingbag"), ("kikare", "binoculars"), ("termos", "thermos"), ("vantar", "mittens"),
            ("regnjacka", "jacket"), ("svamp", "mushroom"), ("stuga", "cottage"), ("utomlands", "globe"),
            ("nackkudde", "pillow"), ("elsparkcykel", "scooter"), ("roddmaskin", "rowing"), ("erg", "rowing"),
            ("stoppur", "stopwatch"), ("puls", "pulse"), ("tävling", "trophy"), ("cykelhjälm", "helmet"),
            ("cykelpump", "pump"), ("våtdräkt", "wetsuit"), ("dykflaska", "tank"), ("yogamatta", "yogamat"),
            ("sup", "sup"), ("flytväst", "lifejacket"), ("glass", "icecream"), ("hink", "bucket"),
            ("skärgård", "anchor"), ("midsommar", "midsummer"), ("pizzeria", "pizza"), ("utställning", "museum"),
            ("tårta", "cake"), ("bröllop", "rings"), ("julgran", "xmastree"), ("bio", "cinema"),
            ("tivoli", "ferriswheel"), ("tandborste", "toothbrush"), ("powerbank", "battery"), ("namnbricka", "badge"),
            ("anteckningar", "notebook"), ("slips", "suit"), ("barnvagn", "pram"),
            ("Schlittschuh", "skate"), ("Riesenrad", "ferriswheel"), ("Kinderwagen", "pram"), ("Neoprenanzug", "wetsuit"),
            ("rowing machine", "rowing"), ("heart rate", "pulse"), ("maypole", "midsummer"), ("lanyard", "badge"),
        ]
        for want in wanted {
            let found = handKeys(want.typed)
            XCTAssertTrue(found.contains(want.key), "'\(want.typed)' does not find \(want.key): \(found)")
        }
    }

    /// The searches he relies on find exactly what they found in the Packing app, no more.
    func testHisSearchesFindNoMoreThanBefore() {
        XCTAssertEqual(handKeys("flyg"), ["plane"], "flyg finds more than the plane")
        XCTAssertEqual(handKeys("fahrrad"), ["bike"], "fahrrad finds more than the bike")
        XCTAssertEqual(handKeys("skridskor"), ["skate"])
        XCTAssertEqual(handKeys("midsommar"), ["midsummer"])
        XCTAssertEqual(handKeys("barnvagn"), ["pram"])
        // An accent typed counts: in Swedish å is a letter of its own, and a boat is no bath.
        XCTAssertEqual(handKeys("båt"), ["ferry", "sail"], "båt found a bath or sunbathing")
        XCTAssertEqual(handKeys("Båt"), ["ferry", "sail"])
        let boat = IconLibrary.search("båt", keeping: Self.isHand)
        XCTAssertEqual(boat.map(\.id), ["hand.travel", "hand.beach"], "a ferry and a sail, each under its own heading")
        let strand = IconLibrary.search("strand", keeping: Self.isHand)
        XCTAssertEqual(strand.map(\.id), ["hand.beach"])
        XCTAssertEqual(strand.flatMap { $0.refs }.map { $0.name }, ["lounger", "beach", "towel", "beachball"],
                       "strand finds more than the four beach icons")
    }

    func testCaseSpacesAndAnAccentLeftOutDoNotCount() {
        XCTAssertEqual(handKeys("FLYG"), handKeys("flyg"))
        XCTAssertEqual(handKeys("  flyg  "), handKeys("flyg"))
        XCTAssertTrue(handKeys("fjall").contains("mountain"), "an accent left out does not find fjäll")
        XCTAssertTrue(handKeys("schlussel").contains("keys"), "an accent left out does not find Schlüssel")
        // Nothing for nonsense; everything, in the picker's order, for nothing typed.
        let all = HandIconCatalog.all.map(\.key)
        XCTAssertEqual(handKeys("zzz"), [])
        XCTAssertEqual(handKeys(""), all)
        XCTAssertEqual(handKeys("   "), all, "spaces alone are a search")
        // The headings are not searched: "food" is the Food icon and the meal words, not all of
        // City, food and fun.
        XCTAssertFalse(handKeys("food").contains("camera"), "a heading's words brought its whole group")
    }
}
