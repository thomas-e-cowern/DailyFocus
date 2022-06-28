//
//  EditProjectView.swift
//  DailyFocus
//
//  Created by Thomas Cowern New on 6/17/22.
//

import SwiftUI

struct EditProjectView: View {
    
    let project: Project
    
    @EnvironmentObject var dataController: DataController
    
    @State private var title: String
    @State private var detail: String
    @State private var color: String
    
    let colorColumns = [
        GridItem(.adaptive(minimum: 44))
    ]
    
    init (project: Project) {
        self.project = project
        
        _title = State(wrappedValue: project.projectTitle)
        _detail = State(wrappedValue: project.projectDetails)
        _color = State(wrappedValue: project.projectColor)
    }
    
    var body: some View {
        Form {
            // Section 1
            Section(header: Text("Basic settings")) {
                TextField("Project Name", text: $title.onChange(update))
                TextField("Description of this project", text: $detail.onChange(update))
            }
            // Section 2
            Section(header: Text("Custom Project Color")) {
                LazyVGrid(columns: colorColumns) {
                    ForEach(project.color, id: \.self) { item in
                        ZStack {
                            Color(item)
                                .aspectRatio(contentMode: 1, contentMode(.fit))
                                .cornerRadius(6)
                            
                            if item == color {
                                Image(systemName: "checkmark.circle")
                                    .foregroundColor(.white)
                                    .font(.largeTitle)
                            }
                        }
                        .onTapGesture {
                            color = item
                            update()ß
                        }
                    }
                }
            }
            // Section 3
            Section(header: Text("Section 3")) {
                <#code#>
            }
        }
        .navigationBarTitle("Edit Project")
    }
    
    func update () {
        
    }
}

struct EditProjectView_Previews: PreviewProvider {
    static var previews: some View {
        EditProjectView(project: Project.example)
    }
}
