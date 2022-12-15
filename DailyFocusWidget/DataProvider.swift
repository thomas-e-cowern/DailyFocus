//
//  DataProvider.swift
//  DailyFocusWidgetExtension
//
//  Created by Thomas Cowern on 12/15/22.
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
