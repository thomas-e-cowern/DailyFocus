//
//  DailyFocusWidget.swift
//  DailyFocusWidget
//
//  Created by Thomas Cowern on 12/9/22.
//

import WidgetKit
import SwiftUI









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
