//
//  ProjectsView.swift
//  DailyFocus
//
//  Created by Thomas Cowern New on 6/8/22.
//

import SwiftUI

struct ProjectsView: View {
    
    // MARK:  Properties
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State private var showingSortOrder = false
    @State private var sortOrder = Item.SortOrder.optimized
    @State var sortDescriptor: NSSortDescriptor?
    
    static let openTag: String? = "Open"
    static let closedTag: String? = "Closed"
    
    let showClosedProjects: Bool
    
    let projects: FetchRequest<Project>
    
    // MARK:  Initializer
    init(showClosedProjects: Bool) {
        self.showClosedProjects = showClosedProjects
        
        projects = FetchRequest<Project>(entity: Project.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Project.creationDate, ascending: false)], predicate: NSPredicate(format: "closed = %d", showClosedProjects))
    }
    
    // MARK:  Body
    var body: some View {
        NavigationView {
            Group {
                if projects.wrappedValue.count == 0 {
                    SelectSomethingView()
                } else {
                    List {
                        ForEach(projects.wrappedValue) { project in
                            Section(header: ProjectHeaderView(project: project)) {
                                ForEach(project.projectItems(using: sortOrder)) { item in
                                    ItemRowView(project: project, item: item)
                                }
                                .onDelete { offsets in
                                    delete(offsets, from: project)
                                }
                                if showClosedProjects == false {
                                    Button {
                                        addItem(to: project)
                                    } label: {
                                        Label("Add New Item", systemImage: "plus")
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                    .navigationBarTitle(showClosedProjects ? "Closed Projects" : "Open Projects")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            if showClosedProjects == false {
                                Button {
                                    withAnimation {
                                        let project = Project(context: managedObjectContext)
                                        project.closed = false
                                        project.creationDate = Date()
                                        dataController.save()
                                    }
                                } label: {
                                    Label("Add Project", systemImage: "plus")
                                }
                            }
                        }
                        
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                showingSortOrder.toggle()
                            } label: {
                                Label("Sort", systemImage: "arrow.up.arrow.down")
                            }
                        }
                        
                    }
                }
            }
            .actionSheet(isPresented: $showingSortOrder) {
                ActionSheet(title: Text("Sort Items"), message: nil, buttons: [
                    .default(Text("Optimized")) { sortOrder = .optimized },
                    .default(Text("Creation Date")) { sortOrder = .creationDate },
                    .default(Text("Title")) { sortOrder = .title }
                ])
            }
        }
    }
    
    // MARK:  Methods
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
}

// MARK:  Preview
struct ProjectsView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    
    static var previews: some View {
        ProjectsView(showClosedProjects: false)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
            .previewInterfaceOrientation(.portraitUpsideDown)
    }
}
