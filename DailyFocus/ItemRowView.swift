//
//  ItemRowView.swift
//  DailyFocus
//
//  Created by Thomas Cowern New on 6/16/22.
//

import SwiftUI

struct ItemRowView: View {
    
    // MARK:  Properties
    @ObservedObject var item: Item
    
    // MARK:  Body
    var body: some View {
        NavigationLink(destination: EditItemView(item: item)) {
            Text(item.itemTitle)
        }
    }
}

// MARK:  Preview
struct ItemRowView_Previews: PreviewProvider {
    static var previews: some View {
        ItemRowView(item: Item.example)
    }
}
