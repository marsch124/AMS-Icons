import XCTest
@testable import AMSIcons

final class AppMarkTests: XCTestCase {
    /// Marks are added, never renamed or taken away — apps name them in code.
    func testTheMarksAndTheirOrder() {
        XCTAssertEqual(AppMark.allCases.map(\.rawValue), [
            "inbox", "today", "calendar", "timeBlocks", "review", "map", "recent", "bin", "templates", "snippets",
            "tags", "search", "aspiration", "goal", "project", "area", "resource", "archive", "work", "daily",
            "capture", "sync", "read", "readOff", "back", "forward", "archiveDown", "moon", "sunrise", "cup",
            "hourglass", "link", "page", "cloud", "cloudDown", "warning", "warningCircle", "exclamation", "timer", "finished",
            "ringDashed", "compose", "bookmark", "listIndent", "info", "hand", "palette", "ruler", "repeat", "question",
            "clockAlert", "openLink", "openApp", "send", "arrowDownLeft", "arrowDown", "share", "parcel", "minus", "zoomIn",
            "zoomOut", "filter", "undo", "trayFull", "dot", "lock",
            "folder", "person", "clock",
            "drawer", "drawerOpen",
            "deckRaycast", "deckKeyboard", "deckText", "deckPlay", "deckNext", "deckPrevious", "deckVolumeUp", "deckVolumeDown", "deckMute", "deckFolder", "deckBack", "deckPageNext", "deckPagePrevious", "deckProfile", "deckMulti", "deckScript", "deckClipboard", "deckWindowLeft", "deckWindowRight", "deckWindowFull", "deckAi", "deckApp",
            "gridFlat", "gridEdge", "gridStanding", "gridAuto", "gridBin", "gridBins", "gridStrip", "gridPrintFile",
            "arrowUp", "arrowLeft", "arrowRight", "deckWindowTop", "deckWindowBottom",
            "lockOpen", "star",
            "seedMindMap", "seedBox", "seedRound", "seedDiamond", "seedOval", "seedArrow", "seedNote", "seedText", "seedFrame", "seedBoard", "seedSprout", "seedPin", "seedFit", "seedStarter", "redo", "duplicate",
            "deckEject", "deckVideo",
            "seedTimeline", "seedBar", "seedMilestone", "seedToday", "seedCalendar",
            "seedDraw", "seedRubber", "seedThin", "seedMedium", "seedThick",
            "seedSequence", "seedPerson", "seedAnswer",
            "seedDocument", "seedSlanted", "seedStore", "seedLanes",
            "seedLineUp", "seedEvenGaps", "seedSameSize",
            "seedOneWay", "seedBothWays", "seedNoEnds", "seedDashed",
            "seedMoveUp", "seedMoveDown", "seedOutLevel", "seedIdeaUnder", "seedNextIdea", "seedBranch",
            "seedBringBack", "seedEarlier", "seedExport", "seedSearch", "seedCut", "seedPaste", "seedRename",
            "seedHome", "seedCopy", "seedSelectAll", "seedLineElbow", "seedLineStraight", "seedLineCurved", "seedSection", "seedNoteBand", "seedPhase", "seedComesAfter",
        ])
        XCTAssertEqual(AppMark.allCases.count, 173)
    }

    func testEveryMarkKeepsTheHandDrawnRules() {
        for mark in AppMark.allCases {
            XCTAssertNil(SVGPath.fault(in: mark.path), "\(mark): \(SVGPath.fault(in: mark.path) ?? "")")
            XCTAssertNil(HandIconTests.boxFault(mark.path), "\(mark): \(HandIconTests.boxFault(mark.path) ?? "")")
            XCTAssertFalse(mark.label.isEmpty)
            XCTAssertLessThanOrEqual(mark.label.split(separator: " ").count, 2, "\(mark): a label is one or two words")
        }
        let paths = AppMark.allCases.map(\.path)
        XCTAssertEqual(Set(paths).count, paths.count, "two marks share a drawing")
    }
}
