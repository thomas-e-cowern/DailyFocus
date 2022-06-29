//
//  Sequence-Sorting.swift
//  DailyFocus
//
//  Created by Thomas Cowern New on 6/29/22.
//

import Foundation

extension Sequence {
    func sorted(by sortDescriptors: [NSSortDescriptor]) -> [Element] {
        self.sorted {
            for descriptor in sortDescriptors {
                switch descriptor.compare($0, to: $1) {
                case .orderedAscending:
                    return true
                case .orderedDescending:
                    return false
                case .orderedSame:
                    continue
                }
            }
            return false
        }
    }
}
