//
//  ProjectsViewModel.swift
//  DailyFocus
//
//  Created by Thomas Cowern New on 7/29/22.
//

import Foundation
import CoreData
import SwiftUI

extension ProjectsView {
    class ViewModel: ObservableObject {

        let dataController: DataController

//        @StateObject var viewModel: ViewModel

        var sortOrder = Item.SortOrder.optimized
        let showClosedProjects: Bool
        let projects: FetchRequest<Project>

        init(dataController: DataController, showClosedProjects: Bool) {
            self.dataController = dataController
            self.showClosedProjects = showClosedProjects

            projects = FetchRequest<Project>(entity: Project.entity(), sortDescriptors: [
                NSSortDescriptor(keyPath: \Project.creationDate, ascending: false)
            ], predicate: NSPredicate(format: "closed = %d", showClosedProjects))
        }

        func addItem(to project: Project) {
            let item = Item(context: dataController.container.viewContext)
            item.project = project
            item.creationDate = Date()
            dataController.save()
        }

        func delete(_ offsets: IndexSet, from project: Project) {
            let allItems = project.projectItems(using: sortOrder)

            for offset in offsets {
                let item = allItems[offset]
                dataController.delete(item)
            }

            dataController.save()
        }

        func addProject () {
            let project = Project(context: dataController.container.viewContext)
            project.closed = false
            project.creationDate = Date()
            dataController.save()
        }
    }
}
