# AMS-Icons

The icons that every AMS app shares, in one Swift package.

It holds two kinds of icon, one way to store a choice, one search, one set of colours, and three
SwiftUI views: one that draws an icon, one that draws it on a coloured tile, and one that lets a
person choose.

- **Hand-drawn icons.** 132 line drawings, first made for the AMS Packing app. Bike, Tent, Plane,
  Coffee, and so on. They are stored in this package as path data, so they look the same on
  every device.
- **Apple symbols.** About 300 chosen SF Symbols, for the things the hand-drawn set does not
  cover: work, learning, health, money, the garden, technology. Only their names are stored
  here. The system draws them.
- **Colours.** Fifteen named colours and Automatic, in the order and with the names the Packing
  app uses, so a colour means the same thing in every AMS app.

It needs iOS 17 or macOS 14. There are no other dependencies.

## Add it to an app

The repository is https://github.com/marsch124/AMS-Icons

An app made with XcodeGen adds it to `project.yml`:

```yaml
packages:
  AMSIcons:
    url: https://github.com/marsch124/AMS-Icons
    from: "1.0.0"

targets:
  MyApp:
    dependencies:
      - package: AMSIcons
```

An app made in Xcode uses File > Add Package Dependencies and the same address.

Then, in any file that needs it:

```swift
import AMSIcons
```

An app that commits `Package.resolved` keeps the version it has until someone updates the
package. That is the wanted behaviour: a new icon never appears in an app by surprise.

## How an icon is stored

A choice is an `IconRef`. It is stored as **one string**:

| Kind | Stored as | Example |
|---|---|---|
| Hand-drawn | `hand:` and the key | `hand:bike` |
| Apple symbol | `symbol:` and the SF Symbols name | `symbol:figure.run` |

```swift
let ref = IconRef.hand("bike")
ref.stored                          // "hand:bike"
IconRef(stored: "symbol:book")      // the Apple symbol "book"
IconRef(stored: "bike")             // nil: a word with no prefix is not an icon
```

- Spaces around the string, and around the name, are taken off.
- The prefix is written in small letters. `Hand:bike` is not an icon.
- `IconRef(stored:)` gives `nil` for an empty string, for a prefix with no name, for an unknown
  prefix, and for a bare word. The package never guesses what an older value meant. The app
  decides.
- `IconRef` is `Codable` and writes that same one string, so it fits in a JSON field, a settings
  line or a key-value store. Decoding a bad string throws.
- Whether the icon is in this copy of the package is a different question. Ask
  `IconLibrary.exists(ref)`. A newer app may store an icon that an older copy of the package
  does not have yet. It is read and kept, and drawn as a dashed circle until the package is
  updated.

A colour is stored as its **key** (`"blue"`). Automatic is stored as nothing, or as `"auto"`.

```swift
IconColour.of(key: "blue")          // the Blue colour
IconColour.of(key: "auto")          // nil: Automatic is no palette colour
IconColour.of(key: "teal")          // nil: there is no teal
```

## Draw an icon

`IconMark` draws one icon at any size, in one colour.

```swift
IconMark(.hand("bike"), size: 28, colour: .green)
IconMark(.symbol("book"), size: 28)         // no colour: takes the colour around it
IconMark(nil)                               // a dashed circle: no icon here
```

- A hand-drawn icon is stroked at 1.9 points on its 24-point box and scaled with it.
- An Apple symbol is drawn by the system at about the same size and weight.
- An icon that cannot be drawn (an unknown hand-drawn key, or an Apple symbol that this device
  does not have) is a dashed circle. It is never an empty space.
- VoiceOver says the icon's label ("Bicycle").

`IconTile` draws the icon on a rounded square in a colour. This is the small cover that the
Packing app shows for a template.

```swift
IconTile(ref, colour: IconColour.of(key: "blue"), fallbackTint: .green, letter: "Garden", size: 40)
```

- With a colour, the tile is that colour and the icon is drawn in the colour's own ink: white on
  the deep colours, dark on the light ones (Yellow, Green, Orange, Lavender, Pink, Sand), where
  white cannot be read.
- With **Automatic** (`colour: nil`), the tile is `fallbackTint`, the app's own colour for this
  kind of thing, and the icon is white.
- With no icon, or an icon this device cannot draw, the tile shows the first letter of `letter`.
  It never shows an emoji.

## Choose an icon

`IconPicker` is the whole choosing screen, as in the Packing app. Present it in a sheet.

```swift
.sheet(isPresented: $choosing) {
    IconPicker(
        title: project.title,
        chosen: project.icon,                  // IconRef?
        colour: project.colour,                // IconColour?  (nil is Automatic)
        fallbackTint: .green,                  // what Automatic looks like
        onPick: { project.icon = $0 },         // nil means "No icon"
        onColour: { project.colour = $0 },     // nil means Automatic
        onCancel: nil
    )
}
```

From the top:

1. The chosen icon on its colour, the name (`title`), and **Cancel**.
2. **Colour**: Automatic and the fifteen colours in two rows of eight. Each is a small tile with
   the chosen icon on it and the colour's name under it. The chosen one has a ring.
3. **Icon**: a **Find an icon** field, a **No icon** choice, then the icons under headings:
   first `Hand-drawn · Travel`, `Hand-drawn · Outdoors` and so on, then
   `Apple symbols · Work and projects` and so on. Each icon is a rounded card with the icon and
   its label.

How it behaves:

- A press on a colour, on an icon, or on **No icon** calls its closure and then closes the
  picker. **Cancel** and Escape call `onCancel` and close it. This is how the Packing app works.
- A search that finds nothing says so, where the icons were.
- An Apple symbol that this device's system cannot draw is left out of the picker.
- On a Mac the sheet is at least 520 by 620 points. Command-F puts the cursor in the search
  field. Escape empties it, and on an empty field Escape closes the picker.
- Three cards to a row on an iPhone, four or more on a Mac.

Accessibility identifiers, for screen tests:

| Identifier | What it is |
|---|---|
| `icon.picker` | the whole picker |
| `icon.cancel` | Cancel |
| `icon.colour.auto` | the Automatic swatch |
| `icon.colour.<key>` | a colour swatch, for example `icon.colour.blue` |
| `icon.search` | the Find an icon field |
| `icon.search.clear` | the button that empties it |
| `icon.search.none` | the line shown when nothing matches |
| `icon.none` | the No icon card |
| `icon.choice.<stored>` | an icon card, for example `icon.choice.hand:bike` |
| `icon.heading.colour`, `icon.heading.icon` | the two main headings |
| `icon.section.<id>` | a group heading, for example `icon.section.hand.travel` |

The chosen colour and the chosen icon carry the "selected" trait.

## Colours

`IconColour.palette` has fifteen colours, in the picker's order. Each has a `key` (stored, never
changes), a `name` (written under the swatch), a `hex` (the fill) and an `ink` (the icon on that
fill).

| Key | Name |
|---|---|
| `blue` | Blue |
| `yellow` | Yellow |
| `green` | Green |
| `orange` | Orange |
| `lavender` | Lavender |
| `pink` | Pink |
| `red` | Red |
| `plum` | Plum |
| `violet` | Violet |
| `indigo` | Indigo |
| `navy` | Navy |
| `olive` | Olive |
| `sand` | Sand |
| `brown` | Brown |
| `slate` | Grey |

(The grey is stored as `slate`, as in the Packing app.)

- `IconColour.pickerRows` is Automatic and the palette in two rows of eight.
- `IconColour.fill(for:automatic:)` is the colour to paint: the chosen one, or the app's own for
  Automatic.
- `IconColour.markInk(for:)` is the colour of the icon on that fill. Use it, not plain white.
- The icon is readable on every colour (a test holds each pair to a contrast of 3.5 to 1).

## Search

`IconLibrary.search(_:)` returns the picker's headings with the icons found under each.

```swift
for section in IconLibrary.search("cykel") {
    // A heading such as "Hand-drawn · Travel", then the icons found under it.
    print(section.title, section.refs)
}
```

What is searched: an icon's **label**, its **key or symbol name**, and its **hidden words**.
The hidden words are English, Swedish and (for the hand-drawn icons) German. They are never
shown. The headings are not searched.

How a word matches:

- Capitals do not count. Spaces around the words do not count.
- The query is split at spaces and commas. Curly quotes are made straight.
- A word may be inside a longer word: "cykel" finds "elcykel".
- **An accent that is left out does not count.** "tradgard" finds "trädgård".
- **An accent that is typed does count.** In Swedish å, ä and ö are letters of their own, so
  "båt" finds a boat and never a bath.
- With several words, every word must be found somewhere in the icon's texts. "open book"
  narrows "book". The words may match different texts of the same icon.
- An empty search (or one of only spaces and commas) gives every icon.

The hand-drawn headings come first, in the Packing app's order, then Apple's, in the order of
`SymbolGroup`. A heading with nothing found is left out.

`IconLibrary.search(_:keeping:)` does the same and keeps only the icons the closure accepts. The
picker uses it to leave out Apple symbols that the device cannot draw.

Other helpers: `IconLibrary.hand`, `.symbols`, `.allRefs`, `.label(for:)`, `.exists(_:)`,
`.hiddenWords(for:)`, `.matches(_:_:)`, `.canDraw(_:)`.

## Add an icon

Every change to the lists is checked by the tests. Run `swift test` first.

### A hand-drawn icon

1. Draw it on a **24-point box**. See the rules below.
2. In `Sources/AMSIcons/HandIconCatalog.swift`, add one line **at the end of its heading**:
   `i("key", "Label", .group, "path data")`. The key is small letters a to z, with no spaces.
   The label is new in the whole list.
3. In `Sources/AMSIcons/HandIconKeywords.swift`, add the hidden words for the key: English,
   Swedish, and German if you know it. Small letters, one space between the words.
4. In `Tests/AMSIconsTests/HandIconTests.swift`, add the key at the end of its heading in
   `storedKeys`, and change the count (132) on purpose. The test is there so that nobody does
   this by accident.

### An Apple symbol

1. Find the name in the SF Symbols app. It must exist in **SF Symbols 5** (iOS 17 and macOS 14).
   When unsure, leave it out. Choose the outline form where there is one.
2. In `Sources/AMSIcons/SymbolCatalog.swift`, add a `SymbolIcon(name:label:group:words:)` inside
   its group. The list is in the picker's order, so a group's symbols stand together.
3. The label is one to three plain English words, new in the whole list ("Open book").
4. The words are hidden: at least two, small letters, English and the Swedish a person might
   type ("bok", "läsa"). No logos, no products, no flags of countries.
5. On a Mac, `swift test` asks the system whether it has a symbol of every name in the list. A
   misspelt name turns the test red. A name that is newer than macOS 14 may pass on a new Mac
   and still be missing on an older device, so check the name in the SF Symbols app.

## The rules

- **Keys never change.** An app has stored `hand:bike` or `symbol:figure.run`, maybe years ago.
  A key or a name may be added. None is renamed, moved to another heading, or taken away. A
  label and the hidden words may change, because they are not stored.
- **A hand-drawn icon is one stroke.** One stroke, 1.9 points wide, on a 24-point box. Round
  ends and round joins. No fill. Nothing closer than about 2 points apart, so it still reads at
  14 points. Every point stays about a point inside the box, because the stroke has width.
- **Only these path commands:** `M L H V C S Q A Z`, in capitals or small letters. Another
  command stops a debug build. `SVGPath.fault(in:)` tells you what is wrong with a drawing in a
  few plain words.
- **No emoji** anywhere in the package, in a label or in a word.
- **Plain English** in every text a person reads.

## Apple's symbols

The package stores only the **names** of SF Symbols. It contains none of Apple's artwork. The
system draws them.

Apple's licence lets you use SF Symbols **only in apps for Apple's own platforms** (iOS, iPadOS,
macOS, watchOS, tvOS and visionOS). So this package, and any app that uses its symbols, must
stay on those platforms. Do not copy a symbol's drawing into this repository, into a website, or
into a document. Do not use Apple's logos or product pictures as icons.

## Tests and CI

```
swift test
```

The tests cover the stored format, the 132 hand-drawn icons and their rules, the symbol list,
the search in English and Swedish, and the colours. On a Mac they also ask the system for every
symbol name.

`swift test` builds for the Mac only. The views have code for the iPhone too, so the CI also
runs this:

```
xcodebuild -scheme AMSIcons -destination 'generic/platform=iOS Simulator' CODE_SIGNING_ALLOWED=NO build
```

CI is in `.github/workflows/ci.yml`. It runs on every push and pull request, on a Mac runner
with the newest Xcode.

## Make a new version

1. Change the lists, run `swift test`, and push to `main` when CI is green.
2. Tag the commit with the new number: `git tag 1.1.0` and `git push origin 1.1.0`. A new icon
   or colour is a minor number (1.0.0 to 1.1.0). A fix is the last number (1.0.0 to 1.0.1).
   Taking a key away would be a major number, and the rules above say not to.
3. An app that says `from: "1.0.0"` takes the new version the next time its packages are updated.

## Layout

```
Package.swift
Sources/AMSIcons/
  IconRef.swift            the stored choice
  HandIcon.swift           a hand-drawn icon and its six headings
  HandIconCatalog.swift    the 132 drawings
  HandIconKeywords.swift   their hidden words
  SymbolIcon.swift         an Apple symbol and its sixteen headings
  SymbolCatalog.swift      the chosen symbols
  IconColour.swift         the palette
  IconSearch.swift         IconLibrary: lookups and search
  SVGPath.swift            reads path data into a SwiftUI Path
  Views/
    IconMark.swift         draws one icon
    IconTile.swift         the icon on a coloured square
    IconPicker.swift       the choosing screen
Tests/AMSIconsTests/
```
