//
//  DailyFocusWidget.swift
//  DailyFocusWidget
//
//  Created by Thomas Cowern on 12/9/22.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), items: [Item.example])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), items: loadItems())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = SimpleEntry(date: Date(), items: loadItems())
        
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
    
    func loadItems() -> [Item] {
        let dataController = DataController()
        let itemRequest = dataController.fetchRequestForTopItems(count: 5)
        return dataController.results(for: itemRequest)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let items: [Item]
}

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

struct DailyFocusWidgetMultipleEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack(spacing: 5) {
            ForEach(entry.items) { item in
                HStack {
                    Color(item.project?.color ?? "Light Blue")
                        .frame(width: 5)
                        .clipShape(Capsule())

                    VStack(alignment: .leading) {
                        Text(item.itemTitle)
                            .font(.headline)

                        if let projectTitle = item.project?.title {
                            Text(projectTitle)
                                .foregroundColor(.secondary)
                        }
                    }

                    Spacer()
                }
            }
        }
        .padding(20)    }
}

struct ComplexDailyFocusWidget: Widget {
    let kind: String = "ComplexDailyFocusWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            DailyFocusWidgetMultipleEntryView(entry: entry)
        }
        .configurationDisplayName("Up next…")
        .description("Your most important items.")
    }
}

struct DailyFocusWidget_Previews: PreviewProvider {
    static var previews: some View {
        DailyFocusWidgetEntryView(entry: SimpleEntry(date: Date(), items: [Item.example]))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
