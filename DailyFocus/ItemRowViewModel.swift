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
        let item: Item
        
        var icon: String {
            if item.completed {
                return "checkmark.circle"
            } else if item.priority == 3 {
                return "exclamationmark.triangle"
            } else {
                return "checkmark.circle"
            }
        }
        
        var color: String? {
            if item.completed {
                return project.projectColor
            } else if item.priority == 3 {
                return project.projectColor
            } else {
                return nil
            }
        }

        var label: String {
            if item.completed {
                return "\(item.itemTitle), completed"
            } else if item.priority == 3 {
                return "\(item.itemTitle), high priority"
            } else {
                return item.itemTitle
            }
        }

        internal init(project: Project, ite: Item) {
            self.project = project
            self.ite = ite
        }
    }
}
