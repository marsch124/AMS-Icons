import Foundation
import SwiftUI

/// Turns SVG path data ("M8 6h11M8 12h11…") into a SwiftUI `Path`.
///
/// Copied from the AMS Packing app, where the hand-drawn icons were made: reading their path
/// data directly means every icon here is the SAME drawing, not a re-tracing of it. Supports
/// M L H V C S Q A Z, absolute and relative: what the drawings use. Any other command stops a
/// debug build loudly (an unknown command used to end a drawing in silence).
///
/// One change from the Packing copy: the reading is also offered as `fault(in:)`, so a test can
/// ask whether a drawing can be read in full without stopping on the assertion, and numbers
/// after a Z end the reading instead of repeating the Z for ever.
public enum SVGPath {
    /// The commands a drawing may use, in capitals. A small letter is the same command, relative.
    public static let commands: Set<Character> = ["M", "L", "H", "V", "C", "S", "Q", "A", "Z"]

    /// The drawing at its own coordinates (a 24-point box for the hand-drawn icons). Use
    /// `GridShape` to draw it centred in any square.
    public static func path(_ d: String) -> Path {
        let reading = parse(d)
        if let bad = reading.unknownCommand {
            assertionFailure("SVGPath cannot draw '\(bad)' in \(d)")
        }
        return reading.path
    }

    /// Why this path data cannot be read in full, in a few plain words; nil when every part of
    /// it can. An empty drawing, one that does not start with M, a command that is not one of
    /// `commands`, and a command short of numbers are all faults.
    public static func fault(in d: String) -> String? {
        parse(d).fault
    }

    struct Reading {
        var path: Path
        var fault: String?
        var unknownCommand: Character?
    }

    static func parse(_ d: String) -> Reading {
        var p = Path()
        var s = Scan(Array(d))
        var cmd: Character = " "
        var cur = CGPoint.zero
        var start = CGPoint.zero
        /// The last curve's second control point, for S (its mirror is S's first).
        var lastC2: CGPoint?
        var readAny = false
        var firstFault: String?

        func stop(_ why: String) -> Reading {
            Reading(path: p, fault: firstFault ?? why, unknownCommand: nil)
        }

        while true {
            s.skipSeparators()
            guard !s.atEnd else { break }
            let explicit: Bool
            if let c = s.command() {
                if !readAny, c != "M", c != "m" { firstFault = "does not start with M" }
                readAny = true
                cmd = c
                explicit = true
            } else if cmd == " " {
                return stop("does not start with a command")
            } else {
                explicit = false
            }
            let rel = cmd.isLowercase
            let curveBefore = lastC2
            lastC2 = nil
            func abs(_ x: Double, _ y: Double) -> CGPoint {
                rel ? CGPoint(x: cur.x + x, y: cur.y + y) : CGPoint(x: x, y: y)
            }

            switch cmd {
            case "M", "m":
                guard let x = s.number(), let y = s.number() else { return stop("'\(cmd)' is short of numbers") }
                cur = abs(x, y); start = cur
                p.move(to: cur)
                cmd = rel ? "l" : "L"          // further pairs are lines
            case "L", "l":
                guard let x = s.number(), let y = s.number() else { return stop("'\(cmd)' is short of numbers") }
                cur = abs(x, y); p.addLine(to: cur)
            case "H", "h":
                guard let x = s.number() else { return stop("'\(cmd)' is short of numbers") }
                cur = CGPoint(x: rel ? cur.x + x : x, y: cur.y); p.addLine(to: cur)
            case "V", "v":
                guard let y = s.number() else { return stop("'\(cmd)' is short of numbers") }
                cur = CGPoint(x: cur.x, y: rel ? cur.y + y : y); p.addLine(to: cur)
            case "C", "c":
                guard let x1 = s.number(), let y1 = s.number(),
                      let x2 = s.number(), let y2 = s.number(),
                      let x = s.number(), let y = s.number() else { return stop("'\(cmd)' is short of numbers") }
                let c1 = abs(x1, y1), c2 = abs(x2, y2), end = abs(x, y)
                p.addCurve(to: end, control1: c1, control2: c2); cur = end
                lastC2 = c2
            case "S", "s":
                guard let x2 = s.number(), let y2 = s.number(),
                      let x = s.number(), let y = s.number() else { return stop("'\(cmd)' is short of numbers") }
                let c1 = curveBefore.map { CGPoint(x: 2 * cur.x - $0.x, y: 2 * cur.y - $0.y) } ?? cur
                let c2 = abs(x2, y2), end = abs(x, y)
                p.addCurve(to: end, control1: c1, control2: c2); cur = end
                lastC2 = c2
            case "Q", "q":
                guard let x1 = s.number(), let y1 = s.number(),
                      let x = s.number(), let y = s.number() else { return stop("'\(cmd)' is short of numbers") }
                let c = abs(x1, y1), end = abs(x, y)
                p.addQuadCurve(to: end, control: c); cur = end
            case "A", "a":
                guard let rx = s.number(), let ry = s.number(), let rot = s.number(),
                      let large = s.flag(), let sweep = s.flag(),
                      let x = s.number(), let y = s.number() else { return stop("'\(cmd)' is short of numbers") }
                let end = abs(x, y)
                arc(&p, from: cur, to: end, rx: rx, ry: ry, rotation: rot, large: large, sweep: sweep)
                cur = end
            case "Z", "z":
                // Z takes no numbers: a number after it would otherwise repeat the Z for ever.
                guard explicit else { return stop("numbers after Z") }
                p.closeSubpath(); cur = start
            default:
                return Reading(path: p, fault: "cannot draw '\(cmd)'", unknownCommand: cmd)
            }
        }
        if !readAny { return Reading(path: p, fault: "has no drawing", unknownCommand: nil) }
        return Reading(path: p, fault: firstFault, unknownCommand: nil)
    }

    /// An SVG arc as cubic curves (the W3C endpoint-to-centre conversion).
    private static func arc(_ p: inout Path, from p0: CGPoint, to p1: CGPoint,
                            rx rxIn: Double, ry ryIn: Double, rotation: Double,
                            large: Bool, sweep: Bool) {
        var rx = Swift.abs(rxIn), ry = Swift.abs(ryIn)
        if rx == 0 || ry == 0 || p0 == p1 { p.addLine(to: p1); return }
        let phi = rotation * .pi / 180
        let cosP = cos(phi), sinP = sin(phi)
        let dx = (p0.x - p1.x) / 2, dy = (p0.y - p1.y) / 2
        let x1 = cosP * dx + sinP * dy
        let y1 = -sinP * dx + cosP * dy
        let lambda = (x1 * x1) / (rx * rx) + (y1 * y1) / (ry * ry)
        if lambda > 1 { rx *= lambda.squareRoot(); ry *= lambda.squareRoot() }
        let num = rx * rx * ry * ry - rx * rx * y1 * y1 - ry * ry * x1 * x1
        let den = rx * rx * y1 * y1 + ry * ry * x1 * x1
        let coef = (large != sweep ? 1.0 : -1.0) * max(0, num / den).squareRoot()
        let cxp = coef * (rx * y1 / ry)
        let cyp = coef * -(ry * x1 / rx)
        let cx = cosP * cxp - sinP * cyp + (p0.x + p1.x) / 2
        let cy = sinP * cxp + cosP * cyp + (p0.y + p1.y) / 2

        func angle(_ ux: Double, _ uy: Double, _ vx: Double, _ vy: Double) -> Double {
            atan2(ux * vy - uy * vx, ux * vx + uy * vy)
        }
        let theta = angle(1, 0, (x1 - cxp) / rx, (y1 - cyp) / ry)
        var delta = angle((x1 - cxp) / rx, (y1 - cyp) / ry, (-x1 - cxp) / rx, (-y1 - cyp) / ry)
        if !sweep && delta > 0 { delta -= 2 * .pi }
        if sweep && delta < 0 { delta += 2 * .pi }

        let pieces = max(1, Int(ceil(Swift.abs(delta) / (.pi / 2) - 1e-9)))
        let step = delta / Double(pieces)
        let t = 4.0 / 3.0 * tan(step / 4)
        func place(_ x: Double, _ y: Double) -> CGPoint {
            CGPoint(x: cx + rx * cosP * x - ry * sinP * y,
                    y: cy + rx * sinP * x + ry * cosP * y)
        }
        var a = theta
        for _ in 0..<pieces {
            let b = a + step
            p.addCurve(to: place(cos(b), sin(b)),
                       control1: place(cos(a) - t * sin(a), sin(a) + t * cos(a)),
                       control2: place(cos(b) + t * sin(b), sin(b) - t * cos(b)))
            a = b
        }
    }

    private struct Scan {
        let chars: [Character]
        var i = 0
        init(_ chars: [Character]) { self.chars = chars }
        var atEnd: Bool { i >= chars.count }

        mutating func skipSeparators() {
            while i < chars.count, chars[i] == " " || chars[i] == "," || chars[i].isNewline || chars[i] == "\t" { i += 1 }
        }
        mutating func command() -> Character? {
            skipSeparators()
            guard i < chars.count, chars[i].isLetter else { return nil }
            defer { i += 1 }
            return chars[i]
        }
        /// "2.1-.6-.6" is three numbers: a sign or a second dot starts a new one.
        mutating func number() -> Double? {
            skipSeparators()
            let from = i
            if i < chars.count, chars[i] == "-" || chars[i] == "+" { i += 1 }
            var dot = false
            while i < chars.count {
                let c = chars[i]
                if c.isNumber { i += 1 }
                else if c == ".", !dot { dot = true; i += 1 }
                else { break }
            }
            guard i > from else { return nil }
            return Double(String(chars[from..<i]))
        }
        /// Arc flags are one digit each and may be written with no space between.
        mutating func flag() -> Bool? {
            skipSeparators()
            guard i < chars.count, chars[i] == "0" || chars[i] == "1" else { return nil }
            defer { i += 1 }
            return chars[i] == "1"
        }
    }
}

/// A drawing on the 24-point grid that fills whatever square it is framed in, centred.
///
/// A bare `SVGPath.path` is drawn at its own coordinates: framed smaller than 24 it hangs off to
/// the bottom right, framed bigger it sits up and to the left. Drawn through this, it is centred
/// at any size. Stroke it with a width of 1.9 / 24 of the square for the hand-drawn look.
public struct GridShape: Shape {
    public let d: String

    public init(d: String) {
        self.d = d
    }

    public func path(in rect: CGRect) -> Path {
        let k = min(rect.width, rect.height) / 24
        let move = CGAffineTransform(translationX: rect.midX - 12 * k, y: rect.midY - 12 * k).scaledBy(x: k, y: k)
        return SVGPath.path(d).applying(move)
    }
}
