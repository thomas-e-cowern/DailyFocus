//
//  DailyFocusWidget.swift
//  DailyFocusWidget
//
//  Created by Thomas Cowern on 12/9/22.
//

import WidgetKit
import SwiftUI











struct DailyFocusWidget_Previews: PreviewProvider {
    static var previews: some View {
        DailyFocusWidgetEntryView(entry: SimpleEntry(date: Date(), items: [Item.example]))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
