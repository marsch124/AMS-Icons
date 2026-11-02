import XCTest
@testable import AMSIcons

final class ControlMarkTests: XCTestCase {
    /// Marks are added, never renamed or taken away — apps name them in code.
    func testTheMarksAndTheirOrder() {
        XCTAssertEqual(ControlMark.allCases.map(\.rawValue), [
            "add", "addCircle", "edit", "play", "pause", "skip", "check", "close",
            "circle", "ticked", "photo", "expand", "chevron", "more", "settings", "list",
        ])
    }

    func testEveryMarkKeepsTheHandDrawnRules() {
        for mark in ControlMark.allCases {
            XCTAssertNil(SVGPath.fault(in: mark.path), "\(mark): \(SVGPath.fault(in: mark.path) ?? "")")
            XCTAssertNil(HandIconTests.boxFault(mark.path), "\(mark): \(HandIconTests.boxFault(mark.path) ?? "")")
            XCTAssertFalse(mark.label.isEmpty)
        }
        let paths = ControlMark.allCases.map(\.path)
        XCTAssertEqual(Set(paths).count, paths.count, "two marks share a drawing")
    }
}
