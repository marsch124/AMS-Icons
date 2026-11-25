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
    case folder, person, clock
    case drawer, drawerOpen
    // AMS Deck Mate (16 Nov 2026)
    case deckRaycast, deckKeyboard, deckText, deckPlay, deckNext, deckPrevious
    case deckVolumeUp, deckVolumeDown, deckMute, deckFolder, deckBack, deckPageNext
    case deckPagePrevious, deckProfile, deckMulti, deckScript, deckClipboard, deckWindowLeft
    case deckWindowRight, deckWindowFull, deckAi, deckApp
    // AMS Snug GridFit (16 Nov 2026)
    case gridFlat, gridEdge, gridStanding, gridAuto, gridBin, gridBins, gridStrip, gridPrintFile
    // Arrows for every direction and the two missing window halves (AMS Deck Mate, 16 Nov 2026)
    case arrowUp, arrowLeft, arrowRight, deckWindowTop, deckWindowBottom
    // AMS Reading Companion (17 Nov 2026)
    case lockOpen
    // A star for a rating: drawn as an outline, the app fills it for a given star (AMS Reading Companion, 17 Nov 2026)
    case star
    // AMS Seedboard (18 Nov 2026): the mind-map and diagram tool's own marks, and the two general marks it missed.
    case seedMindMap, seedBox, seedRound, seedDiamond, seedOval, seedArrow, seedNote, seedText
    case seedFrame, seedBoard, seedSprout, seedPin, seedFit, seedStarter
    case redo, duplicate
    // AMS Deck Mate (18 Nov 2026): eject a disk, join a video meeting
    case deckEject, deckVideo
    // AMS Seedboard 0.2 (18 Nov 2026): the timeline, drawing, sequence and flowchart boards, lining up,
    // line ends, moving ideas in the mind map, and the board's own tools.
    case seedTimeline, seedBar, seedMilestone, seedToday, seedCalendar
    case seedDraw, seedRubber, seedThin, seedMedium, seedThick
    case seedSequence, seedPerson, seedAnswer
    case seedDocument, seedSlanted, seedStore, seedLanes
    case seedLineUp, seedEvenGaps, seedSameSize
    case seedOneWay, seedBothWays, seedNoEnds, seedDashed
    case seedMoveUp, seedMoveDown, seedOutLevel, seedIdeaUnder, seedNextIdea, seedBranch
    case seedBringBack, seedEarlier, seedExport, seedSearch, seedCut, seedPaste, seedRename
    // AMS Seedboard 0.2, second round (18 Nov 2026)
    case seedHome, seedCopy, seedSelectAll, seedLineElbow, seedLineStraight, seedLineCurved, seedSection, seedNoteBand, seedPhase, seedComesAfter
    // Seedboard 0.3
    case seedPicture, seedSaveStarter
    // Seedboard 0.4
    case seedCrop, seedCaption
    // Seedboard 0.5 (18 Nov 2026): the door, the next note and shape, turning and tidying things,
    // the timeline's Done and Catch up, and the Share page.
    case seedDoor, seedNextNote, seedNextShape, seedTurnInto, seedTidy, seedByColour, seedBreakNotes
    case seedDone, seedCatchUp, seedShare, seedPDF, seedWords, seedPrint, seedCamera, seedScan
    // Seedboard 0.10 (19 Nov 2026): the buttons of 0.9 that borrowed a neighbour's mark or showed only words.
    case seedBalance, seedHighlighter, seedLasso, seedMakeTyped, seedDrawOnIt, seedVote, seedTickList, seedLegend, seedFocus, seedShowFrames, seedSmallMap
    // Seedboard 0.12: the Draw plate's ruler and fade, and "Read this" (handwriting to a note, the sketch stays).
    case seedRuler, seedFade, seedReadThis
    // AMS Persistent Reminder (19 Nov 2026)
    case bell
    // AMS PARAGON build 361 (22 Nov 2026): two people, a project shared with someone
    case people
    // AMS Financial Steward (23 Nov 2026): the three app-icon candidates, a key, a ship's wheel, a rising line with a coin
    case stewardKey, stewardWheel, stewardGrowth
    // AMS Fan Menu (24 Nov 2026): a three-blade fan
    case fan
    // AMS Deck Mate iPhone and iPad 0.32 (25 Nov 2026): "Explain" reads what a key does (a question mark in a ring)
    case deckExplain
    // AMS Triathlon Training (25 Nov 2026): the app's own hand-drawn sport, plan and button marks (its rest-day moon is the library's Night).
    case triBack, triBike, triBody, triBreathing, triCamera, triCheck, triClock, triCloud, triCounts, triHeart, triHike, triMeditation
    case triMic, triMobility, triOther, triPen, triPlan, triPlus, triProgress, triRace, triRowing, triRun, triSettings
    case triShare, triSki, triStrength, triStretch, triSwim, triSync, triToday, triWalk, triYoga

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
        case .lockOpen: return "Lock-free"
        case .star: return "Star"
        case .folder: return "Folder"
        case .person: return "Person"
        case .clock: return "Clock"
        case .drawer: return "Drawer"
        case .drawerOpen: return "Open drawer"
        case .deckRaycast: return "Raycast"
        case .deckKeyboard: return "Keyboard shortcut"
        case .deckText: return "Type text"
        case .deckPlay: return "Play pause"
        case .deckNext: return "Next track"
        case .deckPrevious: return "Previous track"
        case .deckVolumeUp: return "Volume up"
        case .deckVolumeDown: return "Volume down"
        case .deckMute: return "Mute sound"
        case .deckFolder: return "Key folder"
        case .deckBack: return "Back"
        case .deckPageNext: return "Next page"
        case .deckPagePrevious: return "Previous page"
        case .deckProfile: return "Profile"
        case .deckMulti: return "Several"
        case .deckScript: return "Script"
        case .deckClipboard: return "Clipboard"
        case .deckWindowLeft: return "Window left"
        case .deckWindowRight: return "Window right"
        case .deckWindowFull: return "Window full"
        case .deckAi: return "AI"
        case .deckApp: return "App"
        case .gridFlat: return "Flat"
        case .gridEdge: return "Edge"
        case .gridStanding: return "Standing"
        case .gridAuto: return "Auto"
        case .gridBin: return "Cutout bin"
        case .gridBins: return "My bins"
        case .gridStrip: return "Strip"
        case .gridPrintFile: return "Print file"
        case .arrowUp: return "Up"
        case .arrowLeft: return "Left"
        case .arrowRight: return "Right"
        case .deckWindowTop: return "Window top"
        case .deckWindowBottom: return "Window bottom"
        case .deckEject: return "Eject"
        case .deckVideo: return "Video meeting"
        case .deckExplain: return "Explain"
        case .seedMindMap: return "Mind map"
        case .seedBox: return "Box"
        case .seedRound: return "Round box"
        case .seedDiamond: return "Diamond"
        case .seedOval: return "Oval"
        case .seedArrow: return "Arrow"
        case .seedNote: return "Sticky note"
        case .seedText: return "Text"
        case .seedFrame: return "Frame"
        case .seedBoard: return "Board"
        case .seedSprout: return "Seed branches"
        case .seedPin: return "Pin"
        case .seedFit: return "Fit window"
        case .seedStarter: return "Starter"
        case .redo: return "Redo"
        case .duplicate: return "Duplicate"
        case .seedTimeline: return "Timeline"
        case .seedBar: return "Bar"
        case .seedMilestone: return "Milestone"
        case .seedToday: return "Today line"
        case .seedCalendar: return "Calendar"
        case .seedDraw: return "Draw"
        case .seedRubber: return "Rubber"
        case .seedThin: return "Thin line"
        case .seedMedium: return "Medium line"
        case .seedThick: return "Thick line"
        case .seedSequence: return "Sequence"
        case .seedPerson: return "Person"
        case .seedAnswer: return "Answer"
        case .seedDocument: return "Document"
        case .seedSlanted: return "Slanted box"
        case .seedStore: return "Store"
        case .seedLanes: return "Lanes"
        case .seedLineUp: return "Line up"
        case .seedEvenGaps: return "Even gaps"
        case .seedSameSize: return "Same size"
        case .seedOneWay: return "One way"
        case .seedBothWays: return "Both ways"
        case .seedNoEnds: return "No ends"
        case .seedDashed: return "Dashed line"
        case .seedMoveUp: return "Move up"
        case .seedMoveDown: return "Move down"
        case .seedOutLevel: return "Out level"
        case .seedIdeaUnder: return "Idea under"
        case .seedNextIdea: return "Next idea"
        case .seedBranch: return "Branch"
        case .seedBringBack: return "Bring back"
        case .seedEarlier: return "Earlier"
        case .seedExport: return "Export"
        case .seedSearch: return "Search"
        case .seedCut: return "Cut"
        case .seedPaste: return "Paste"
        case .seedRename: return "Rename"
        case .seedHome: return "Home"
        case .seedCopy: return "Copy"
        case .seedSelectAll: return "Select all"
        case .seedLineElbow: return "Elbow line"
        case .seedLineStraight: return "Straight line"
        case .seedLineCurved: return "Curved line"
        case .seedSection: return "Section"
        case .seedNoteBand: return "Note band"
        case .seedPhase: return "Phase"
        case .seedComesAfter: return "Comes after"
        case .seedPicture: return "Picture"
        case .seedSaveStarter: return "Save starter"
        case .seedCrop: return "Crop"
        case .seedCaption: return "Caption"
        case .seedDoor: return "Door"
        case .seedNextNote: return "Next note"
        case .seedNextShape: return "Next shape"
        case .seedTurnInto: return "Turn into"
        case .seedTidy: return "Tidy"
        case .seedByColour: return "By colour"
        case .seedBreakNotes: return "Into notes"
        case .seedDone: return "Done"
        case .seedCatchUp: return "Catch up"
        case .seedShare: return "Share"
        case .seedPDF: return "PDF"
        case .seedWords: return "Words"
        case .seedPrint: return "Print"
        case .seedCamera: return "Camera"
        case .seedScan: return "Scan"
        case .seedBalance: return "Balance"
        case .seedHighlighter: return "Highlighter"
        case .seedLasso: return "Lasso"
        case .seedMakeTyped: return "Make typed"
        case .seedDrawOnIt: return "Draw on"
        case .seedVote: return "Vote"
        case .seedTickList: return "Tick list"
        case .seedLegend: return "Legend"
        case .seedFocus: return "Focus"
        case .seedShowFrames: return "Show frames"
        case .seedSmallMap: return "Small map"
        case .seedRuler: return "Ruler"
        case .seedFade: return "Fade"
        case .seedReadThis: return "Read this"
        case .bell: return "Reminder"
        case .people: return "Shared"
        case .stewardKey: return "Steward key"
        case .stewardWheel: return "Ship wheel"
        case .stewardGrowth: return "Growth coin"
        case .fan: return "Fan"
        case .triBack: return "Tri back"
        case .triBike: return "Tri bike"
        case .triBody: return "Tri body"
        case .triBreathing: return "Tri breathing"
        case .triCamera: return "Tri camera"
        case .triCheck: return "Tri check"
        case .triClock: return "Tri clock"
        case .triCloud: return "Tri cloud"
        case .triCounts: return "Tri counts"
        case .triHeart: return "Tri heart"
        case .triHike: return "Tri hike"
        case .triMeditation: return "Tri meditation"
        case .triMic: return "Tri mic"
        case .triMobility: return "Tri mobility"
        case .triOther: return "Tri other"
        case .triPen: return "Tri pen"
        case .triPlan: return "Tri plan"
        case .triPlus: return "Tri plus"
        case .triProgress: return "Tri progress"
        case .triRace: return "Tri race"
        case .triRowing: return "Tri rowing"
        case .triRun: return "Tri run"
        case .triSettings: return "Tri settings"
        case .triShare: return "Tri share"
        case .triSki: return "Tri ski"
        case .triStrength: return "Tri strength"
        case .triStretch: return "Tri stretch"
        case .triSwim: return "Tri swim"
        case .triSync: return "Tri sync"
        case .triToday: return "Tri today"
        case .triWalk: return "Tri walk"
        case .triYoga: return "Tri yoga"
        }
    }

    /// The drawing on the 24-point box.
    public var path: String {
        switch self {
        // A tray: an open box seen from the front, with the slot as its lip.
        case .inbox: return "M3.5 13v5a1.5 1.5 0 0 0 1.5 1.5h14a1.5 1.5 0 0 0 1.5-1.5v-5 M3.5 13h4.5l1.6 2.5h4.8l1.6-2.5h4.5 M6 13l1.9-6.5h8.2L18 13"
        // The same sun as the hand-drawn "sun" (12 Nov 2026): one sun in the family, not two.
        case .today: return "M8 12a4 4 0 1 0 8 0a4 4 0 1 0 -8 0 M12 2.8v2.4 M12 18.8v2.4 M2.8 12h2.4 M18.8 12h2.4 M5.5 5.5l1.7 1.7 M16.8 16.8l1.7 1.7 M5.5 18.5l1.7-1.7 M16.8 7.2l1.7-1.7"
        case .calendar: return "M3.5 6.5h17v13h-17Z M3.5 10.5h17 M8 4v4.5 M16 4v4.5"
        // The day as an upright line with two blocks on it (12 Nov 2026: the calendar with a tiny clock read as Calendar).
        case .timeBlocks: return "M5 3.5v17 M9 5h10.5v5H9Z M9 13.5h7v5.5H9Z"
        // Round arrows with a tick: something to come back to and tick off (12 Nov 2026: tick + lines read as Snippets).
        case .review: return "M4.5 9.3A8 8 0 0 1 19.5 9.3 M20.9 6.4 19.5 9.3 16.6 8 M19.5 14.7A8 8 0 0 1 4.5 14.7 M3.1 17.6 4.5 14.7 7.4 16 M9 12.2l2.2 2.2 3.8-4.3"
        case .map: return "M9.5 6a2.5 2.5 0 1 0 5 0a2.5 2.5 0 1 0 -5 0 M3.5 18a2.5 2.5 0 1 0 5 0a2.5 2.5 0 1 0 -5 0 M15.5 18a2.5 2.5 0 1 0 5 0a2.5 2.5 0 1 0 -5 0 M10.5 9 7.5 15 M13.5 9l3 6"
        case .recent: return "M6.5 15.75A7.5 7.5 0 1 0 6.5 8.25 M9.4 7.5 6.5 8.25 5.7 5.3 M13 8v4.5l3 1.8"
        case .bin: return "M4.5 7h15 M9.5 7V5h5v2 M6 7l1 13.5h10L18 7 M10 11v6 M14 11v6"
        // Two pages, one behind the other: a page to copy (12 Nov 2026: the corner gear melted at list size).
        case .templates: return "M9 7.5h6.5l4 4V20.5H9Z M15.5 7.5v4h4 M6 16.5V3.5h7.5"
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
        // The archive box with a small arrow going into it (12 Nov 2026: an arrow into a plain
        // tray read as Inbox in the blind test).
        case .archiveDown: return "M12 2.8v5.2 M9.6 5.6 12 8l2.4-2.4 M3.5 10.5h17v3.5h-17Z M5 14v6.5h14V14 M10 17.2h4"
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
        // The four colours are points of the line (12 Nov 2026: small rings filled in).
        case .palette: return "M20.4 13.5A8.5 8.5 0 1 0 14.9 20A4.6 4.6 0 0 1 20.4 13.5Z M8.5 10.5h.01 M12 7.5h.01 M15.5 9.5h.01 M7.5 14.8h.01"
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
        // The same box as the hand-drawn "box" (12 Nov 2026).
        case .parcel: return "M3.5 7.8 12 3.8l8.5 4v8.9L12 20.7l-8.5-4Z M3.5 7.8 12 11.8l8.5-4 M12 11.8v8.9 M7.8 5.8l8.4 4"
        case .minus: return "M5 12h14"
        case .zoomIn: return "M4.5 10.5a6 6 0 1 0 12 0a6 6 0 1 0 -12 0 M15 15l5 5 M10.5 8v5 M8 10.5h5"
        case .zoomOut: return "M4.5 10.5a6 6 0 1 0 12 0a6 6 0 1 0 -12 0 M15 15l5 5 M8 10.5h5"
        case .filter: return "M4 12a8 8 0 1 0 16 0a8 8 0 1 0 -16 0 M7.5 9.5h9 M9 12.5h6 M10.5 15.5h3"
        case .undo: return "M4.5 9.5h9a5.5 5.5 0 0 1 0 11H9 M8 6 4.5 9.5 8 13"
        case .trayFull: return "M3.5 13v5a1.5 1.5 0 0 0 1.5 1.5h14a1.5 1.5 0 0 0 1.5-1.5v-5 M3.5 13h4.5l1.6 2.5h4.8l1.6-2.5h4.5 M8 4.5h8 M8 8.5h8"
        case .dot: return "M9 12a3 3 0 1 0 6 0a3 3 0 1 0 -6 0"
        case .lock: return "M5.5 10.5h13v10h-13Z M8 10.5V7.5a4 4 0 0 1 8 0v3 M12 14.5v2.5"
        // The lock with its shackle swung open: it rises from the left post and ends free in the air (AMS Reading Companion, 17 Nov 2026).
        case .lockOpen: return "M5.5 10.5h13v10h-13Z M8 10.5V7a4 4 0 0 1 7.6-1.7 M12 14.5v2.5"
        case .star: return "M12 3.8l2.5 5.2 5.7.8-4.1 4 1 5.6L12 16.7l-5.1 2.7 1-5.6-4.1-4 5.7-.8Z"
        case .folder: return "M3.5 7a1.5 1.5 0 0 1 1.5-1.5h4.3l2.2 2.5H19a1.5 1.5 0 0 1 1.5 1.5v8.5a1.5 1.5 0 0 1-1.5 1.5H5a1.5 1.5 0 0 1-1.5-1.5Z"
        // A head and shoulders in a ring.
        case .person: return "M4 12a8 8 0 1 0 16 0a8 8 0 1 0 -16 0 M9.6 10a2.4 2.4 0 1 0 4.8 0a2.4 2.4 0 1 0 -4.8 0 M7 18.2a5.3 5.3 0 0 1 10 0"
        // A plain clock face; the timer keeps its button on top.
        case .clock: return "M3.5 12a8.5 8.5 0 1 0 17 0a8.5 8.5 0 1 0 -17 0 M12 7v5l3.5 2"
        // A closed drawer and the same drawer pulled out — first drawn for AMS Tidy Bar (13 Nov 2026).
        case .drawer: return "M6.5 7h11a2.5 2.5 0 0 1 2.5 2.5v5a2.5 2.5 0 0 1-2.5 2.5h-11a2.5 2.5 0 0 1-2.5-2.5v-5a2.5 2.5 0 0 1 2.5-2.5Z M10 12h4"
        case .drawerOpen: return "M5.2 10.5h9.6a2.2 2.2 0 0 1 2.2 2.2v4.6a2.2 2.2 0 0 1-2.2 2.2H5.2A2.2 2.2 0 0 1 3 17.3v-4.6a2.2 2.2 0 0 1 2.2-2.2Z M8 15h4 M5 10.5 9 4.5h12v8L17 17"
        // The 22 marks drawn for AMS Deck Mate (16 Nov 2026).
        case .deckRaycast: return "M4.5 19.5 19.5 4.5 M4.5 12 12 4.5 M12 19.5 19.5 12"
        case .deckKeyboard: return "M4.5 6.5h15a1.5 1.5 0 0 1 1.5 1.5v8a1.5 1.5 0 0 1 -1.5 1.5h-15a1.5 1.5 0 0 1 -1.5-1.5v-8a1.5 1.5 0 0 1 1.5-1.5z M7 10.2h.01 M10.3 10.2h.01 M13.7 10.2h.01 M17 10.2h.01 M8.5 14h7"
        case .deckText: return "M4.5 18 9 6l4.5 12 M6.2 14h5.6 M16.5 10.5h3 M16.5 14.2h3 M16.5 18h3"
        case .deckPlay: return "M5.5 6.5v11l8-5.5z M16.5 7v10 M19.5 7v10"
        case .deckNext: return "M5.5 6.5v11l8.5-5.5z M18 6.5v11"
        case .deckPrevious: return "M18.5 6.5v11l-8.5-5.5z M6 6.5v11"
        case .deckVolumeUp: return "M4 9.8h3.2l4.3-3.6v11.6l-4.3-3.6H4z M15 9.5a3.6 3.6 0 0 1 0 5 M17.6 7a7.2 7.2 0 0 1 0 10"
        case .deckVolumeDown: return "M4 9.8h3.2l4.3-3.6v11.6l-4.3-3.6H4z M15 9.5a3.6 3.6 0 0 1 0 5"
        case .deckMute: return "M4 9.8h3.2l4.3-3.6v11.6l-4.3-3.6H4z M15.5 9.5l5 5 M20.5 9.5l-5 5"
        case .deckFolder: return "M3.5 7.5a1.5 1.5 0 0 1 1.5-1.5h4l2 2.2h8a1.5 1.5 0 0 1 1.5 1.5v7.8a1.5 1.5 0 0 1 -1.5 1.5h-14a1.5 1.5 0 0 1 -1.5-1.5z M8.5 13.6h.01 M12 13.6h.01 M15.5 13.6h.01"
        case .deckBack: return "M9 14.5 4.5 10 9 5.5 M4.5 10h10a5 5 0 0 1 0 10h-3"
        case .deckPageNext: return "M4.5 12h.01 M8.5 12h.01 M13 6.5l5.5 5.5-5.5 5.5"
        case .deckPagePrevious: return "M19.5 12h-.01 M15.5 12h-.01 M11 6.5 5.5 12l5.5 5.5"
        case .deckProfile: return "M12 4.5 20 9l-8 4.5L4 9z M4.5 12.8 12 17l7.5-4.2 M4.5 16.3 12 20.5l7.5-4.2"
        case .deckMulti: return "M4.5 6h5v4h-5z M14.5 14h5v4h-5z M9.5 8h4a1.5 1.5 0 0 1 1.5 1.5v2"
        case .deckScript: return "M4.5 5.5h15a1.5 1.5 0 0 1 1.5 1.5v10a1.5 1.5 0 0 1 -1.5 1.5h-15a1.5 1.5 0 0 1 -1.5-1.5v-10a1.5 1.5 0 0 1 1.5-1.5z M7 9.5l3 2.5-3 2.5 M12.5 14.8h4.5"
        case .deckClipboard: return "M8.5 5.5h-2a1.5 1.5 0 0 0 -1.5 1.5v12a1.5 1.5 0 0 0 1.5 1.5h11a1.5 1.5 0 0 0 1.5-1.5v-12a1.5 1.5 0 0 0 -1.5-1.5h-2 M9 4h6v3.2h-6z M8.5 12h7 M8.5 15.8h4.5"
        case .deckWindowLeft: return "M4.5 5.5h15a1.5 1.5 0 0 1 1.5 1.5v10a1.5 1.5 0 0 1 -1.5 1.5h-15a1.5 1.5 0 0 1 -1.5-1.5v-10a1.5 1.5 0 0 1 1.5-1.5z M12 5.5v13 M5.8 9h3.4 M5.8 12h3.4 M5.8 15h3.4"
        case .deckWindowRight: return "M4.5 5.5h15a1.5 1.5 0 0 1 1.5 1.5v10a1.5 1.5 0 0 1 -1.5 1.5h-15a1.5 1.5 0 0 1 -1.5-1.5v-10a1.5 1.5 0 0 1 1.5-1.5z M12 5.5v13 M14.8 9h3.4 M14.8 12h3.4 M14.8 15h3.4"
        case .deckWindowFull: return "M4.5 5.5h15a1.5 1.5 0 0 1 1.5 1.5v10a1.5 1.5 0 0 1 -1.5 1.5h-15a1.5 1.5 0 0 1 -1.5-1.5v-10a1.5 1.5 0 0 1 1.5-1.5z M6.5 12V9.5H9 M17.5 12v2.5H15"
        case .deckAi: return "M11 4.5c.6 3.8 2.2 5.4 6 6-3.8.6-5.4 2.2-6 6-.6-3.8-2.2-5.4-6-6 3.8-.6 5.4-2.2 6-6z M18 15.5v4 M16 17.5h4"
        case .deckApp: return "M6.5 4.5h11a2 2 0 0 1 2 2v11a2 2 0 0 1 -2 2h-11a2 2 0 0 1 -2-2v-11a2 2 0 0 1 2-2z M9 9h.01 M15 9h.01 M9 15h.01 M15 15h.01"
        case .gridFlat: return "M3.5 12.5h17v5h-17Z M2.5 20.5h19"
        case .gridEdge: return "M6 8.5h12v9H6Z M2.5 20.5h19"
        case .gridStanding: return "M8.5 3.5h7v14h-7Z M2.5 20.5h19"
        case .gridAuto: return "M3.5 3.5h17v17h-17Z M8 16.5l4-9 4 9 M9.6 13.2h4.8"
        case .gridBin: return "M6 5h12a2.5 2.5 0 0 1 2.5 2.5v9A2.5 2.5 0 0 1 18 19H6a2.5 2.5 0 0 1-2.5-2.5v-9A2.5 2.5 0 0 1 6 5Z M9.5 9h5A1.5 1.5 0 0 1 16 10.5v3A1.5 1.5 0 0 1 14.5 15h-5A1.5 1.5 0 0 1 8 13.5v-3A1.5 1.5 0 0 1 9.5 9Z"
        case .gridBins: return "M5 4h3a1.5 1.5 0 0 1 1.5 1.5v3A1.5 1.5 0 0 1 8 10H5A1.5 1.5 0 0 1 3.5 8.5v-3A1.5 1.5 0 0 1 5 4Z M13 5.5h7.5 M13 8.5h5 M5 14h3a1.5 1.5 0 0 1 1.5 1.5v3A1.5 1.5 0 0 1 8 20H5a1.5 1.5 0 0 1-1.5-1.5v-3A1.5 1.5 0 0 1 5 14Z M13 15.5h7.5 M13 18.5h5"
        case .gridStrip: return "M5 8h14a2 2 0 0 1 2 2v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4a2 2 0 0 1 2-2Z M7.5 11v2 M12 10.5v3 M16.5 10v4"
        case .gridPrintFile: return "M13.5 3.5H7A1.5 1.5 0 0 0 5.5 5v14A1.5 1.5 0 0 0 7 20.5h10a1.5 1.5 0 0 0 1.5-1.5V8.5Z M13.5 3.5v5h5 M12 11.5v5.5 M9.5 14.5L12 17l2.5-2.5"
        // The same shafts and heads as "Down", turned.
        case .arrowUp: return "M12 20V4 M5.5 10.5 12 4l6.5 6.5"
        case .arrowLeft: return "M20 12H4 M10.5 5.5 4 12l6.5 6.5"
        case .arrowRight: return "M4 12h16 M13.5 5.5 20 12l-6.5 6.5"
        // The window of "Window left" and "Window right", split across: one line marks the half meant.
        case .deckWindowTop: return "M4.5 5.5h15a1.5 1.5 0 0 1 1.5 1.5v10a1.5 1.5 0 0 1 -1.5 1.5h-15a1.5 1.5 0 0 1 -1.5-1.5v-10a1.5 1.5 0 0 1 1.5-1.5z M3 12h18 M6.5 8.75h11"
        case .deckWindowBottom: return "M4.5 5.5h15a1.5 1.5 0 0 1 1.5 1.5v10a1.5 1.5 0 0 1 -1.5 1.5h-15a1.5 1.5 0 0 1 -1.5-1.5v-10a1.5 1.5 0 0 1 1.5-1.5z M3 12h18 M6.5 15.25h11"
        case .deckEject: return "M12 5l7.5 9h-15z M4.5 18.5h15"
        case .deckVideo: return "M5 6.5h8a2 2 0 0 1 2 2v7a2 2 0 0 1 -2 2h-8a2 2 0 0 1 -2-2v-7a2 2 0 0 1 2-2z M15 10.5l5.5-3v9l-5.5-3"
        case .deckExplain: return "M3 12a9 9 0 1 0 18 0a9 9 0 1 0 -18 0 M9.5 9.4a2.6 2.6 0 0 1 5.1.8c0 1.7-2.6 2.1-2.6 3.9 M12 17.1v.01"
        case .seedMindMap: return "M4.25 12a2.5 2.5 0 1 0 5 0a2.5 2.5 0 1 0 -5 0 M9.25 12H19.75 M9.25 11C11.75 8 12.75 6.5 15.75 6.5H19.75 M9.25 13C11.75 16 12.75 17.5 15.75 17.5H19.75"
        case .seedBox: return "M6.5 6.5h11a2.5 2.5 0 0 1 2.5 2.5v6a2.5 2.5 0 0 1 -2.5 2.5h-11a2.5 2.5 0 0 1 -2.5-2.5v-6a2.5 2.5 0 0 1 2.5-2.5z"
        case .seedRound: return "M8.5 7h7a5 5 0 0 1 0 10h-7a5 5 0 0 1 0-10z"
        case .seedDiamond: return "M12 4L20 12L12 20L4 12Z"
        case .seedOval: return "M3.5 12a8.5 6 0 1 0 17 0a8.5 6 0 1 0 -17 0"
        case .seedArrow: return "M5.75 18C10.75 18 9.75 9 17.75 9 M14.25 5.8L18.25 9L14.75 12.6"
        case .seedNote: return "M5 5H19V14L14 19H5Z M14 19V14H19"
        case .seedText: return "M6 6.5H18 M12 6.5V18"
        case .seedFrame: return "M4 8V5.5A1.5 1.5 0 0 1 5.5 4H8 M16 4H18.5A1.5 1.5 0 0 1 20 5.5V8 M20 16V18.5A1.5 1.5 0 0 1 18.5 20H16 M8 20H5.5A1.5 1.5 0 0 1 4 18.5V16"
        case .seedBoard: return "M6.5 4.5h11a3 3 0 0 1 3 3v9a3 3 0 0 1 -3 3h-11a3 3 0 0 1 -3-3v-9a3 3 0 0 1 3-3z M12 16.5V10.5 M12 11.5C9.6 11.5 8 10 8 7.8C10.4 7.8 12 9.2 12 11.5Z M12 13.2C12 11 13.6 9.6 16 9.6C16 11.8 14.4 13.2 12 13.2Z"
        case .seedSprout: return "M4.6 12a2.8 4 0 1 0 5.6 0a2.8 4 0 1 0 -5.6 0 M10.2 12H15.5 M9.9 10.6C11.9 8 13.1 6.5 15.9 6.5 M9.9 13.4C11.9 16 13.1 17.5 15.9 17.5 M16 6.5a1.7 1.7 0 1 0 3.4 0a1.7 1.7 0 1 0 -3.4 0 M15.6 12a1.7 1.7 0 1 0 3.4 0a1.7 1.7 0 1 0 -3.4 0 M16 17.5a1.7 1.7 0 1 0 3.4 0a1.7 1.7 0 1 0 -3.4 0"
        case .seedPin: return "M12 21.5C8.5 17.5 5.5 13.8 5.5 9.5a6.5 6.5 0 0 1 13 0c0 4.3-3 8-6.5 12Z M9.7 9.5a2.3 2.3 0 1 0 4.6 0a2.3 2.3 0 1 0 -4.6 0"
        case .seedFit: return "M4 9V4H9 M15 4H20V9 M20 15V20H15 M9 20H4V15 M9.5 9.5h5v5h-5z"
        case .seedStarter: return "M13.5 3.5H7A1.5 1.5 0 0 0 5.5 5v14A1.5 1.5 0 0 0 7 20.5h10a1.5 1.5 0 0 0 1.5-1.5V8.5Z M13.5 3.5v5h5 M12 11.5v5.5 M9.25 14.25h5.5"
        case .redo: return "M19.5 9.5h-9a5.5 5.5 0 0 0 0 11H15 M16 6l3.5 3.5L16 13"
        case .duplicate: return "M9 15H6a2 2 0 0 1 -2-2V6a2 2 0 0 1 2-2h7a2 2 0 0 1 2 2v3.5 M11 9.5h7a2 2 0 0 1 2 2v7a2 2 0 0 1 -2 2h-7a2 2 0 0 1 -2-2v-7a2 2 0 0 1 2-2z"
        // The 37 marks drawn for AMS Seedboard 0.2 (18 Nov 2026). A dashed line is drawn dash by dash,
        // and a thicker line as two or three lines side by side: the stroke itself stays 1.9.
        // Three bars of a plan, each starting later than the one above.
        case .seedTimeline: return "M4 4.2h8.5v3.4H4Z M7.5 10.3h10v3.4h-10Z M13 16.4h7v3.4h-7Z"
        // One bar of the timeline with a grip at each end.
        case .seedBar: return "M7 8.5h10v7H7Z M3.9 12h.01 M20.1 12h.01"
        // A small diamond on the line of time.
        case .seedMilestone: return "M4 12h3.5 M16.5 12H20 M12 7.5L16.5 12L12 16.5L7.5 12Z"
        // The line of today: upright with a small flag on top, crossing the line of time.
        case .seedToday: return "M10.5 4.5V20 M10.5 4.5L18 7.25L10.5 10 M4.5 16h15"
        // A calendar sheet with two rings and a row of days.
        case .seedCalendar: return "M5 6h14a1.5 1.5 0 0 1 1.5 1.5v10.5a1.5 1.5 0 0 1 -1.5 1.5h-14a1.5 1.5 0 0 1 -1.5-1.5v-10.5a1.5 1.5 0 0 1 1.5-1.5z M8 4v4 M16 4v4 M8 13.5h.01 M12 13.5h.01 M16 13.5h.01"
        // A pencil and the curly line it has just drawn.
        case .seedDraw: return "M9 15l.8-3.3L17.7 3.8a1.6 1.6 0 0 1 2.3 2.3L12.1 14.1Z M9 15C6.5 15.6 4.4 16.6 4.4 18.2C4.4 19.8 6.6 19.8 7.8 18.6C9 17.4 10.4 17.4 11.2 18.6C11.9 19.6 13.2 19.8 14.5 19.2"
        // A rubber leaning on the line it rubs out.
        case .seedRubber: return "M14.5 4.5L19.5 9.5L9.5 19.5L4.5 14.5Z M8 11L13 16 M9.5 19.5H19.5"
        // One wavy line.
        case .seedThin: return "M4 12C6.7 8.5 9.3 8.5 12 12S17.3 15.5 20 12"
        // Two wavy lines.
        case .seedMedium: return "M4 10.2C6.7 6.7 9.3 6.7 12 10.2S17.3 13.7 20 10.2 M4 13.8C6.7 10.3 9.3 10.3 12 13.8S17.3 17.3 20 13.8"
        // Three wavy lines.
        case .seedThick: return "M4 8.5C6.7 5 9.3 5 12 8.5S17.3 12 20 8.5 M4 12C6.7 8.5 9.3 8.5 12 12S17.3 15.5 20 12 M4 15.5C6.7 12 9.3 12 12 15.5S17.3 19 20 15.5"
        // Two lifelines, a message across and the answer back.
        case .seedSequence: return "M4.5 4v16 M19.5 4v16 M4.5 8.5h15 M16.5 6l3 2.5-3 2.5 M19.5 15.5h-15 M7.5 13l-3 2.5 3 2.5"
        // A head and shoulders, without the ring of the general Person mark.
        case .seedPerson: return "M8.8 7.7a3.2 3.2 0 1 0 6.4 0a3.2 3.2 0 1 0 -6.4 0 M5 19.5c0-3.6 3-6 7-6s7 2.4 7 6"
        // A dashed arrow coming back to the left.
        case .seedAnswer: return "M20 12h-2.5 M14.25 12h-2.5 M8.5 12H4 M8 8L4 12l4 4"
        // A sheet with a wavy lower edge.
        case .seedDocument: return "M4.5 5.5h15v12c-2.5-1.8-5-1.8-7.5 0s-5 1.8-7.5 0Z"
        // A box leaning to the right.
        case .seedSlanted: return "M8.5 6.5h12l-5 11h-12z"
        // A drum: where things are kept.
        case .seedStore: return "M5 7a7 2.8 0 1 0 14 0a7 2.8 0 1 0 -14 0 M5 7v10a7 2.8 0 0 0 14 0V7"
        // A frame split into three rows.
        case .seedLanes: return "M5.5 4.5h13a2 2 0 0 1 2 2v11a2 2 0 0 1 -2 2h-13a2 2 0 0 1 -2-2v-11a2 2 0 0 1 2-2z M3.5 9.5h17 M3.5 14.5h17"
        // Two boxes of different width, centred on one upright line.
        case .seedLineUp: return "M12 4v2.5 M12 10.5v3 M12 17.5V20 M5.5 6.5h13v4h-13Z M8.5 13.5h7v4h-7Z"
        // Three boxes in a row with the same gap between them, over a bracket.
        case .seedEvenGaps: return "M4 5.5h3v6H4Z M10.5 5.5h3v6h-3Z M17 5.5h3v6h-3Z M4 15.5v3.5h16v-3.5"
        // Two boxes of one size under an equals sign.
        case .seedSameSize: return "M4 11h6.5v8.5H4Z M13.5 11H20v8.5h-6.5Z M9.5 4.5h5 M9.5 7.8h5"
        // A line with a head at the right.
        case .seedOneWay: return "M4 12h16 M16 8l4 4-4 4"
        // A line with a head at each end.
        case .seedBothWays: return "M4 12h16 M8 8L4 12l4 4 M16 8l4 4-4 4"
        // A plain line between two small rings.
        case .seedNoEnds: return "M3.7 12a1.8 1.8 0 1 0 3.6 0a1.8 1.8 0 1 0 -3.6 0 M16.7 12a1.8 1.8 0 1 0 3.6 0a1.8 1.8 0 1 0 -3.6 0 M7.3 12h9.4"
        // A line of three dashes with a head at the right.
        case .seedDashed: return "M4 12h2.5 M9.75 12h2.5 M15.5 12H20 M16 8l4 4-4 4"
        // A branch and an arrow up beside it.
        case .seedMoveUp: return "M4 12h7 M16 19.5v-15 M12 8.5l4-4 4 4"
        // A branch and an arrow down beside it.
        case .seedMoveDown: return "M4 12h7 M16 4.5v15 M12 15.5l4 4 4-4"
        // A branch under its parent, and an arrow taking it out to the left.
        case .seedOutLevel: return "M4 7h8 M14.5 16H20 M10.5 16H4 M7.5 12.5L4 16l3.5 3.5"
        // An idea, a branch going right and down, and a plus for the new idea under it.
        case .seedIdeaUnder: return "M6.5 4.5h2a2.5 2.5 0 0 1 0 5h-2a2.5 2.5 0 0 1 0-5z M11 7h2.5a3 3 0 0 1 3 3v1 M13.75 16.5h5.5 M16.5 13.75v5.5"
        // An idea, a branch straight down, and a plus for the next idea.
        case .seedNextIdea: return "M9 4h6a2.5 2.5 0 0 1 0 5H9a2.5 2.5 0 0 1 0-5z M12 9v2.5 M9.25 17h5.5 M12 14.25v5.5"
        // One node and a single fork of two lines.
        case .seedBranch: return "M4.5 12a2.5 2.5 0 1 0 5 0a2.5 2.5 0 1 0 -5 0 M9.5 12h3 M19.5 6.5H17C14 6.5 12.5 9 12.5 12C12.5 15 14 17.5 17 17.5H19.5"
        // A board with a round arrow turning back inside it.
        case .seedBringBack: return "M6.5 4.5h11a3 3 0 0 1 3 3v9a3 3 0 0 1 -3 3h-11a3 3 0 0 1 -3-3v-9a3 3 0 0 1 3-3z M8.8 14A4 4 0 1 0 8.8 10 M11.3 9.6 8.8 10 8 7.6"
        // A whole clock face with an arrow turning back round it.
        case .seedEarlier: return "M9.2 13.9a5 5 0 1 0 10 0a5 5 0 1 0 -10 0 M14.2 11.2v2.7l1.9 1.2 M16.5 5.2A9 9 0 0 0 5.5 11.6 M4.4 9.2 5.5 11.6 7.6 10.1"
        // A box open at the top and an arrow going up and out.
        case .seedExport: return "M4.5 12.5v5.5a1.5 1.5 0 0 0 1.5 1.5h12a1.5 1.5 0 0 0 1.5-1.5v-5.5 M12 15V4 M8 8l4-4 4 4"
        // A magnifier.
        case .seedSearch: return "M4.5 10.25a5.75 5.75 0 1 0 11.5 0a5.75 5.75 0 1 0 -11.5 0 M14.4 14.4L19.5 19.5"
        // Scissors, open.
        case .seedCut: return "M4 7.5a2.5 2.5 0 1 0 5 0a2.5 2.5 0 1 0 -5 0 M4 16.5a2.5 2.5 0 1 0 5 0a2.5 2.5 0 1 0 -5 0 M8.5 9L19.5 17 M8.5 15L19.5 7"
        // A clipboard with a sheet in front of it.
        case .seedPaste: return "M8.5 5.5h-2a1.5 1.5 0 0 0 -1.5 1.5v11.5a1.5 1.5 0 0 0 1.5 1.5h2.5 M15.5 5.5h2a1.5 1.5 0 0 1 1.5 1.5v2.5 M9 4h6v3.2h-6z M11.5 12h8v8.5h-8z"
        // A text cursor beside a short line of text.
        case .seedRename: return "M14 4.5c1.5 0 2.5.8 2.5 2v11c0 1.2-1 2-2.5 2 M19 4.5c-1.5 0-2.5.8-2.5 2 M19 19.5c-1.5 0-2.5-.8-2.5-2 M4.5 12h7.5"
        // A small house: roof, body and a door.
        case .seedHome: return "M3.5 11.5L12 4L20.5 11.5 M6 9.5V18.5A1 1 0 0 0 7 19.5H17A1 1 0 0 0 18 18.5V9.5 M10 19.5V15H14V19.5"
        // One sheet in front of another, with two lines of text on the front one.
        case .seedCopy: return "M6 8.5h8a1.5 1.5 0 0 1 1.5 1.5v8a1.5 1.5 0 0 1 -1.5 1.5H6A1.5 1.5 0 0 1 4.5 18v-8A1.5 1.5 0 0 1 6 8.5z M8.5 8.5V5A1.5 1.5 0 0 1 10 3.5h8A1.5 1.5 0 0 1 19.5 5v8a1.5 1.5 0 0 1 -1.5 1.5h-2.5 M7.5 13h5 M7.5 16h3"
        // A dashed box (corners and a short dash in each side) with a tick inside.
        case .seedSelectAll: return "M4 8.5V6a2 2 0 0 1 2-2h2.5 M15.5 4H18a2 2 0 0 1 2 2v2.5 M20 15.5V18a2 2 0 0 1 -2 2h-2.5 M8.5 20H6a2 2 0 0 1 -2-2v-2.5 M11 4h2 M11 20h2 M4 11.2v1.6 M20 11.2v1.6 M8.5 12.3L11 14.8L15.5 9.5"
        // A line with right angles, out, down, along, between two small dots.
        case .seedLineElbow: return "M4.5 6H12V18H19.5 M3.7 6a0.8 0.8 0 1 0 1.6 0a0.8 0.8 0 1 0 -1.6 0 M18.7 18a0.8 0.8 0 1 0 1.6 0a0.8 0.8 0 1 0 -1.6 0"
        // A straight slanted line between two small dots.
        case .seedLineStraight: return "M4.5 18.5L19.5 5.5 M3.7 18.5a0.8 0.8 0 1 0 1.6 0a0.8 0.8 0 1 0 -1.6 0 M18.7 5.5a0.8 0.8 0 1 0 1.6 0a0.8 0.8 0 1 0 -1.6 0"
        // A smooth S-curve between two small dots.
        case .seedLineCurved: return "M4.5 18C12 18 12 6 19.5 6 M3.7 18a0.8 0.8 0 1 0 1.6 0a0.8 0.8 0 1 0 -1.6 0 M18.7 6a0.8 0.8 0 1 0 1.6 0a0.8 0.8 0 1 0 -1.6 0"
        // A short heading bar sitting on a long thin level line.
        case .seedSection: return "M4 4.8h9v1.2H4Z M4 16h16"
        // Two short upright dashed lines with a soft level band across them.
        case .seedNoteBand: return "M8 3.5v2.5 M8 18v2.5 M16 3.5v2.5 M16 18v2.5 M5.5 9.5h13a1.5 1.5 0 0 1 1.5 1.5v2a1.5 1.5 0 0 1 -1.5 1.5h-13A1.5 1.5 0 0 1 4 13v-2A1.5 1.5 0 0 1 5.5 9.5z"
        // A timeline heading row: a thick label on the left, a bracket spanning two short bars under it.
        case .seedPhase: return "M4 3.8h8v1.2H4Z M4 11V9.5h16V11 M4 14.5h8 M12 19h8"
        // One short bar upper left, one lower right, a small elbow arrow from the end of the first to the start of the second.
        case .seedComesAfter: return "M4 4.8h4.5v1.2H4Z M16.5 17.6h3.5v1.2h-3.5Z M8.5 5.4H10.5V18.2H14.6 M12.8 16.4L14.6 18.2L12.8 20"
        case .seedPicture: return "M6 5h12a2.5 2.5 0 0 1 2.5 2.5v9a2.5 2.5 0 0 1 -2.5 2.5h-12a2.5 2.5 0 0 1 -2.5-2.5v-9a2.5 2.5 0 0 1 2.5-2.5z M15.1 8.75a1.4 1.4 0 1 0 2.8 0a1.4 1.4 0 1 0 -2.8 0 M3.5 16.5L8.5 11L12 14.5L14.5 13L20.5 16.5"
        case .seedSaveStarter: return "M11.5 6.5H5.75A1.75 1.75 0 0 0 4 8.25v10A1.75 1.75 0 0 0 5.75 20h7.5A1.75 1.75 0 0 0 15 18.25V10Z M11.5 6.5v3.5h3.5 M19 3.75v4.5 M16.75 6h4.5"
        case .seedCrop: return "M7 3.5V17H20.5 M17 20.5V7H3.5"
        case .seedCaption: return "M5.5 3.5h13a2 2 0 0 1 2 2v5.5a2 2 0 0 1 -2 2h-13a2 2 0 0 1 -2-2v-5.5a2 2 0 0 1 2-2z M7.5 10.5L10.5 7.5L12.5 9.5L14 8L16.5 10.5 M4.5 17H19.5 M4.5 20.5H13"
        // The 15 marks drawn for AMS Seedboard 0.5 (18 Nov 2026).
        // A door on its threshold, with its knob: the way into another board.
        case .seedDoor: return "M6.5 20.5V5.5a2 2 0 0 1 2-2h7a2 2 0 0 1 2 2v15 M3 20.5h18 M14 12.5h.01"
        // A sticky note with its folded corner, and a plus beside that corner for the next one.
        case .seedNextNote: return "M4 3.5h11.5V11L11 15.5H4Z M11 15.5V11h4.5 M15.75 18.25h5 M18.25 15.75v5"
        // A box, and a plus to its right for the next one (the idea's plus hangs under it on a stem).
        case .seedNextShape: return "M5 8.25h5a2 2 0 0 1 2 2v3.5a2 2 0 0 1 -2 2h-5a2 2 0 0 1 -2-2v-3.5a2 2 0 0 1 2-2z M15.5 12h5 M18 9.5v5"
        // A ring, and a bent arrow from it down to a box: one thing becomes another kind.
        case .seedTurnInto: return "M3.75 7a3.25 3.25 0 1 0 6.5 0a3.25 3.25 0 1 0 -6.5 0 M13 6.5h1.5a3 3 0 0 1 3 3v1.5 M15 8.6 17.5 11.1 20 8.6 M15.5 15h4a1.5 1.5 0 0 1 1.5 1.5v2.5a1.5 1.5 0 0 1 -1.5 1.5h-4a1.5 1.5 0 0 1 -1.5-1.5v-2.5a1.5 1.5 0 0 1 1.5-1.5z"
        // Three squares already in their places of a grid and the fourth still askew.
        case .seedTidy: return "M4 4h6.5v6.5H4Z M13.5 4H20v6.5h-6.5Z M4 13.5h6.5V20H4Z M15.85 13.4 21.1 15.85 18.65 21.1 13.4 18.65Z"
        // Two columns of things, each under its own colour: a ring over one, a full dot over the other.
        case .seedByColour: return "M4.5 4.75a2 2 0 1 0 4 0a2 2 0 1 0 -4 0 M16.5 4.75a1 1 0 1 0 2 0a1 1 0 1 0 -2 0 M3.5 10h6v3.5h-6Z M3.5 17h6v3.5h-6Z M14.5 10h6v3.5h-6Z"
        // An idea on top and two sticky notes under it, joined by a fork.
        case .seedBreakNotes: return "M8.5 3.5h7a2.25 2.25 0 0 1 0 4.5h-7a2.25 2.25 0 0 1 0-4.5z M7 13.5 12 8l5 5.5 M3.5 13.5h7v4.5L8 20.5H3.5Z M13.5 13.5h7v4.5L18 20.5h-4.5Z"
        // A bar of the timeline and a tick after its end (the plain Bar has a grip dot at each end).
        case .seedDone: return "M3 8.5h8v7H3Z M14.5 12.5l2.3 2.8 4.2-7.3"
        // The upright line of today, two bars that now start on it, and the arrow that pushed them there.
        case .seedCatchUp: return "M11 3.5v17 M11 5.5h9.5v4H11 M11 14.5h6.5v4H11 M3 12h5.2 M5.8 9.6 8.2 12 5.8 14.4"
        // Three rings joined by two lines: one thing going to two places (Export is the tray with the arrow up).
        case .seedShare: return "M15.5 6.2a2.3 2.3 0 1 0 4.6 0a2.3 2.3 0 1 0 -4.6 0 M3.9 12a2.3 2.3 0 1 0 4.6 0a2.3 2.3 0 1 0 -4.6 0 M15.5 17.8a2.3 2.3 0 1 0 4.6 0a2.3 2.3 0 1 0 -4.6 0 M8.3 10.9 15.7 7.3 M8.3 13.1l7.4 3.6"
        // A page with a folded corner and a label across its lower left, with one word on it.
        case .seedPDF: return "M7 11.5V3.5h7.5l5 5v12H7v-3 M14.5 3.5v5h5 M3.5 11.5H15v6H3.5Z M6.5 14.5h5.5"
        // Four lines of words with a ragged right edge, and no frame round them.
        case .seedWords: return "M4 5.5h16 M4 10h12.5 M4 14.5h16 M4 19h8.5"
        // The same printer as the hand-drawn "printer": one printer in the family, not two.
        case .seedPrint: return "M7 9V4h10v5 M5.5 9h13a2 2 0 0 1 2 2v4a2 2 0 0 1-2 2h-13a2 2 0 0 1-2-2v-4a2 2 0 0 1 2-2Z M7 14.5h10V20H7Z M17 12h.5"
        // The same camera as the hand-drawn "camera": one camera in the family, not two.
        case .seedCamera: return "M3.5 8h4l1.5-2.5h6L16.5 8h4v11h-17Z M8.6 13.3a3.4 3.4 0 1 0 6.8 0a3.4 3.4 0 1 0 -6.8 0"
        // A page with the light bar across it: drawn above the bar, only its two lower corners below.
        case .seedScan: return "M6.5 12V3.5h7l4 4V12 M13.5 3.5v4h4 M3 12h18 M6.5 15.5v5h3.5 M14 20.5h3.5v-5"
        // Seedboard 0.10 (19 Nov 2026).
        // A middle idea with two branches to each side.
        case .seedBalance: return "M9.7 12a2.3 2.3 0 1 0 4.6 0a2.3 2.3 0 1 0 -4.6 0 M14.3 11C15.6 8.4 16.4 7 18 7H20 M14.3 13C15.6 15.6 16.4 17 18 17H20 M9.7 11C8.4 8.4 7.6 7 6 7H4 M9.7 13C8.4 15.6 7.6 17 6 17H4"
        // A broad-tipped pen over the band it lays down.
        case .seedHighlighter: return "M10.5 13.5L16.6 7.4a1.8 1.8 0 0 1 2.5 0l.5.5a1.8 1.8 0 0 1 0 2.5L13.5 16.5Z M10.5 13.5L8 17.5L9.5 19L13.5 16.5 M3.5 20.5H13"
        // A loop of rope with its loose end hanging down.
        case .seedLasso: return "M4 9.5a8 5 0 1 0 16 0a8 5 0 1 0 -16 0 M7.6 13.9C6.6 15.6 7.3 17.3 9 17.3C10.6 17.3 11 18.9 9.9 20.5"
        // A handwritten squiggle turning into a typed letter T.
        case .seedMakeTyped: return "M3.5 13C4.5 9.5 5.6 9.5 6.1 12S7.7 14.5 8.6 11 M10 12h3 M11.5 10.3L13.2 12L11.5 13.7 M14.5 6.5h6 M17.5 6.5V17.5"
        // A picture with a pencil at its corner.
        case .seedDrawOnIt: return "M11.5 15.5H5a1.5 1.5 0 0 1 -1.5-1.5V6A1.5 1.5 0 0 1 5 4.5h10A1.5 1.5 0 0 1 16.5 6v4 M3.5 13.2L7.2 9.5L10.7 13 M12.8 8h.01 M13 20.5l.6-2.6l5.6-5.6a1.4 1.4 0 0 1 2 2l-5.6 5.6Z"
        // A note with a vote dot (a ring with a dot) on its corner.
        case .seedVote: return "M15 9.5V5.5A1.5 1.5 0 0 0 13.5 4h-8A1.5 1.5 0 0 0 4 5.5v8A1.5 1.5 0 0 0 5.5 15h4 M13 16.5a3.5 3.5 0 1 0 7 0a3.5 3.5 0 1 0 -7 0 M16.5 16.5h.01"
        // Two ticked lines.
        case .seedTickList: return "M4 7.5l1.6 1.6l3.2-3.2 M11.5 7.5H20 M4 15.5l1.6 1.6l3.2-3.2 M11.5 15.5H20"
        // A small card: two colour dots, each with its words.
        case .seedLegend: return "M5 4.5h14a2 2 0 0 1 2 2v11a2 2 0 0 1 -2 2H5a2 2 0 0 1 -2-2v-11a2 2 0 0 1 2-2z M6 9a1.25 1.25 0 1 0 2.5 0a1.25 1.25 0 1 0 -2.5 0 M11 9h6 M6 15a1.25 1.25 0 1 0 2.5 0a1.25 1.25 0 1 0 -2.5 0 M11 15h4.5"
        // The corners of a frame round a ring with a dot.
        case .seedFocus: return "M4 8V5.5A1.5 1.5 0 0 1 5.5 4H8 M16 4H18.5A1.5 1.5 0 0 1 20 5.5V8 M20 16V18.5A1.5 1.5 0 0 1 18.5 20H16 M8 20H5.5A1.5 1.5 0 0 1 4 18.5V16 M9 12a3 3 0 1 0 6 0a3 3 0 1 0 -6 0 M12 12h.01"
        // The corners of a frame round a play triangle.
        case .seedShowFrames: return "M4 8V5.5A1.5 1.5 0 0 1 5.5 4H8 M16 4H18.5A1.5 1.5 0 0 1 20 5.5V8 M20 16V18.5A1.5 1.5 0 0 1 18.5 20H16 M8 20H5.5A1.5 1.5 0 0 1 4 18.5V16 M10 8.5l5.5 3.5l-5.5 3.5Z"
        // A board with a small map in its lower right corner.
        case .seedSmallMap: return "M5 4.5h14a2 2 0 0 1 2 2v11a2 2 0 0 1 -2 2H5a2 2 0 0 1 -2-2v-11a2 2 0 0 1 2-2z M11.5 11h6.5v5.5h-6.5Z"
        // A slanted ruler with three marks on its edge.
        case .seedRuler: return "M2.9 16.5L16.5 2.9L21.1 7.5L7.5 21.1Z M6.3 13.1l1.6 1.6 M9.7 9.7l2.5 2.5 M13.1 6.3l1.6 1.6"
        // A pencil line that breaks up into shorter strokes and dots: drawing shown lighter.
        case .seedFade: return "M3 14C4.5 9 6.5 9 8 12.5 M10.5 14.2l1.3.3 M14.2 13.6h1.2 M18 12.3h.01 M20.8 10.6h.01"
        // A scribble beside a note with two lines: handwriting read onto a note.
        case .seedReadThis: return "M3.5 9C4.5 5.5 5.6 5.5 6.1 8S7.7 10.5 8.6 7 M11 11.5h9.5v6l-3 3H11Z M13.5 14.5h4.5 M13.5 17.5h2.5"
        // A bell with its clapper: a reminder that keeps ringing.
        // A key on the slant: a round bow, a shaft and two teeth.
        case .stewardKey: return "M7 13.2a3.8 3.8 0 1 0 0 7.6a3.8 3.8 0 1 0 0-7.6Z M9.7 14.3L20.5 3.5 M17.5 6.5l2.5 2.5 M14.5 9.5l2 2"
        // A ship's wheel: a rim, a hub, eight spokes that run out as handles.
        case .stewardWheel: return "M12 6a6 6 0 1 0 0 12a6 6 0 1 0 0-12Z M12 10.2a1.8 1.8 0 1 0 0 3.6a1.8 1.8 0 1 0 0-3.6Z M12 2V10.2 M12 13.8V22 M2 12H10.2 M13.8 12H22 M13.3 10.7L18.4 5.6 M10.7 10.7L5.6 5.6 M13.3 13.3L18.4 18.4 M10.7 13.3L5.6 18.4"
        // A line that rises over a base line, and a small coin above it.
        case .stewardGrowth: return "M3.5 21H20.5 M3.5 17.5l4.5-5 3.5 3 3-3.5 M17.5 2.6a3.4 3.4 0 1 0 0 6.8a3.4 3.4 0 1 0 0-6.8Z"
        // A three-blade fan around a small hub: AMS Fan Menu (24 Nov 2026).
        case .fan: return "M11.14 10.27C9.89 7.58 7.58 5.66 8.54 3.36C9.5 1.82 14.5 2.02 16.42 4.7C17.18 6.05 15.07 8.54 13.63 10.94 M13.93 12.12C16.88 12.38 19.7 11.34 21.21 13.32C22.07 14.92 19.39 19.16 16.11 19.48C14.56 19.46 13.46 16.39 12.1 13.94 M10.93 13.61C9.23 16.04 8.72 19 6.25 19.32C4.43 19.26 2.11 14.82 3.47 11.82C4.26 10.49 7.47 11.07 10.27 11.12 M10 12a2 2 0 1 0 4 0a2 2 0 1 0-4 0Z"
        case .people: return "M10 6a3 3 0 1 0 0 6a3 3 0 1 0 0-6Z M4 20c0-3.6 2.7-6 6-6s6 2.4 6 6 M15.2 5.3a2.6 2.6 0 1 1 1.3 4.9 M17.8 14.2c2.2.6 3.7 2.7 3.7 5.8"
        case .bell: return "M12 3.2v1.8 M6 16.5V11a6 6 0 0 1 12 0v5.5l1.5 2h-15Z M10 20.5a2 2 0 0 0 4 0"
        // AMS Triathlon Training: the drawings as the app had them. Back, tick, counts and plus are drawn at stroke 2.1 in the app (it passes lineWidth: 2.1).
        case .triBack: return "M14.8 4.6c-2.5 2.4-4.9 4.9-7.2 7.5 2.3 2.6 4.7 5.1 7.2 7.4"
        case .triBike: return "M2.4 17.1c0-2.2 1.7-3.9 3.9-3.9 2.1 0 3.8 1.7 3.8 3.9 0 2.1-1.7 3.8-3.8 3.8-2.2 0-3.9-1.7-3.9-3.8Z M14 17.1c0-2.2 1.7-3.9 3.8-3.9 2.2 0 3.9 1.7 3.9 3.9 0 2.1-1.7 3.8-3.9 3.8-2.1 0-3.8-1.7-3.8-3.8Z M6.3 17.1c1.9-2.6 3.8-5 5.9-7.3 1.9 2.4 3.8 4.8 5.6 7.3 M9.1 9.6c2 .2 4 .2 6 0 M14.9 5.3c.9-.1 1.8-.1 2.7 0 M16 5.4c.6 1.5 1.2 2.9 1.9 4.3"
        // Body: a heart with a heartbeat line across it (the app's Body page).
        case .triBody: return "M12 20.2C12 20.2 3.6 15.4 3.6 9.6 3.6 6.9 5.7 4.8 8.2 4.8 9.8 4.8 11.2 5.6 12 6.9 12.8 5.6 14.2 4.8 15.8 4.8 18.3 4.8 20.4 6.9 20.4 9.6 20.4 15.4 12 20.2 12 20.2Z M8.2 12.2H9.8L10.9 9.8 13.1 14.4 14.2 12.2H15.8"
        case .triBreathing: return "M11.2 7.1c-.1 3.1-.2 6.2-.1 9.3-1.8 2.1-4.6 2.9-6.7 1.9-.9-3.3-.6-6.9 1.2-9.9 1.5-2.1 3.9-2.4 5.6-1.3Z M12.8 7.1c.1 3.1.2 6.2.1 9.3 1.8 2.1 4.6 2.9 6.7 1.9.9-3.3.6-6.9-1.2-9.9-1.5-2.1-3.9-2.4-5.6-1.3Z M12 3.3c0 1.9 0 3.8-.1 5.6"
        case .triCamera: return "M3.6 8.3c2.1-.2 4.1-.2 6.2-.3l1.5-2.4c1.4-.1 2.8-.1 4.2 0l1.4 2.4c1.2 0 2.3.1 3.5.2.2 3.6.2 7.2 0 10.8-5.6.3-11.2.3-16.8 0-.2-3.6-.2-7.1 0-10.7Z M12.1 10.1c1.8 0 3.1 1.4 3.1 3.1s-1.4 3.2-3.1 3.2-3.2-1.4-3.2-3.2 1.4-3.1 3.2-3.1Z"
        case .triCheck: return "M4.7 12.5c1.6 1.6 3 3.2 4.3 5 3.4-5.6 7.4-10.6 11.4-15"
        case .triClock: return "M3.6 12c0-4.7 3.8-8.5 8.5-8.5 4.6 0 8.4 3.8 8.4 8.5 0 4.6-3.8 8.4-8.4 8.4-4.7 0-8.5-3.8-8.5-8.4Z M12 7.2c-.1 1.7-.1 3.3 0 4.9 1.3.6 2.5 1.3 3.7 2.1"
        case .triCloud: return "M6.6 18.8c-2.3.1-4-1.5-4.1-3.6-.1-1.9 1.3-3.6 3.2-3.9.2-3.1 2.6-5.4 5.7-5.4 2.8 0 5.1 1.9 5.6 4.6 2.4.1 4.3 2 4.3 4.2 0 2.3-1.9 4.1-4.4 4.1-3.4.1-6.9.1-10.3 0Z"
        case .triCounts: return "M3.4 12.6 3.4 17.4 M9.1 12.6 9.1 17.4 M14.8 12.6 14.8 17.4 M20.5 8.4 20.5 17.4"
        case .triHeart: return "M12.1 20.3c-3.4-2.6-6.3-5.1-8-7.9-1.6-2.7-1-6 1.6-7.4 2.1-1.1 4.6-.4 6.3 1.6 1.8-2 4.3-2.7 6.4-1.5 2.5 1.4 3.1 4.7 1.4 7.4-1.7 2.8-4.5 5.3-7.7 7.8Z"
        case .triHike: return "M12.8 4.3c.05-1.15.9-2 2.05-2 1.1 0 1.95.85 1.95 2 0 1.15-.85 2.05-1.95 2-1.15-.05-2.05-.9-2.05-2Z M14 6.3 11.4 13.3 M13.3 8.2 16.8 11 M11.4 13.3 7.7 20.7 M11.4 13.3 15 20.7 M12.6 6.9 8.6 6.9 7 13.1 10.9 13.1 M4.3 6.4 4.3 20.7"
        case .triMeditation: return "M12 4.4c1.9 2.2 2.6 4.8 2.1 7.4-.4 2-1.1 3.4-2.1 4.6-1-1.2-1.7-2.6-2.1-4.6-.5-2.6.2-5.2 2.1-7.4Z M9.6 16.2c-2.6-.2-4.7-1.6-5.9-4 1.9-.9 4-1 5.9-.1M14.4 16.2c2.6-.2 4.7-1.6 5.9-4-1.9-.9-4-1-5.9-.1 M5.2 19.4c4.5-.2 9.1-.2 13.6 0"
        case .triMic: return "M9.4 4.6c0-1.5 1.2-2.7 2.7-2.7 1.4 0 2.6 1.2 2.6 2.7 0 2.4.1 4.7 0 7.1 0 1.4-1.2 2.6-2.6 2.6-1.5 0-2.7-1.2-2.7-2.6-.1-2.4-.1-4.7 0-7.1Z M5.6 10.9c-.1 3.4 2.7 6.3 6.4 6.3 3.6 0 6.5-2.9 6.4-6.3 M12 17.4c0 1.6 0 3.1-.1 4.6 M8.8 22.1c2.1-.2 4.2-.2 6.3 0"
        case .triMobility: return "M10.1 3.6c.05-1.15.9-2 2.05-2 1.1 0 1.95.85 1.95 2 0 1.15-.85 2.05-1.95 2-1.15-.05-2.05-.9-2.05-2Z M12.1 7c-.1 2.5-.1 4.9 0 7.3 M6.6 9.3c1.9.8 3.7 1.3 5.6 1.4 1.9-.1 3.6-.6 5.4-1.4 M12.1 14.2c-1.3 2.4-2.8 4.6-4.6 6.6 M12.1 14.2c1.4 2.3 2.9 4.5 4.7 6.5"
        case .triOther: return "M3.6 12c0-4.7 3.8-8.5 8.5-8.5 4.6 0 8.4 3.8 8.4 8.5 0 4.6-3.8 8.4-8.4 8.4-4.7 0-8.5-3.8-8.5-8.4Z M9.4 9.6c.2-1.4 1.3-2.3 2.7-2.3 1.5 0 2.6 1 2.6 2.4 0 1.8-2.5 2-2.6 4 M12.1 16.6h.01"
        case .triPen: return "M7.3 16.8c2.9-3 5.8-5.9 8.8-8.8.6-.6 1.5-.6 2.1 0l.8.8c.6.6.6 1.5 0 2.1-2.9 3-5.8 5.9-8.8 8.8-1.3.4-2.7.8-4 1.1.3-1.4.7-2.7 1.1-4Z M15 9.2c1 1 2 2 3 2.9"
        case .triPlan: return "M4.7 4.6c-.3 5-.2 10 0 14.9 5 .3 9.8.2 14.7 0 .3-5 .2-10 0-14.9-4.9-.3-9.8-.3-14.7 0Z M7.6 8.9h.01M7.6 12.4h.01M7.6 15.8h.01 M10.4 8.8c1.9-.2 3.7-.1 5.5.1 M10.4 12.3c1.9-.2 3.7-.1 5.5.1 M10.4 15.7c1.2-.2 2.4-.1 3.6.1"
        case .triPlus: return "M12 5.5v13M5.5 12h13"
        case .triProgress: return "M5 20V13 M12 20V9 M19 20V5"
        case .triRace: return "M5.5 21.1c-.3-6-.3-12-.1-18 M5.7 4.4c4-.9 8-.7 12 .3-.2 2.5-.2 4.9 0 7.4-4-1-8-1.2-12-.3 M11.5 4.5c.2 2.5.2 4.9 0 7.4 M5.8 8c4-.9 8-.7 11.9.3"
        case .triRowing: return "M2 8.4a3.2 3.2 0 1 0 6.4 0a3.2 3.2 0 1 0 -6.4 0Z M7.9 10.9c4.4 2.2 8.8 4.5 13.1 6.8 M12.4 13c.9.5 1.8.9 2.7 1.4 M4.6 11.6c-.5 2.7-1 5.4-1.4 8.1 M6.6 5.7c.7-1.2 1.6-2.2 2.7-3 M9.1 1.6c1 .5 1.9 1.1 2.7 1.9 M2.2 20.2c6.5-.2 13-.2 19.5 0"
        case .triRun: return "M13.2 4.3c.05-1.15.9-2 2.05-2 1.1 0 1.95.85 1.95 2 0 1.15-.85 2.05-1.95 2-1.15-.05-2.05-.9-2.05-2Z M8.6 21.4c.9-2.2 1.9-4.2 3.1-6.2-1.1-1.2-2.1-2.4-3-3.7 M8.7 11.5c-.2 1.4-.6 2.6-1.2 3.8 M8.7 11.4c1.6-1.6 3.3-2.9 5.2-4 1 1.2 1.7 2.5 2.2 3.9 1.2.5 2.4.9 3.7 1.2 M11.7 15.2c1.4.7 2.5 1.7 3.4 3 .5 1.1.9 2.1 1.2 3.2 M4.3 9.9c1.4-.2 2.8-.2 4.2-.1"
        case .triSettings: return "M4.2 7.3c.9-.1 1.8-.2 2.7-.2M11.5 7.1c2.8-.1 5.5 0 8.3.2 M7.05 7.2C7 6 7.95 5.05 9.2 5.05c1.3 0 2.15.95 2.15 2.15 0 1.3-.95 2.2-2.15 2.15C7.9 9.3 7.05 8.4 7.05 7.2Z M4.2 12.1c2.7-.2 5.4-.2 8.5-.2M17.3 11.9c.9 0 1.8.1 2.7.2 M12.85 12c-.05-1.25.9-2.15 2.15-2.15 1.3 0 2.15.95 2.15 2.15 0 1.3-.95 2.2-2.15 2.15-1.3-.05-2.15-.95-2.15-2.15Z M4.2 16.9c.5-.1 1-.1 1.5-.1M10.5 16.7c3.1-.1 6.2 0 9.3.2 M6.05 16.8C6 15.55 6.95 14.65 8.2 14.65c1.3 0 2.15.95 2.15 2.15 0 1.3-.95 2.2-2.15 2.15-1.3-.05-2.15-.95-2.15-2.15Z"
        case .triShare: return "M12 3.4c0 4.3 0 8.5.1 12.7 M8.3 7c1.2-1.3 2.5-2.5 3.8-3.6 1.3 1.1 2.6 2.3 3.7 3.6 M7.6 11H5.5c-.3 3.1-.3 6.2 0 9.3 4.4.3 8.7.3 13 0 .3-3.1.3-6.2 0-9.3h-2.1"
        case .triSki: return "M11.2 4.1c.05-1.15.9-2 2.05-2 1.1 0 1.95.85 1.95 2 0 1.15-.85 2.05-1.95 2-1.15-.05-2.05-.9-2.05-2Z M13 6.1 12.4 13.2 M12.7 8.1 16.4 10.4 M12.7 8.1 9 10.4 M12.4 13.2 10.6 19 M12.4 13.2 14.4 19 M16.6 10.6 17.6 19.4 M9.2 10.6 8.2 19.4 M5.8 19.8 19.2 19.8"
        case .triStrength: return "M2.6 9.6c.1 1.7.1 3.3 0 5 M5.3 7.3c.2 3.1.2 6.2 0 9.4 M18.7 7.2c.2 3.2.2 6.4 0 9.5 M21.4 9.5c.1 1.7.1 3.4 0 5.1 M5.4 12c4.4-.3 8.8-.3 13.2 0"
        case .triStretch: return "M7.6 3.9c.05-1.15.9-2 2.05-2 1.1 0 1.95.85 1.95 2 0 1.15-.85 2.05-1.95 2-1.15-.05-2.05-.9-2.05-2Z M9.6 7.3c-.4 2.3-.5 4.5-.4 6.8 M9.2 14.1c2.8-.4 5.6-.5 8.4-.3 M9.4 9.5c2.2.6 4.3 1.5 6.3 2.7 M4.2 20.6c1.7-2.3 3.4-4.5 5.2-6.6"
        case .triSwim: return "M2.6 17.4c1.6-1.3 3-1.3 4.6 0 1.6 1.3 3 1.3 4.6 0 1.6-1.3 3-1.3 4.6 0 1.5 1.3 3 1.3 4.5 0 M2.6 21c1.6-1.3 3-1.3 4.6 0 1.6 1.3 3 1.3 4.6 0 1.6-1.3 3-1.3 4.6 0 1.5 1.3 3 1.3 4.5 0 M7.4 13.6c1.9-1.7 3.9-3.3 6.1-4.7 M10.9 11.1c1.6.4 3.1 1 4.6 1.8 M16.8 6.4c.05-1.05.85-1.85 1.9-1.85 1.05 0 1.85.8 1.85 1.85 0 1.1-.8 1.9-1.85 1.85-1.05-.05-1.9-.85-1.9-1.85Z"
        case .triSync: return "M20.4 12.3c-.2 4.4-3.9 7.8-8.4 7.6-3.5-.1-6.5-2.5-7.5-5.8 M3.6 11.6c.3-4.4 4-7.7 8.4-7.5 3.5.2 6.4 2.6 7.4 5.9 M19.6 5.4c-.1 1.5-.1 3-.1 4.6-1.6.1-3.1.1-4.7 0 M4.4 18.6c.1-1.6.1-3.1.1-4.7 1.6-.1 3.1-.1 4.7 0"
        case .triToday: return "M4.4 5.6c5.1-.3 10.2-.2 15.3 0 .3 4.7.2 9.3 0 13.9-5.1.3-10.2.2-15.3 0-.3-4.6-.2-9.2 0-13.9Z M4.6 9.7c5-.2 10-.2 15 0 M8.4 3.5c0 1.2 0 2.4-.1 3.5M15.7 3.4c.1 1.2.1 2.4 0 3.6 M9.3 14.4c1 1 1.8 2 2.5 3.1 1.4-2.4 2.9-4.5 4.6-6.4"
        case .triWalk: return "M13.1 4.3c.05-1.15.9-2 2.05-2 1.1 0 1.95.85 1.95 2 0 1.15-.85 2.05-1.95 2-1.15-.05-2.05-.9-2.05-2Z M14.3 6.3 10.4 13.4 M13.2 8.3 17.6 9.9 M13.2 8.3 9.6 9.6 M10.4 13.4 6.2 20.6 M10.4 13.4 13.4 20.6 M13.4 20.6 17.2 20.6"
        case .triYoga: return "M10.1 5.2c.05-1.15.9-2 2.05-2 1.1 0 1.95.85 1.95 2 0 1.15-.85 2.05-1.95 2-1.15-.05-2.05-.9-2.05-2Z M12.1 7.2 12.1 14.6 M12.1 8.8 6.6 17.4 M12.1 8.8 17.6 17.4 M12.1 14.6 5.6 18.6 11 20.4 M12.1 14.6 18.6 18.6 13.2 20.4"
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
