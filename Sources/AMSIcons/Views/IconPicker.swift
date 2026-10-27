import SwiftUI
#if os(macOS)
import AppKit
#else
import UIKit
#endif

/// Choose an icon and its colour: the Packing app's picker, for every AMS app.
///
/// From the top:
/// - the chosen icon on its colour, the name of what it is for, and **Cancel**;
/// - **Colour**: Automatic and the fifteen palette colours in two rows of eight, each a small
///   tile in that colour with the chosen icon on it and the colour's name under it, the chosen
///   one ringed;
/// - **Icon**: a **Find an icon** field, a **No icon** choice, then the icons under their
///   headings, the hand-drawn ones first ("Hand-drawn · Travel" …), then Apple's ("Apple
///   symbols · Work and projects" …), each a rounded card with the icon and its label, the
///   chosen one filled with the colour.
///
/// Every press ends the picker, as in the Packing app: a colour calls `onColour`, an icon or
/// **No icon** calls `onPick` (nil for No icon), **Cancel** (and Escape) calls `onCancel`, and
/// then the picker closes itself with the environment's `dismiss`. A caller that presents it
/// with `.sheet(item:)` and clears the item in a callback is fine too: the second close does
/// nothing.
///
/// An Apple symbol this device's system cannot draw is left out of the grid. A search that
/// finds nothing says so where the icons were.
///
/// Accessibility identifiers, for screen tests: `icon.picker` (the whole), `icon.cancel`,
/// `icon.colour.auto`, `icon.colour.<key>`, `icon.search`, `icon.search.clear`,
/// `icon.search.none`, `icon.none`, `icon.choice.<stored>` (`icon.choice.hand:bike`,
/// `icon.choice.symbol:book`). The chosen colour and the chosen icon carry `.isSelected`.
public struct IconPicker: View {
    private let title: String
    private let chosen: IconChoice?
    private let colour: IconColour?
    private let fallbackTint: Color
    private let onPick: (IconChoice?) -> Void
    private let onColour: (IconColour?) -> Void
    private let onCancel: (() -> Void)?

    @Environment(\.dismiss) private var dismiss
    /// What is typed in **Find an icon**.
    @State private var query = ""
    @FocusState private var finding: Bool

    /// - Parameters:
    ///   - title: What the icon is for ("Garden", "Triathlon"). Shown at the top; its first
    ///     letter is what a tile shows with no icon.
    ///   - chosen: The icon chosen now, or nil for none.
    ///   - colour: The colour chosen now, or nil for Automatic.
    ///   - fallbackTint: What Automatic looks like: the app's own colour for this kind of thing.
    ///   - onPick: Called with the icon pressed, or nil for **No icon**.
    ///   - onColour: Called with the colour pressed, or nil for **Automatic**.
    ///   - onCancel: Called when **Cancel** or Escape is pressed.
    public init(title: String, chosen: IconChoice?, colour: IconColour?, fallbackTint: Color,
                onPick: @escaping (IconChoice?) -> Void,
                onColour: @escaping (IconColour?) -> Void,
                onCancel: (() -> Void)? = nil) {
        self.title = title
        self.chosen = chosen
        self.colour = colour
        self.fallbackTint = fallbackTint
        self.onPick = onPick
        self.onColour = onColour
        self.onCancel = onCancel
    }

    public var body: some View {
        let sections = IconLibrary.search(query, keeping: IconLibrary.canDraw)
        VStack(spacing: 0) {
            header
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    PickerHeading(text: "Colour", id: "icon.heading.colour")
                    ColourSwatches(chosen: chosen, colour: colour, fallbackTint: fallbackTint, letter: title) { picked in
                        pickColour(picked)
                    }
                    PickerHeading(text: "Icon", id: "icon.heading.icon")
                    searchField
                    // No icon is not an icon: it steps aside while a search is on.
                    if !searching {
                        TileGrid(minimum: PickerLook.cardMinimum, spacing: PickerLook.gap) {
                            noIconCard
                        }
                        .focusEffectDisabled()
                    }
                    if sections.isEmpty {
                        Text("No icon matches what you typed.")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.top, 8)
                            .accessibilityIdentifier("icon.search.none")
                    }
                    ForEach(sections) { section in
                        PickerHeading(text: section.title, id: "icon.section.\(section.id)")
                        TileGrid(minimum: PickerLook.cardMinimum, spacing: PickerLook.gap) {
                            ForEach(section.refs) { ref in
                                iconCard(ref)
                            }
                        }
                        .focusEffectDisabled()
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
            .scrollDismissesKeyboard(.immediately)
        }
        .background(PickerLook.page)
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("icon.picker")
        .modifier(MacPickerSize())
    }

    // MARK: - The parts

    private var header: some View {
        HStack(spacing: 12) {
            IconTile(chosen, colour: colour, fallbackTint: fallbackTint, letter: title, size: 40)
            Text(shownTitle)
                .font(.system(.title3, weight: .bold))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            Spacer(minLength: 4)
            Button {
                cancel()
            } label: {
                Text("Cancel")
            }
            .buttonStyle(OutlinedCapsuleButtonStyle())
            .focusEffectDisabled()
            .keyboardShortcut(.cancelAction)
            .accessibilityIdentifier("icon.cancel")
        }
        .padding(16)
    }

    /// The search field, with a clear button while something is typed. No autocorrection and
    /// no capitals: "cykel" typed on an English keyboard must stay as it was typed. On the Mac
    /// Command-F puts the cursor in it, and Escape empties it first, then closes the picker.
    private var searchField: some View {
        HStack(spacing: 4) {
            TextField("Find an icon", text: $query)
                .textFieldStyle(.plain)
                .font(.body)
                .focused($finding)
                .autocorrectionDisabled()
                .modifier(PhoneSearchKeyboard())
                .modifier(MacSearchKeys(query: $query, finding: $finding, cancel: { cancel() }))
                .accessibilityIdentifier("icon.search")
            if !query.isEmpty {
                Button {
                    query = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                        .frame(width: 28, height: 28)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .focusEffectDisabled()
                .accessibilityLabel(Text("Clear the search"))
                .accessibilityIdentifier("icon.search.clear")
            }
        }
        .padding(.horizontal, 12)
        .frame(minHeight: PickerLook.fieldHeight)
        .background(RoundedRectangle(cornerRadius: 10).fill(PickerLook.card))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(PickerLook.line, lineWidth: 1))
    }

    private var noIconCard: some View {
        ChoiceCard(
            title: "No icon",
            isOn: chosen == nil,
            id: "icon.none",
            tint: tint,
            ink: ink,
            mark: NoIconMark(letter: TileLetter.of(title)),
            choose: { pick(nil) }
        )
    }

    private func iconCard(_ ref: IconChoice) -> some View {
        ChoiceCard(
            title: IconLibrary.label(for: ref) ?? ref.name,
            isOn: chosen == ref,
            id: "icon.choice.\(ref.stored)",
            tint: tint,
            ink: ink,
            mark: IconMark(ref, size: 30),
            choose: { pick(ref) }
        )
    }

    // MARK: - What it shows

    private var shownTitle: String {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? "Choose an icon" : trimmed
    }

    /// The chosen card's fill: the chosen colour, or the app's own for Automatic.
    private var tint: Color {
        IconColour.fill(for: colour, automatic: fallbackTint)
    }

    /// The icon and the label on that fill.
    private var ink: Color {
        IconColour.markInk(for: colour)
    }

    /// Words typed. Spaces and commas alone are no search.
    private var searching: Bool {
        query.contains { !$0.isWhitespace && $0 != "," }
    }

    // MARK: - What a press does

    private func pick(_ ref: IconChoice?) {
        onPick(ref)
        dismiss()
    }

    private func pickColour(_ picked: IconColour?) {
        onColour(picked)
        dismiss()
    }

    private func cancel() {
        onCancel?()
        dismiss()
    }
}

// MARK: - Colour

/// Automatic and the palette in `IconColour.pickerRows`: two plain rows of eight. Each swatch is
/// the chosen icon on a small tile in that colour, with the colour's name under it; the chosen
/// one is ringed. The swatches stand edge to edge, so each one's whole share of the row takes the
/// press (46 points on a 402-point iPhone).
private struct ColourSwatches: View {
    let chosen: IconChoice?
    let colour: IconColour?
    let fallbackTint: Color
    let letter: String
    let pick: (IconColour?) -> Void

    /// The small tile's size.
    private var size: CGFloat { 32 }

    var body: some View {
        let rows = IconColour.pickerRows
        let columns = IconColour.pickerColumnCount
        VStack(alignment: .leading, spacing: 6) {
            ForEach(rows.indices, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(rows[row].indices, id: \.self) { place in
                        swatch(rows[row][place])
                    }
                    // A short last row keeps every swatch the width of the others.
                    ForEach(0..<max(0, columns - rows[row].count), id: \.self) { _ in
                        Color.clear.frame(maxWidth: .infinity, minHeight: 60)
                    }
                }
            }
        }
    }

    private func swatch(_ shown: IconColour?) -> some View {
        let isOn = shown?.key == colour?.key
        let name = shown?.name ?? IconColour.automaticName
        let key = shown?.key ?? IconColour.automaticKey
        return Button {
            pick(shown)
        } label: {
            VStack(spacing: 4) {
                IconTile(chosen, colour: shown, fallbackTint: fallbackTint, letter: letter, size: size)
                    .padding(3)
                    .overlay(
                        RoundedRectangle(cornerRadius: size * 0.28 + 3)
                            .stroke(isOn ? Color.primary : Color.clear, lineWidth: 2)
                    )
                Text(name)
                    .font(.system(.caption2, weight: isOn ? .bold : .regular))
                    .foregroundStyle(isOn ? Color.primary : Color.secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .padding(.horizontal, 1)
            }
            .frame(maxWidth: .infinity, minHeight: 60)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .focusEffectDisabled()
        .accessibilityLabel(Text(name))
        .accessibilityIdentifier("icon.colour.\(key)")
        .accessibilityAddTraits(isOn ? .isSelected : [])
    }
}

// MARK: - Icons

/// One choice in the grid: a rounded card with the icon and its label under it. The chosen one
/// is filled with the colour, its icon and label in the colour's ink.
private struct ChoiceCard<Mark: View>: View {
    let title: String
    let isOn: Bool
    let id: String
    let tint: Color
    let ink: Color
    let mark: Mark
    let choose: () -> Void

    var body: some View {
        Button(action: choose) {
            VStack(spacing: 6) {
                mark
                    .foregroundStyle(isOn ? ink : Color.primary)
                    .frame(height: 32)
                Text(title)
                    .font(.system(.caption, weight: .semibold))
                    .foregroundStyle(isOn ? ink : Color.secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .padding(.horizontal, 4)
            }
            .frame(maxWidth: .infinity, minHeight: 74)
            .background(RoundedRectangle(cornerRadius: 12).fill(isOn ? tint : PickerLook.card))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isOn ? tint : PickerLook.line, lineWidth: isOn ? 2 : 1)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .focusEffectDisabled()
        .accessibilityLabel(Text(title))
        .accessibilityIdentifier(id)
        .accessibilityAddTraits(isOn ? .isSelected : [])
    }
}

/// What the **No icon** card shows: the letter a tile shows with no icon, else the dashed circle.
private struct NoIconMark: View {
    let letter: String?

    var body: some View {
        if let letter {
            Text(letter)
                .font(.system(.title3, weight: .bold))
        } else {
            IconMark(nil, size: 30)
        }
    }
}

/// A heading of the picker: Colour, Icon, and one per group of icons.
private struct PickerHeading: View {
    let text: String
    let id: String

    var body: some View {
        Text(text)
            .font(.headline)
            .foregroundStyle(.primary)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.top, 12)
            .accessibilityAddTraits(.isHeader)
            .accessibilityIdentifier(id)
    }
}

/// Equal cells, as many to a row as fit with each at least `minimum` wide: about three on an
/// iPhone, four or more on a Mac sheet. Every cell is built at once, never lazily, so a screen test
/// on the Mac finds a card that is not yet scrolled into view (the Packing app's lesson).
struct TileGrid: Layout {
    var minimum: CGFloat = 92
    var spacing: CGFloat = 10

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = usableWidth(proposal.width)
        let measure = measured(Array(subviews), width: width)
        return CGSize(width: width, height: measure.height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let cells = Array(subviews)
        let measure = measured(cells, width: bounds.width)
        var rowTops: [CGFloat] = []
        var top = bounds.minY
        for height in measure.rowHeights {
            rowTops.append(top)
            top += height + spacing
        }
        for index in cells.indices {
            let row = index / measure.columns
            let column = index % measure.columns
            guard row < rowTops.count else { continue }
            let x = bounds.minX + CGFloat(column) * (measure.cell + spacing)
            cells[index].place(
                at: CGPoint(x: x, y: rowTops[row]),
                anchor: .topLeading,
                proposal: ProposedViewSize(width: measure.cell, height: measure.rowHeights[row])
            )
        }
    }

    private struct Measure {
        var columns: Int
        var cell: CGFloat
        var rowHeights: [CGFloat]
        var height: CGFloat
    }

    /// A width to lay out in: the one offered, or four cells' worth when none is.
    private func usableWidth(_ offered: CGFloat?) -> CGFloat {
        guard let offered, offered.isFinite, offered >= 0 else {
            return minimum * 4 + spacing * 3
        }
        return offered
    }

    private func measured(_ cells: [LayoutSubview], width: CGFloat) -> Measure {
        let fit = Int(((width + spacing) / (minimum + spacing)).rounded(.down))
        let columns = max(1, fit)
        let cell = max(0, (width - spacing * CGFloat(columns - 1)) / CGFloat(columns))
        var rowHeights: [CGFloat] = []
        var start = 0
        while start < cells.count {
            let end = min(start + columns, cells.count)
            var tallest: CGFloat = 0
            for index in start..<end {
                let size = cells[index].sizeThatFits(ProposedViewSize(width: cell, height: nil))
                tallest = max(tallest, size.height)
            }
            rowHeights.append(tallest)
            start = end
        }
        let height = rowHeights.reduce(0, +) + spacing * CGFloat(max(rowHeights.count - 1, 0))
        return Measure(columns: columns, cell: cell, rowHeights: rowHeights, height: height)
    }
}

// MARK: - Look

/// The picker's colours and sizes: the system's own, so it sits in any AMS app, light and dark.
enum PickerLook {
    static var page: Color {
        #if os(macOS)
        return Color(nsColor: .windowBackgroundColor)
        #else
        return Color(uiColor: .systemGroupedBackground)
        #endif
    }

    static var card: Color {
        #if os(macOS)
        return Color(nsColor: .controlBackgroundColor)
        #else
        return Color(uiColor: .secondarySystemGroupedBackground)
        #endif
    }

    static var line: Color {
        Color.primary.opacity(0.12)
    }

    /// The narrowest a card may be: three to a row on an iPhone (375 points or more), four on the
    /// Mac's smallest sheet, as many more as a wider one holds. At this width a long label such as
    /// "Cross-country skiing" still fits on one line.
    static var cardMinimum: CGFloat { 92 }

    /// Between cards.
    static var gap: CGFloat { 10 }

    /// The search field's height: Apple's compact size, smaller again on the Mac.
    static var fieldHeight: CGFloat {
        #if os(macOS)
        return 24
        #else
        return 32
        #endif
    }

    /// **Cancel**'s height.
    static var headerButtonHeight: CGFloat {
        #if os(macOS)
        return 24
        #else
        return 30
        #endif
    }
}

/// **Cancel**: an outlined capsule in grey, as the Packing app draws it.
private struct OutlinedCapsuleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(.body, weight: .semibold))
            .foregroundStyle(Color.secondary)
            .lineLimit(1)
            .fixedSize()
            .padding(.horizontal, 12)
            .frame(minHeight: PickerLook.headerButtonHeight)
            .background(Capsule().fill(Color.secondary.opacity(0.10)))
            .overlay(Capsule().stroke(Color.secondary, lineWidth: 1.4))
            .contentShape(Capsule())
            .opacity(configuration.isPressed ? 0.7 : 1)
    }
}

/// The iPhone's keyboard for a search: no capitals, and a Search key.
private struct PhoneSearchKeyboard: ViewModifier {
    @ViewBuilder
    func body(content: Content) -> some View {
        #if os(iOS)
        content
            .textInputAutocapitalization(.never)
            .submitLabel(.search)
        #else
        content
        #endif
    }
}

/// The Mac's keys for the search field: Escape empties it, and on an empty field closes the
/// picker as **Cancel** does (a text field keeps Escape for itself); Command-F puts the cursor
/// in it.
private struct MacSearchKeys: ViewModifier {
    let query: Binding<String>
    let finding: FocusState<Bool>.Binding
    let cancel: () -> Void

    @ViewBuilder
    func body(content: Content) -> some View {
        #if os(macOS)
        content
            .onExitCommand {
                if query.wrappedValue.isEmpty {
                    cancel()
                } else {
                    query.wrappedValue = ""
                }
            }
            .background {
                Button("Find an icon") {
                    finding.wrappedValue = true
                }
                .keyboardShortcut("f", modifiers: .command)
                .opacity(0)
                .accessibilityHidden(true)
            }
        #else
        content
        #endif
    }
}

/// The Mac's sheet is as large as the Packing app's, so two rows of eight swatches and four
/// cards to a row fit without scrolling sideways.
private struct MacPickerSize: ViewModifier {
    @ViewBuilder
    func body(content: Content) -> some View {
        #if os(macOS)
        content.frame(minWidth: 520, minHeight: 620)
        #else
        content
        #endif
    }
}
