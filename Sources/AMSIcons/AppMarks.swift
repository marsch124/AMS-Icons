import SwiftUI

/// The marks an app shows beside its places and on its toolbars — Inbox, Today, Calendar,
/// Project, Archive, Sync… — drawn the hand-drawn way (one 1.9 stroke, round ends and joins, a
/// 24-point box, no fill). First drawn for PARAGON (6 Nov 2026), so that its sidebar, toolbar
/// and lists need no stock symbol.
///
/// Like the control marks they are not template icons: the picker and the search never show
/// them, and they are never stored as a choice. An app names them in code: `AppMarkView(.inbox)`.
/// The rules of the hand-drawn icons hold (only M L H V C S Q A Z, inside the box); a mark may
/// be added, none renamed or taken away.
public enum AppMark: String, CaseIterable, Sendable {
    case inbox, today, calendar, timeBlocks, review, map, recent, bin, templates, snippets
    case tags, search, aspiration, goal, project, area, resource, archive, work, daily
    case capture, sync, read, readOff, back, forward, archiveDown, moon, sunrise, cup
    case hourglass, link, page, cloud, cloudDown, warning, warningCircle, exclamation, timer, finished
    case ringDashed, compose, bookmark, listIndent, info, hand, palette, ruler, `repeat`, question
    case clockAlert, openLink, openApp, send, arrowDownLeft, arrowDown, share, parcel, minus, zoomIn
    case zoomOut, filter, undo, trayFull, dot, lock

    /// What VoiceOver says when the mark stands alone.
    public var label: String {
        switch self {
        case .inbox: return "Inbox"
        case .today: return "Today"
        case .calendar: return "Calendar"
        case .timeBlocks: return "Time blocks"
        case .review: return "Review"
        case .map: return "Map"
        case .recent: return "Recent"
        case .bin: return "Bin"
        case .templates: return "Templates"
        case .snippets: return "Snippets"
        case .tags: return "Tags"
        case .search: return "Search"
        case .aspiration: return "Aspiration"
        case .goal: return "Goal"
        case .project: return "Project"
        case .area: return "Area"
        case .resource: return "Resource"
        case .archive: return "Archive"
        case .work: return "Work"
        case .daily: return "Daily note"
        case .capture: return "Capture"
        case .sync: return "Sync"
        case .read: return "Read"
        case .readOff: return "Unread"
        case .back: return "Back"
        case .forward: return "Forward"
        case .archiveDown: return "Archive"
        case .moon: return "Night"
        case .sunrise: return "Morning"
        case .cup: return "Break"
        case .hourglass: return "Waiting"
        case .link: return "Link"
        case .page: return "Page"
        case .cloud: return "Cloud"
        case .cloudDown: return "Download"
        case .warning: return "Warning"
        case .warningCircle: return "Warning"
        case .exclamation: return "Important"
        case .timer: return "Timer"
        case .finished: return "Finished"
        case .ringDashed: return "Empty"
        case .compose: return "Compose"
        case .bookmark: return "Bookmark"
        case .listIndent: return "Outline"
        case .info: return "Info"
        case .hand: return "Hand"
        case .palette: return "Colours"
        case .ruler: return "Ruler"
        case .`repeat`: return "Repeat"
        case .question: return "Help"
        case .clockAlert: return "Overdue"
        case .openLink: return "Open link"
        case .openApp: return "Open app"
        case .send: return "Send"
        case .arrowDownLeft: return "Down left"
        case .arrowDown: return "Down"
        case .share: return "Share"
        case .parcel: return "Parcel"
        case .minus: return "Remove"
        case .zoomIn: return "Zoom in"
        case .zoomOut: return "Zoom out"
        case .filter: return "Filter"
        case .undo: return "Undo"
        case .trayFull: return "Tray"
        case .dot: return "Dot"
        case .lock: return "Locked"
        }
    }

    /// The drawing on the 24-point box.
    public var path: String {
        switch self {
        // A tray: an open box seen from the front, with the slot as its lip.
        case .inbox: return "M3.5 13v5a1.5 1.5 0 0 0 1.5 1.5h14a1.5 1.5 0 0 0 1.5-1.5v-5 M3.5 13h4.5l1.6 2.5h4.8l1.6-2.5h4.5 M6 13l1.9-6.5h8.2L18 13"
        case .today: return "M8.5 12a3.5 3.5 0 1 0 7 0a3.5 3.5 0 1 0 -7 0 M12 3.5v2 M12 18.5v2 M3.5 12h2 M18.5 12h2 M6 6l1.4 1.4 M16.6 16.6 18 18 M18 6l-1.4 1.4 M7.4 16.6 6 18"
        case .calendar: return "M3.5 6.5h17v13h-17Z M3.5 10.5h17 M8 4v4.5 M16 4v4.5"
        case .timeBlocks: return "M20.5 12V6.5h-17v13H11 M3.5 10.5h17 M8 4v4.5 M16 4v4.5 M13 16.5a4 4 0 1 0 8 0a4 4 0 1 0 -8 0 M17 14.3v2.2l1.4 1"
        case .review: return "M4.2 7.3l1.6 1.6 2.8-3.2 M11 7.5h9 M11 12.5h9 M11 17.5h9"
        case .map: return "M9.5 6a2.5 2.5 0 1 0 5 0a2.5 2.5 0 1 0 -5 0 M3.5 18a2.5 2.5 0 1 0 5 0a2.5 2.5 0 1 0 -5 0 M15.5 18a2.5 2.5 0 1 0 5 0a2.5 2.5 0 1 0 -5 0 M10.5 9 7.5 15 M13.5 9l3 6"
        case .recent: return "M6.5 15.75A7.5 7.5 0 1 0 6.5 8.25 M9.4 7.5 6.5 8.25 5.7 5.3 M13 8v4.5l3 1.8"
        case .bin: return "M4.5 7h15 M9.5 7V5h5v2 M6 7l1 13.5h10L18 7 M10 11v6 M14 11v6"
        case .templates: return "M14 3.5H6v17h5 M14 3.5l5 5v2.5 M14 3.5v5h5 M20.2 17.7L21.2 18.6L20.4 20L19.1 19.6L18.4 20L18.1 21.3L16.5 21.3L16.2 20L15.5 19.6L14.2 20L13.4 18.6L14.4 17.7L14.4 16.9L13.4 16L14.2 14.6L15.5 15L16.2 14.6L16.5 13.3L18.1 13.3L18.4 14.6L19.1 15L20.4 14.6L21.2 16L20.2 16.9Z"
        case .snippets: return "M4 7h16 M4 12h16 M4 17h8 M16.5 14.5v5 M14 17h5"
        case .tags: return "M9.5 4.5 7.5 19.5 M16.5 4.5l-2 15 M4.5 9.5h15.5 M4 15h15.5"
        case .search: return "M4.5 10.5a6 6 0 1 0 12 0a6 6 0 1 0 -12 0 M15 15l5 5"
        case .aspiration: return "M12 3.6 14.3 9.4 20.6 9.8 15.7 13.8 17.3 19.9 12 16.5 6.7 19.9 8.3 13.8 3.4 9.8 9.7 9.4Z"
        case .goal: return "M3.5 12a8.5 8.5 0 1 0 17 0a8.5 8.5 0 1 0 -17 0 M7.5 12a4.5 4.5 0 1 0 9 0a4.5 4.5 0 1 0 -9 0 M12 12h.01"
        case .project: return "M5.5 20.5V4 M5.5 5C8.5 3.4 11 6.6 13.5 5S17 3.8 18.5 4.7V13.2C17 12.3 15 14.5 13 13.5S8.5 11.9 5.5 13.5Z"
        case .area: return "M5.6 4h3.3a1.6 1.6 0 0 1 1.6 1.6v3.3a1.6 1.6 0 0 1 -1.6 1.6h-3.3a1.6 1.6 0 0 1 -1.6 -1.6v-3.3a1.6 1.6 0 0 1 1.6 -1.6Z M15.1 4h3.3a1.6 1.6 0 0 1 1.6 1.6v3.3a1.6 1.6 0 0 1 -1.6 1.6h-3.3a1.6 1.6 0 0 1 -1.6 -1.6v-3.3a1.6 1.6 0 0 1 1.6 -1.6Z M5.6 13.5h3.3a1.6 1.6 0 0 1 1.6 1.6v3.3a1.6 1.6 0 0 1 -1.6 1.6h-3.3a1.6 1.6 0 0 1 -1.6 -1.6v-3.3a1.6 1.6 0 0 1 1.6 -1.6Z M15.1 13.5h3.3a1.6 1.6 0 0 1 1.6 1.6v3.3a1.6 1.6 0 0 1 -1.6 1.6h-3.3a1.6 1.6 0 0 1 -1.6 -1.6v-3.3a1.6 1.6 0 0 1 1.6 -1.6Z"
        case .resource: return "M3.5 5h3v15h-3Z M7.5 5h3v15h-3Z M13 19.5l3.4-13.4 3.6.9-3.4 13.4Z"
        case .archive: return "M3.5 5h17v4.5h-17Z M5 9.5v10.5h14V9.5 M10 13.5h4"
        case .work: return "M3.5 8.5h17v11h-17Z M9 8.5V5.5h6v3 M3.5 13h17"
        case .daily: return "M10.5 3.5H4.5v17h15V13 M14.6 7a1.9 1.9 0 1 0 3.8 0a1.9 1.9 0 1 0 -3.8 0 M16.5 3.8V2.2 M16.5 10.2v1.6 M19.7 7h1.6 M13.3 7h-1.6 M18.8 4.7l1.1-1.1 M14.2 9.3l-1.1 1.1 M18.8 9.3l1.1 1.1 M14.2 4.7l-1.1-1.1 M8 13.5h4 M8 17h8"
        case .capture: return "M3.5 13v5a1.5 1.5 0 0 0 1.5 1.5h14a1.5 1.5 0 0 0 1.5-1.5v-5 M3.5 13h4.5l1.6 2.5h4.8l1.6-2.5h4.5 M12 3.5v8 M8.8 8.3 12 11.5l3.2-3.2"
        case .sync: return "M4.5 9.3A8 8 0 0 1 19.5 9.3 M20.9 6.4 19.5 9.3 16.6 8 M19.5 14.7A8 8 0 0 1 4.5 14.7 M3.1 17.6 4.5 14.7 7.4 16"
        case .read: return "M3 12c2.4-4.3 5.6-6.5 9-6.5s6.6 2.2 9 6.5c-2.4 4.3-5.6 6.5-9 6.5S5.4 16.3 3 12Z M9 12a3 3 0 1 0 6 0a3 3 0 1 0 -6 0"
        case .readOff: return "M3 12c2.4-4.3 5.6-6.5 9-6.5s6.6 2.2 9 6.5c-2.4 4.3-5.6 6.5-9 6.5S5.4 16.3 3 12Z M9 12a3 3 0 1 0 6 0a3 3 0 1 0 -6 0 M4.5 19.5 19.5 4.5"
        case .back: return "M14.5 5.5 8 12l6.5 6.5"
        case .forward: return "M9.5 5.5 16 12l-6.5 6.5"
        case .archiveDown: return "M12 3.5v8 M8.8 8.3 12 11.5l3.2-3.2 M3.5 14.5h17v6h-17Z"
        case .moon: return "M8 4.5A8.5 8.5 0 1 0 19.5 16A8.5 8.5 0 0 1 8 4.5Z"
        case .sunrise: return "M3 17h18 M7.5 17a4.5 4.5 0 0 1 9 0 M12 10.5V8 M7.4 12.4 5.6 10.6 M16.6 12.4l1.8-1.8"
        case .cup: return "M5 7h11v6a5 5 0 0 1-5 5h-1a5 5 0 0 1-5-5Z M16 9.5h1.5a2.5 2.5 0 0 1 0 5H16 M3.5 20.5h15"
        case .hourglass: return "M6 3.5h12 M6 20.5h12 M7.5 3.5v2.5c0 3 4.5 4.5 4.5 6s-4.5 3-4.5 6v2.5 M16.5 3.5v2.5c0 3-4.5 4.5-4.5 6s4.5 3 4.5 6v2.5"
        case .link: return "M10.5 7.5H7.5a4.5 4.5 0 0 0 0 9h3 M13.5 7.5h3a4.5 4.5 0 0 1 0 9h-3 M8.5 12h7"
        case .page: return "M6 3.5h8l5 5v12H6Z M14 3.5v5h5"
        case .cloud: return "M7.5 19H17A4.1 4.1 0 0 0 17.5 11A5.6 5.6 0 0 0 7 13.5A3.3 3.3 0 0 0 7.5 19Z"
        case .cloudDown: return "M9.5 17.5H7.5A3.3 3.3 0 0 1 7 11A5.6 5.6 0 0 1 17.5 9.5A4.1 4.1 0 0 1 17 17.5H14.5 M12 11v9.5 M9.3 17.8 12 20.5l2.7-2.7"
        case .warning: return "M12 4 3.5 19.5h17Z M12 10v4.5 M12 17h.01"
        case .warningCircle: return "M4 12a8 8 0 1 0 16 0a8 8 0 1 0 -16 0 M12 8v4.5 M12 16h.01"
        case .exclamation: return "M12 4.5v10 M12 19.5h.01"
        case .timer: return "M5.5 13.5a6.5 6.5 0 1 0 13 0a6.5 6.5 0 1 0 -13 0 M12 13.5V10 M12 7V3.5 M9.5 3.5h5 M17.5 7.5l1.5-1.5"
        case .finished: return "M5 20.5V3.5 M5 4.5h14v9H5 M9.7 4.5v9 M14.3 4.5v9 M5 9h14 M7.4 6.8h.01 M16.6 6.8h.01 M12 11.2h.01"
        case .ringDashed: return "M13.4 4.1A8 8 0 0 1 16.6 5.4 M18.6 7.4A8 8 0 0 1 19.9 10.6 M19.9 13.4A8 8 0 0 1 18.6 16.6 M16.6 18.6A8 8 0 0 1 13.4 19.9 M10.6 19.9A8 8 0 0 1 7.4 18.6 M5.4 16.6A8 8 0 0 1 4.1 13.4 M4.1 10.6A8 8 0 0 1 5.4 7.4 M7.4 5.4A8 8 0 0 1 10.6 4.1"
        case .compose: return "M11 5H5.5v13.5H19V13 M10 15.5l.8-3.3L18.7 4.3a1.6 1.6 0 0 1 2.3 2.3L13.1 14.6Z"
        case .bookmark: return "M6.5 20.5V4.5a1 1 0 0 1 1-1h9a1 1 0 0 1 1 1v16l-5.5-4Z"
        case .listIndent: return "M4.5 6h15 M4.5 10h15 M9.5 14h10 M9.5 18h10"
        case .info: return "M4 12a8 8 0 1 0 16 0a8 8 0 1 0 -16 0 M12 11v5.5 M12 8h.01"
        case .hand: return "M5 20.5 3.5 15.5V10A1.6 1.6 0 0 1 6.7 10L7 13.6 7.3 6.3A1.6 1.6 0 0 1 10.5 6.3L10.8 12.5 11.1 5.2A1.6 1.6 0 0 1 14.3 5.2L14.6 12.9 14.9 6.7A1.6 1.6 0 0 1 18.1 6.7V13C18.6 11.8 20.3 10.2 21.3 11C22.3 11.9 20.9 14.3 19.2 16L18.3 17.2V20.5Z"
        case .palette: return "M20.4 13.5A8.5 8.5 0 1 0 14.9 20A4.6 4.6 0 0 1 20.4 13.5Z M7.5 9.5a1 1 0 1 0 2 0a1 1 0 1 0 -2 0 M11 6.5a1 1 0 1 0 2 0a1 1 0 1 0 -2 0 M14.5 8.5a1 1 0 1 0 2 0a1 1 0 1 0 -2 0 M6.5 14a1 1 0 1 0 2 0a1 1 0 1 0 -2 0"
        case .ruler: return "M3.4 17.4 17.4 3.4l3.2 3.2L6.6 20.6Z M10.8 16.4l-1.4-1.4 M13.6 13.6l-1.9-1.9 M16.4 10.8l-1.4-1.4"
        case .`repeat`: return "M16.5 3l3.5 3.5-3.5 3.5 M20 6.5H7.5a4 4 0 0 0-4 4V12 M7.5 21 4 17.5l3.5-3.5 M4 17.5h12.5a4 4 0 0 0 4-4V12"
        case .question: return "M4 12a8 8 0 1 0 16 0a8 8 0 1 0 -16 0 M9.6 9.6A2.4 2.4 0 1 1 12 12v1.8 M12 16.8h.01"
        case .clockAlert: return "M3.5 13a7.5 7.5 0 1 0 15 0a7.5 7.5 0 1 0 -15 0 M11 9v4l2.7 1.7 M19.5 3.5v4.5 M19.5 11h.01"
        case .openLink: return "M4.5 10.5v9h9 M8.5 15.5 19.5 4.5 M12 4.5h7.5V12"
        case .openApp: return "M10.5 5.5H6a1.5 1.5 0 0 0-1.5 1.5V18A1.5 1.5 0 0 0 6 19.5h11.5A1.5 1.5 0 0 0 19 18v-4.5 M13.5 4.5h6v6 M19.5 4.5 11 13"
        case .send: return "M4 12a8 8 0 1 0 16 0a8 8 0 1 0 -16 0 M12 16.5v-9 M8.5 11 12 7.5l3.5 3.5"
        case .arrowDownLeft: return "M18.5 5.5 5.5 18.5 M5.5 9.5v9h9"
        case .arrowDown: return "M12 4v16 M5.5 13.5 12 20l6.5-6.5"
        case .share: return "M8 10H6a1.5 1.5 0 0 0-1.5 1.5v7A1.5 1.5 0 0 0 6 20h12a1.5 1.5 0 0 0 1.5-1.5v-7A1.5 1.5 0 0 0 18 10h-2 M12 15V3.5 M8.5 7 12 3.5 15.5 7"
        case .parcel: return "M12 3.5 4 7.5v9l8 4 8-4v-9Z M4 7.5l8 4 8-4 M12 11.5v9 M8 5.5l8 4"
        case .minus: return "M5 12h14"
        case .zoomIn: return "M4.5 10.5a6 6 0 1 0 12 0a6 6 0 1 0 -12 0 M15 15l5 5 M10.5 8v5 M8 10.5h5"
        case .zoomOut: return "M4.5 10.5a6 6 0 1 0 12 0a6 6 0 1 0 -12 0 M15 15l5 5 M8 10.5h5"
        case .filter: return "M4 12a8 8 0 1 0 16 0a8 8 0 1 0 -16 0 M7.5 9.5h9 M9 12.5h6 M10.5 15.5h3"
        case .undo: return "M4.5 9.5h9a5.5 5.5 0 0 1 0 11H9 M8 6 4.5 9.5 8 13"
        case .trayFull: return "M3.5 13v5a1.5 1.5 0 0 0 1.5 1.5h14a1.5 1.5 0 0 0 1.5-1.5v-5 M3.5 13h4.5l1.6 2.5h4.8l1.6-2.5h4.5 M8 4.5h8 M8 8.5h8"
        case .dot: return "M9 12a3 3 0 1 0 6 0a3 3 0 1 0 -6 0"
        case .lock: return "M5.5 10.5h13v10h-13Z M8 10.5V7.5a4 4 0 0 1 8 0v3 M12 14.5v2.5"
        }
    }
}

/// Draws an app mark at any size. Without a colour it takes the colour around it.
/// Hidden from VoiceOver by default: the row or button it sits on says what it is.
public struct AppMarkView: View {
    public let mark: AppMark
    public let size: CGFloat
    public let colour: Color?
    public let lineWidth: CGFloat

    public init(_ mark: AppMark, size: CGFloat = 22, colour: Color? = nil, lineWidth: CGFloat = 1.9) {
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
