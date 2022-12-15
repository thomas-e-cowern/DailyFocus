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

struct SimpleDailyFocusWidget: Widget {
    let kind: String = "SimpleDailyFocusWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            DailyFocusWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Up next…")
        .description("TYour #1 top-priority item.")
        .supportedFamilies([.systemSmall])
    }
}

struct DailyFocusWidget_Previews: PreviewProvider {
    static var previews: some View {
        DailyFocusWidgetEntryView(entry: SimpleEntry(date: Date(), items: [Item.example]))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
