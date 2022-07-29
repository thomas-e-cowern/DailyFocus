//
//  ProjectsViewModel.swift
//  DailyFocus
//
//  Created by Thomas Cowern New on 7/29/22.
//

import Foundation
import CoreData

extension ProjectsView {
    class ViewModel: ObservableObject {
        
        @State private var sortOrder = Item.SortOrder.optimized

        let showClosedProjects: Bool
        let projects: FetchRequest<Project>
        
        func addItem(to project: Project) {
            withAnimation {
                let item = Item(context: managedObjectContext)
                item.project = project
                item.creationDate = Date()
                dataController.save()
            }
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
            withAnimation {
                let project = Project(context: managedObjectContext)
                project.closed = false
                project.creationDate = Date()
                dataController.save()
            }
        }
    }
}
