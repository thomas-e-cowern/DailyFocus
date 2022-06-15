//
//  Project-CoreDataHelpers.swift
//  DailyFocus
//
//  Created by Thomas Cowern New on 6/15/22.
//

import Foundation

extension Project {
    var projectTitle: String {
        title ?? "New Project"
    }
    
    var projectDetails: String {
        detail ?? ""
    }
    
    var projectColors: String {
        color ?? "Light Blue"
    }
    
    static var example: Project {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        let project = Project(context: viewContext)
        project.title = "Example Project"
        project.detail = "This is an example project"
        project.closed = true
        project.creationDate = Date()
        
        return project
    }
    
    var allItems: [Item] {
        let itemsArray = items?.allObjects as? [Item] ?? []
        return itemsArray
    }
}
