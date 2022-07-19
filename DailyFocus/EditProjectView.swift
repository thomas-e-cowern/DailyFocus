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
    @Environment(\.presentationMode) var presentationMode
    @State private var showingDeleteConfirm = false

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
            Section(header: Text("Basic Settings")) {
                TextField("Project Name", text: $title.onChange(update))
                TextField("Description of this project", text: $detail.onChange(update))
            }
            // Section 2
            Section(header: Text("Custom Project Color")) {
                LazyVGrid(columns: colorColumns) {
                    ForEach(Project.colors, id: \.self, content: colorButton)
                }
                .padding(.vertical)
            }
            // Section 3
            Section(header: Text("Closing a project moves it from the Open to Closed tab; deleting if removes the project completely")) {
                Button(project.closed ? "Reopen this project" : "Close this project") {
                    project.closed.toggle()
                    update()
                }

                Button("Delete this project") {
                    showingDeleteConfirm.toggle()
                }
                .tint(Color.red)
            }
        }
        .navigationBarTitle("Edit Project")
        .onDisappear(perform: dataController.save)
        .alert(isPresented: $showingDeleteConfirm) {
            Alert(title: Text("Delete project?"), message: Text("Are you sure you want to delete this project?  You will also delete all the items it contains."), primaryButton: .default(Text("Delete"), action: delete), secondaryButton: .cancel())
        }
    }


    // MARK:  Methods
    func update () {
        project.title = title
        project.detail = detail
        project .color = color
    }

    func delete () {
        dataController.delete(project)
        presentationMode.wrappedValue.dismiss()
    }

    func colorButton(for item: String) -> some View {
        ZStack {
            Color(item)
                .aspectRatio(contentMode: .fit)
                .cornerRadius(6)

            if item == color {
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.white)
                    .font(.largeTitle)
            }
        }
        .onTapGesture {
            color = item
            update()
        }
        .accessibilityElement(children: .ignore)
        .accessibilityAddTraits(

            item == color ? [.isButton, .isSelected] : .isButton
        )
        .accessibilityLabel(LocalizedStringKey(item))
    }
}

struct EditProjectView_Previews: PreviewProvider {
    static var previews: some View {
        EditProjectView(project: Project.example)
    }
}
