//
//  ItemRowView.swift
//  DailyFocus
//
//  Created by Thomas Cowern New on 6/16/22.
//

import SwiftUI

struct ItemRowView: View {

    // MARK: Properties
    @StateObject var viewModel: ViewModel
    @ObservedObject var item: Item

    // MARK: Body
    var body: some View {
        // Link to edit item view
        NavigationLink(destination: EditItemView(item: item)) {
            Label {
                Text(item.itemTitle)
            } icon: {
                Image(systemName: viewModel.icon)
                    .foregroundColor(viewModel.color.map { Color($0) } ?? .clear)
            }
            .accessibilityLabel(viewModel.label)
        }
    }

    init(project: Project, item: Item) {
        let viewModel = ViewModel(project: project, item: item)
        _viewModel = StateObject(wrappedValue: viewModel)

        self.item = item
    }
}

// MARK: Preview
struct ItemRowView_Previews: PreviewProvider {
    static var previews: some View {
        ItemRowView(project: Project.example, item: Item.example)
    }
}
