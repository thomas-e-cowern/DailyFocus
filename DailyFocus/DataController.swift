//
//  DataController.swift
//  DailyFocus
//
//  Created by Thomas Cowern New on 6/7/22.
//

import CoreData
import SwiftUI
import CoreSpotlight
import WidgetKit
import StoreKit

/// An environment singleton responsible for managing our Core Data stack, including handling saving,
/// counting fetch requests, tracking awards, and dealing with sample data.
class DataController: ObservableObject {

    /// The lone cloudkit container used to store all our data
    let container: NSPersistentCloudKitContainer

    // The UserDefaults suite where we're saving user data.
    let defaults: UserDefaults

    /// Initializes a data controller, either in memory (for temporary use such as testing and previewing),
    /// or on permanent storage (for use in regular app runs.) Defaults to permanent storage.
    /// - Parameter inMemory: whether to stroe this data in temporary memory or not.
    init(inMemory: Bool = false, defaults: UserDefaults = .standard) {
        print("Data Controller Init")

        self.defaults = defaults

        container = NSPersistentCloudKitContainer(name: "Main", managedObjectModel: Self.model)

        // For testing and previewing purposes, we create a
        // temporary, in-memory database by writing to /dev/null
        // so our data is destroyed after the app finishes running
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        } else {
            let groupID = "group.com.mobilesoftwareservices.dailyfocus"
            
            if let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupID) {
                container.persistentStoreDescriptions.first?.url = url.appendingPathComponent("Main.sqlite")
            }
        }

        container.loadPersistentStores { [self] _, error in
            if let error = error {
                print("Fatal Error")
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            } else {
                let groupID = "group.com.mobilesoftwareservices.dailyfocus"

                if let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupID) {
                    container.persistentStoreDescriptions.first?.url = url.appendingPathComponent("Main.sqlite")
                }
            }

            #if DEBUG
            if CommandLine.arguments.contains("enable-testing") {
                self.deleteAll()
            }
            #endif
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

    /// Ensures data model is only loaded once
    static let model: NSManagedObjectModel = {
        guard let url = Bundle.main.url(forResource: "Main", withExtension: "momd") else {
            fatalError("Failed to locate model file.")
        }

        guard let managedObjectModel = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Failed to load model file.")
        }

        return managedObjectModel
    }()

    // Creating sample data
    /// - Throws: An NSError sent from calling save() on the NSManagedObjectContext
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

    /// Saves our Core Data context iff there are changes. This silently ignores
    /// any errors caused by saving, but this should be fine because all our attributes are optional.
    func save () {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
            WidgetCenter.shared.reloadAllTimelines()
        }
    }

    // Delete
    func delete (_ object: NSManagedObject) {
        let id = object.objectID.uriRepresentation().absoluteString
        if object is Item {
            // deletes an item
            CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: [id])
        } else {
            // deletes a project
            CSSearchableIndex.default().deleteSearchableItems(withDomainIdentifiers: [id])
        }
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

//    func hasEarned(award: Award) -> Bool {
//        switch award.criterion {
//
//        // returns true if they added a certain number of items
//        case "items":
//            let fetchRequest: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
//            let awardCount = count(for: fetchRequest)
//            return awardCount >= award.value
//
//        // returns true if they completed a certain number of items
//        case "complete":
//            let fetchRequest: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
//            fetchRequest.predicate = NSPredicate(format: "completed = true")
//            let awardCount = count(for: fetchRequest)
//            return awardCount >= award.value
//
//        default:
//            // an unknown award criterion; this should never be allowed
//            return false
//        }
//    }

    func update(_ item: Item) {
        let itemId = item.objectID.uriRepresentation().absoluteString
        let projectId = item.project?.objectID.uriRepresentation().absoluteString

        let attributeSet = CSSearchableItemAttributeSet(contentType: .text)
        attributeSet.title = item.itemTitle
        attributeSet.contentDescription = item.itemDetail

        let searchableItem = CSSearchableItem(
            uniqueIdentifier: itemId,
            domainIdentifier: projectId,
            attributeSet: attributeSet
        )

        CSSearchableIndex.default().indexSearchableItems([searchableItem])
    }

    func item(with uniqueIdentifier: String) -> Item? {
        guard let url = URL(string: uniqueIdentifier) else {
            return nil
        }

        guard let id = container.persistentStoreCoordinator.managedObjectID(forURIRepresentation: url) else {
            return nil
        }

        return try? container.viewContext.existingObject(with: id) as? Item
    }

    @discardableResult func addProject () -> Bool {
        let canCreate = fullVersionUnlocked || count(for: Project.fetchRequest()) < 3

        if canCreate {
            let project = Project(context: container.viewContext)
            project.closed = false
            project.creationDate = Date()
            save()
            return true
        } else {
            return false
        }
    }

    // Loads and saves whether our premium unlock has been purchased.
    var fullVersionUnlocked: Bool {
        get {
            defaults.bool(forKey: "fullVersionUnlocked")
        }

        set {
            defaults.set(newValue, forKey: "fullVersionUnlocked")
        }
    }

    // Sets up app to call for a review
//    @available(iOSApplicationExtension, unavailable)
//    func appLaunched() {
//        // 5 projects and they get asked for a review
//        guard count(for: Project.fetchRequest()) >= 5 else {
//            return
//        }
//        let allScenes = UIApplication.shared.connectedScenes
//        let scene = allScenes.first { $0.activationState == .foregroundActive }
//
//        if let windowScene = scene as? UIWindowScene {
//            SKStoreReviewController.requestReview(in: windowScene)
//        }
//    }
    
    func fetchRequestForTopItems(count: Int) -> NSFetchRequest <Item> {
        let itemRequest: NSFetchRequest<Item> = Item.fetchRequest()
        let completedPredicate = NSPredicate(format: "completed = false")
        let openPredicate = NSPredicate(format: "project.closed = false")
        let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [completedPredicate, openPredicate])
        itemRequest.predicate = compoundPredicate

        itemRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Item.priority, ascending: false)]

        itemRequest.fetchLimit = count
        return itemRequest
    }
    
    func results<T: NSManagedObject>(for fetchRequest: NSFetchRequest<T>) -> [T] {
        return (try? container.viewContext.fetch(fetchRequest)) ?? []
    }
}
