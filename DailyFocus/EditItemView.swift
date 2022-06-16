//
//  EditItemView.swift
//  DailyFocus
//
//  Created by Thomas Cowern New on 6/16/22.
//

import SwiftUI

struct EditItemView: View {
    
    // MARK:  Properties
    let item: Item
    
    @EnvironmentObject var dataController: DataController
    
    @State private var title: String
    @State private var detail: String
    @State private var priority: Int
    @State private var completed: Bool
    
    // MARK:  Initializer
    init(item: Item) {
        self.item = item
        
        _title = State(wrappedValue: item.itemTitle)
        _detail = State(wrappedValue: item.itemDetail)
        _priority = State(wrappedValue: Int(item.priority))
        _completed = State(wrappedValue: item.completed)
    }
    
    // MARK:  Body
    var body: some View {
        Form {
            Section(header: Text("Basic Settings")) {
                TextField("Item Name", text: $title)
                TextField("Description", text: $detail)
            }
            
            Section(header: Text("Priority")) {
                Picker("Priority", selection: $priority) {
                    Text("Low").tag(1)
                    Text("Medium").tag(2)
                    Text("High").tag(3)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            Section {
                Toggle("Mark Completed", isOn: $completed)
            }
        }
        .navigationTitle("Edit Item")
    }
}

// MARK:  Preview
struct EditItemView_Previews: PreviewProvider {
    static var previews: some View {
        EditItemView(item: Item.example)
    }
}
