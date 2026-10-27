import Foundation

/// One of the hand-drawn icons, first drawn for the AMS Packing app.
///
/// Every drawing is one 1.9-point stroke on a 24-point box, with round caps and joins and no
/// fill, using only the path commands M L H V C S Q A Z (`SVGPath`). `key` is what is stored
/// (as `hand:<key>`, see `IconChoice`) and never changes; `label` is what the picker writes under
/// the icon and may change.
public struct HandIcon: Identifiable, Hashable, Sendable {
    public let key: String
    public let label: String
    public let group: HandIconGroup
    /// SVG path data on a 24-point box.
    public let path: String

    public init(key: String, label: String, group: HandIconGroup, path: String) {
        self.key = key
        self.label = label
        self.group = group
        self.path = path
    }

    public var id: String { key }

    /// What to store for this icon.
    public var ref: IconChoice { .hand(key) }
}

/// The headings the hand-drawn icons sit under, in the order the picker shows them. The same
/// headings and titles as the Packing app.
public enum HandIconGroup: String, CaseIterable, Sendable {
    case travel, outdoors, sport, beach, city, everyday

    public var title: String {
        switch self {
        case .travel: return "Travel"
        case .outdoors: return "Outdoors"
        case .sport: return "Sport"
        case .beach: return "Beach and summer"
        case .city: return "City, food and fun"
        case .everyday: return "Everyday"
        }
    }
}
