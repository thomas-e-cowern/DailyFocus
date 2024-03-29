//
//  ComplexWidget.swift
//  DailyFocusWidgetExtension
//
//  Created by Thomas Cowern on 12/15/22.
//
import WidgetKit
import SwiftUI

struct DailyFocusWidgetMultipleEntryView: View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var widgetFamily
    @Environment(\.sizeCategory) var sizeCategory
    
    var items: ArraySlice<Item> {
        let itemCount: Int

        switch widgetFamily {
            case .systemSmall:
                itemCount = 1
            case .systemLarge:
                if sizeCategory < .extraExtraLarge {
                    itemCount = 5
                } else {
                    itemCount = 4
                }
            default:
                if sizeCategory < .extraLarge {
                    itemCount = 3
                } else {
                    itemCount = 2
                }
        }

        return entry.items.prefix(itemCount)
    }

    var body: some View {
        VStack(spacing: 5) {
            ForEach(items) { item in
                HStack {

                        Color(item.project?.color ?? "Light Blue")
                        .frame(width: 5)
                        .clipShape(Capsule())


                    VStack(alignment: .leading) {
                        Text(item.itemTitle)
                            .font(.headline)
                            .layoutPriority(1)

                        if let projectTitle = item.project?.title {
                            Text(projectTitle)
                                .foregroundColor(.secondary)
                        }
                    }

                    Spacer()
                }
            }
        }
        .padding(20)
    }
    
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

struct ComplexWidget_Previews: PreviewProvider {
    static var previews: some View {
        DailyFocusWidgetMultipleEntryView(entry: SimpleEntry(date: Date(), items: [Item.example]))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
