//
//  ArrayDiff.swift
//  Coconut
//
//  Created by Kacper Kaliński on 19/01/2019.
//

import Foundation

internal func diff<Element>(_ left: [[Element]], _ right: [[Element]], match: (Element, Element) -> Bool) -> (sectionsDiff: Int, insert: [IndexPath], update: [IndexPath], delete: [IndexPath]) {
    let sectionsDiff = right.count - left.count
    var insertions: [IndexPath] = []
    if sectionsDiff > 0 {
        ((right.count - sectionsDiff) ..< right.count).forEach { idx in
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
                .map { $0.offset }
                .map {
                    return IndexPath(row: $0, section: index)
        })
        insertions.append(contentsOf:
            rightSection
                .enumerated()
                .filter { leftSection[safeIndex: $0.offset] == nil }
                .map { $0.offset }
                .map {
                    return IndexPath(row: $0, section: index)
                })
        updates.append(contentsOf:
            leftSection
                .enumerated()
                .filter { rightSection[safeIndex: $0.offset] != nil && !match(rightSection[$0.offset], $0.element) }
                .map { $0.offset }
                .map { IndexPath(row: $0, section: index) })
    }

    return (sectionsDiff: sectionsDiff, insert: insertions, update: updates, delete: deletions)
}

extension Array {
    subscript(safeIndex index: Int) -> Element? {
        guard count > index else { return nil }
        return self[index]
    }
}
