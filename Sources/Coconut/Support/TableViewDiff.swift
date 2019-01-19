import Foundation

internal typealias TableViewDiff = (sectionsDiff: SectionsDiff, insert: [IndexPath], update: [IndexPath], delete: [IndexPath])

internal func tableViewDiff<Element>(_ left: [[Element]], _ right: [[Element]], match: (Element, Element) -> Bool) -> TableViewDiff {
    let sectionsChange = right.count - left.count
    var insertions: [IndexPath] = []
    if sectionsChange > 0 {
        ((right.count - sectionsChange) ..< right.count).forEach { idx in
            insertions.append(contentsOf:
                right[idx].enumerated()
                    .map { IndexPath(row: $0.offset, section: idx) })
        }
    } else { /* continue */ }
    var updates: [IndexPath] = []
    var deletions: [IndexPath] = []
    let commonSections = zip(left, right)
    for (index, (leftSection, rightSection)) in commonSections.enumerated() {
        deletions.append(contentsOf:
            leftSection
                .enumerated()
                .filter { rightSection[safeIndex: $0.offset] == nil }
                .map { IndexPath(row: $0.offset, section: index)
        })
        insertions.append(contentsOf:
            rightSection
                .enumerated()
                .filter { leftSection[safeIndex: $0.offset] == nil }
                .map { IndexPath(row: $0.offset, section: index) })
        updates.append(contentsOf:
            leftSection
                .enumerated()
                .filter { rightSection[safeIndex: $0.offset] != nil && !match(rightSection[$0.offset], $0.element) }
                .map { IndexPath(row: $0.offset, section: index) })
    }
    let sectionsDiff: SectionsDiff
    if sectionsChange > 0 {
        sectionsDiff = .insert(IndexSet(left.count ..< (left.count + sectionsChange)))
    } else if sectionsChange < 0 {
        sectionsDiff = .delete(IndexSet((left.count + sectionsChange) ..< left.count))
    } else {
        sectionsDiff = .none
    }
    return (sectionsDiff: sectionsDiff, insert: insertions, update: updates, delete: deletions)
}

internal enum SectionsDiff {
    case none
    case insert(IndexSet)
    case delete(IndexSet)
}
extension Array {
    subscript(safeIndex index: Int) -> Element? {
        guard count > index else { return nil }
        return self[index]
    }
}
