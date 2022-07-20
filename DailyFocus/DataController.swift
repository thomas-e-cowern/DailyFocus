//
//  DataController.swift
//  DailyFocus
//
//  Created by Thomas Cowern New on 6/7/22.
//

import CoreData
import SwiftUI

class DataController: ObservableObject {
    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        print("Data Controller Init")
        container = NSPersistentCloudKitContainer(name: "Main")

        // For testing and previewing purposes, we create a
        // temporary, in-memory database by writing to /dev/null
        // so our data is destroyed after the app finishes running
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { _, error in
            if let error = error {
                print("Fatal Error")
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }
        }
    }

    // Creating a data controller and sample data for previews
    static var preview: DataController = {
        let dataController = DataController(inMemory: true)

        do {
            try dataController.createSampleData()
        } catch {
            fatalError("Fatal error creating preview: \(error.localizedDescription)")
        }

        return dataController

    }()

    // Creating sample data
    func createSampleData() throws {
        let viewContext = container.viewContext

        for projI in 1...5 {
            let project = Project(context: viewContext)
            project.title = "Project \(projI)"
            project.items = []
            project.creationDate = Date()
            project.closed = Bool.random()

            for itemI in 1...10 {
                let item = Item(context: viewContext)
                item.title = "Item \(itemI)"
                item.creationDate = Date()
                item.completed = Bool.random()
                item.project = project
                item.priority = Int16.random(in: 1...3)
            }
        }

        try? viewContext.save()
    }

    // Save after checking for changes
    func save () {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }

    // Delete
    func delete (_ object: NSManagedObject) {
        container.viewContext.delete(object)
    }

    // Delete all data during testing
    func deleteAll () {
        let fetchRequest1: NSFetchRequest<NSFetchRequestResult> = Item.fetchRequest()
        let batchDeleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
        _ = try? container.viewContext.execute(batchDeleteRequest1)

        let fetchRequest2: NSFetchRequest<NSFetchRequestResult> = Project.fetchRequest()
        let batchDeleteRequest2 = NSBatchDeleteRequest(fetchRequest: fetchRequest2)
        _ = try? container.viewContext.execute(batchDeleteRequest2)
    }

    // Get counts for awards
    func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
        (try? container.viewContext.count(for: fetchRequest)) ?? 0
    }

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
