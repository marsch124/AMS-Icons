import Foundation

/// One of the chosen SF Symbols, Apple's own icons.
///
/// Only the symbol's name is stored (as `symbol:<name>`, see `IconRef`); the system draws it.
/// Apple's symbols may be used only in apps for Apple's own platforms. `words` are hidden words
/// the search finds it by (English, and the Swedish he might type); they are never shown.
public struct SymbolIcon: Identifiable, Hashable, Sendable {
    /// The SF Symbol's system name, as `Image(systemName:)` takes it.
    public let name: String
    /// What the picker writes under the icon: one to three plain English words.
    public let label: String
    public let group: SymbolGroup
    /// Other words it is found by: English, and Swedish. Never shown.
    public let words: [String]

    public init(name: String, label: String, group: SymbolGroup, words: [String]) {
        self.name = name
        self.label = label
        self.group = group
        self.words = words
    }

    public var id: String { name }

    /// What to store for this icon.
    public var ref: IconRef { .symbol(name) }
}

/// The headings Apple's symbols sit under, in the order the picker shows them.
public enum SymbolGroup: String, CaseIterable, Sendable {
    case work, time, learning, writing, health, sport, mind, home
    case people, money, travel, nature, food, creative, tech, tools

    public var title: String {
        switch self {
        case .work: return "Work and projects"
        case .time: return "Time and planning"
        case .learning: return "Learning and reading"
        case .writing: return "Writing and notes"
        case .health: return "Health and body"
        case .sport: return "Sport and training"
        case .mind: return "Mind and calm"
        case .home: return "Home and family"
        case .people: return "People and community"
        case .money: return "Money and finance"
        case .travel: return "Travel and transport"
        case .nature: return "Nature, garden and weather"
        case .food: return "Food and drink"
        case .creative: return "Creative and music"
        case .tech: return "Technology and AI"
        case .tools: return "Tools and making"
        }
    }
}
