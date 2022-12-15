//
//  SimpleWidget.swift
//  DailyFocusWidgetExtension
//
//  Created by Thomas Cowern on 12/15/22.
//

import WidgetKit
import SwiftUI

struct DailyFocusWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Up Next...")
                .font(.title)
            
            if let item = entry.items.first {
                Text(item.itemTitle)
            } else {
                Text("Nothing!")
            }
        }
    }
}
