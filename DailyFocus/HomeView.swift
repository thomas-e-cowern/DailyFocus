//
//  HomeView.swift
//  DailyFocus
//
//  Created by Thomas Cowern New on 6/8/22.
//

import SwiftUI
import CoreData

struct HomeView: View {

    // MARK: Properties
    static let tag: String? = "Home"

    var projectRows: [GridItem] {
        [GridItem(.fixed(100))]
    }

    @EnvironmentObject var dataController: DataController
    @FetchRequest(
        entity: Project.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Project.title, ascending: true)],
        predicate: NSPredicate(format: "closed = false")) var projects: FetchedResults<Project>

    let items: FetchRequest<Item>

    // Construct a fetch request to show the 10 highest-priority, incomplete items from open projects.
    init () {

        let completedPredicate = NSPredicate(format: "completed = false")
        let openPredicate = NSPredicate(format: "project.closed = false")
        let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [completedPredicate, openPredicate])

        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = compoundPredicate

        request.sortDescriptors = [NSSortDescriptor(keyPath: \Item.priority, ascending: false)]

        request.fetchLimit = 10

        items = FetchRequest(fetchRequest: request)
    }

    // MARK: Body
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: projectRows) {
                            ForEach(projects, content: ProjectSummaryView.init)
                        } // End of LazyHGrid
                        .padding([.horizontal, .top])
                        .fixedSize(horizontal: false, vertical: true)
                    }

                    VStack(alignment: .leading) {
                        ItemListView(title: "Up Next", items: items.wrappedValue.prefix(3))
                        ItemListView(title: "More To Explore", items: items.wrappedValue.dropFirst(3))
                    }
                    .padding()
                } // End of VStack
                .toolbar {
                    Button("Add Data") {
                        dataController.deleteAll()
                        try? dataController.createSampleData()
                    }
                }
            } // End of Scrollview
            .background(Color.systemGroupedBackground.ignoresSafeArea())
            .navigationTitle("Home")
        }
    }
}

// MARK: Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .previewInterfaceOrientation(.portrait)
    }
}
