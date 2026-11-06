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
        ])
        XCTAssertEqual(AppMark.allCases.count, 66)
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
