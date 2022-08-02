//
//  ItemRowViewModel.swift
//  DailyFocus
//
//  Created by Thomas Cowern New on 8/2/22.
//

import Foundation

extension ItemRowView {
    class ViewModel: ObservableObject {

        let project: Project
        let ite: Item
        
        var icon: some View {
            if item.completed {
                return Image(systemName: "checkmark.circle")
                    .foregroundColor(Color(project.projectColor))
            } else if item.priority == 3 {
                return Image(systemName: "exclamationmark.triangle")
                    .foregroundColor(Color(project.projectColor))
            } else {
                return Image(systemName: "checkmark.circle")
                    .foregroundColor(.clear)
            }
        }

        var label: Text {
            if item.completed {
                return Text("\(item.itemTitle), completed")
            } else if item.priority == 3 {
                return Text("\(item.itemTitle), high priority")
            } else {
                return Text(item.itemTitle)
            }
        }

        internal init(project: Project, ite: Item) {
            self.project = project
            self.ite = ite
        }
    }
}
