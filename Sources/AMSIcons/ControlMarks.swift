import SwiftUI

/// The marks on buttons and controls — Done, Skip, Close, Add… — drawn the hand-drawn way
/// (one 1.9 stroke, round ends and joins, a 24-point box, no fill). First drawn for AMS
/// WorkoutCompanion (2 Nov 2026), so that no AMS app needs a stock symbol on a button.
///
/// They are not template icons: the picker and the search never show them, and they are
/// never stored as a choice. An app names them in code: `ControlMarkView(.check)`.
/// The rules of the hand-drawn icons hold (only M L H V C S Q A Z, inside the box); a mark
/// may be added, none renamed or taken away.
public enum ControlMark: String, CaseIterable, Sendable {
    case add, addCircle, edit, play, pause, skip, check, close
    case circle, ticked, photo, expand, chevron, more, settings, list

    /// What VoiceOver says when the mark stands alone.
    public var label: String {
        switch self {
        case .add: return "Add"
        case .addCircle: return "Add"
        case .edit: return "Edit"
        case .play: return "Start"
        case .pause: return "Pause"
        case .skip: return "Skip"
        case .check: return "Done"
        case .close: return "Close"
        case .circle: return "Not done"
        case .ticked: return "Done"
        case .photo: return "Photo"
        case .expand: return "Enlarge"
        case .chevron: return "Open"
        case .more: return "More"
        case .settings: return "Settings"
        case .list: return "List"
        }
    }

    /// The drawing on the 24-point box.
    public var path: String {
        switch self {
        case .add: return "M12 5v14 M5 12h14"
        case .addCircle: return "M4 12a8 8 0 1 0 16 0a8 8 0 1 0 -16 0 M12 8.5v7 M8.5 12h7"
        case .edit: return "M4.5 19.5l1-4.4L15.6 5a2.1 2.1 0 0 1 3 3L8.5 18.4Z M13.6 7l3 3"
        case .play: return "M8 5.5v13l10-6.5Z"
        case .pause: return "M9 6v12 M15 6v12"
        case .skip: return "M5.5 6.5l8 5.5-8 5.5Z M18 6.5v11"
        case .check: return "M5 12.5l4.5 4.5L19 7.5"
        case .close: return "M6.5 6.5l11 11 M17.5 6.5l-11 11"
        case .circle: return "M4 12a8 8 0 1 0 16 0a8 8 0 1 0 -16 0"
        case .ticked: return "M4 12a8 8 0 1 0 16 0a8 8 0 1 0 -16 0 M8.2 12.3l2.6 2.6 5-5.2"
        case .photo: return "M3.5 6h17v12h-17Z M3.5 15.5l4.8-4.3 4 3.6 2.9-2.4 5.3 4.4 M15.2 9.3a1.1 1.1 0 1 0 2.2 0a1.1 1.1 0 1 0 -2.2 0"
        case .expand: return "M14 4.5h5.5V10 M19.5 4.5 14 10 M10 19.5H4.5V14 M4.5 19.5 10 14"
        case .chevron: return "M9.5 5.5 16 12l-6.5 6.5"
        case .more: return "M6 12h.01 M12 12h.01 M18 12h.01"
        // A gear with 6 teeth (3 Nov 2026: the old rays read as a sun).
        case .settings: return "M18.36 9.60 L20.82 10.20 L20.82 13.80 L18.36 14.40 L17.26 16.31 L17.97 18.74 L14.85 20.54 L13.11 18.71 L10.89 18.71 L9.15 20.54 L6.03 18.74 L6.74 16.31 L5.64 14.40 L3.18 13.80 L3.18 10.20 L5.64 9.60 L6.74 7.69 L6.03 5.26 L9.15 3.46 L10.89 5.29 L13.11 5.29 L14.85 3.46 L17.97 5.26 L17.26 7.69Z M8.8 12a3.2 3.2 0 1 0 6.4 0a3.2 3.2 0 1 0 -6.4 0"
        case .list: return "M10 6.5h10 M10 12h10 M10 17.5h10 M3.8 6.5l1.4 1.4 2.4-2.6 M3.8 12l1.4 1.4 2.4-2.6 M3.8 17.5l1.4 1.4 2.4-2.6"
        }
    }
}

/// Draws a control mark at any size. Without a colour it takes the colour around it.
/// Hidden from VoiceOver by default: the button it sits on says what it does.
public struct ControlMarkView: View {
    public let mark: ControlMark
    public let size: CGFloat
    public let colour: Color?
    public let lineWidth: CGFloat

    public init(_ mark: ControlMark, size: CGFloat = 22, colour: Color? = nil, lineWidth: CGFloat = 1.9) {
        self.mark = mark
        self.size = size
        self.colour = colour
        self.lineWidth = lineWidth
    }

    public var body: some View {
        GridShape(d: mark.path)
            .stroke(style: StrokeStyle(lineWidth: lineWidth * size / 24, lineCap: .round, lineJoin: .round))
            .frame(width: size, height: size)
            .modifier(OptionalForeground(colour: colour))
            .accessibilityHidden(true)
    }
}
