//
//  ItemRowView.swift
//  DailyFocus
//
//  Created by Thomas Cowern New on 6/16/22.
//

import SwiftUI

struct ItemRowView: View {
    
    // MARK:  Properties
    @ObservedObject var project: Project
    @ObservedObject var item: Item
    
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
    
    // MARK:  Body
    var body: some View {
        // Link to edit item view
        NavigationLink(destination: EditItemView(item: item)) {
            Label {
                Text(item.itemTitle)
            } icon: {
                icon
            }
            .accessibilityLabel(label)
        }
    }
}

// MARK:  Preview
struct ItemRowView_Previews: PreviewProvider {
    static var previews: some View {
        ItemRowView(project: Project.example, item: Item.example)
    }
}
