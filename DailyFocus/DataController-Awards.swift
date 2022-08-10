//
//  DataController-Awards.swift
//  DailyFocus
//
//  Created by Thomas Cowern New on 8/10/22.
//

import Foundation
import CoreData

extension DataController {
    func hasEarned(award: Award) -> Bool {
        switch award.criterion {

        // returns true if they added a certain number of items
        case "items":
            let fetchRequest: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value

        // returns true if they completed a certain number of items
        case "complete":
            let fetchRequest: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
            fetchRequest.predicate = NSPredicate(format: "completed = true")
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value

        default:
            // an unknown award criterion; this should never be allowed
            return false
        }
    }
}
