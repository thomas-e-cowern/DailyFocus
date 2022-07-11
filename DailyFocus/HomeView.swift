//
//  HomeView.swift
//  DailyFocus
//
//  Created by Thomas Cowern New on 6/8/22.
//

import SwiftUI
import CoreData

struct HomeView: View {
    
    static let tag: String? = "Home"
    
    @EnvironmentObject var dataController: DataController
    @FetchRequest(entity: Project.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Project.title, ascending: true)], predicate: NSPredicate(format: "closed = false")) var projects: FetchedResults<Project>
    let items: FetchRequest<Item>
    
    init () {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "completed = false")
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Item.priority, ascending: false)]
        
        request.fetchLimit = 10
        
        items = FetchRequest(fetchRequest: request)
    }
    
    
    var body: some View {
        NavigationView {
            ScrollView {
 
            }
            .background(Color.systemGroupedBackground.ignoresSafeArea())
            .navigationTitle("Home")
        }
    }
}

//Button("Add Data") {
//    dataController.deleteAll()
//    try? dataController.createSampleData()
//}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .previewInterfaceOrientation(.portrait)
    }
}
