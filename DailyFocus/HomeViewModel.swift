//
//  HomeViewModel.swift
//  DailyFocus
//
//  Created by Thomas Cowern New on 8/2/22.
//

import Foundation
import CoreData

extension HomeView {
    class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
        private let projectsController: NSFetchedResultsController<Project>
        private let itemsController: NSFetchedResultsController<Item>

        @Published var projects = [Project]()
        @Published var items = [Item]()

        var dataController: DataController

        init(dataController: DataController) {
            self.dataController = dataController

            // Construct a fetch request to show all open projects
            let projectRequest: NSFetchRequest<Project> = Project.fetchRequest()
            projectRequest.predicate = NSPredicate(format: "closed = false")
            projectRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Project.title, ascending: true)]

            projectsController = NSFetchedResultsController(
                fetchRequest: projectRequest,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )

            // Construct a fetch request to show 10 highest priority items if still open
            let itemRequest: NSFetchRequest<Item> = Item.fetchRequest()
            let completedPredicate = NSPredicate(format: "closed = false")
            let openPredicate = NSPredicate(format: "project.closed = false")
            let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [completedPredicate, openPredicate])
            itemRequest.predicate = compoundPredicate

            itemRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Item.priority, ascending: false)]

            itemRequest.fetchLimit = 10
            
            itemsController = NSFetchedResultsController(
                fetchRequest: itemRequest,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
        }
    }
}
