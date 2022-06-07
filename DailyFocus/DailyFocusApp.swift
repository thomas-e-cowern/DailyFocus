//
//  DailyFocusApp.swift
//  DailyFocus
//
//  Created by Thomas Cowern New on 6/7/22.
//

import SwiftUI

@main
struct DailyFocusApp: App {
    
    @StateObject var dataController: DataController
    
    init() {
        let dataController = DataController()
        _dataController = StateObject(wrappedValue: dataController)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
        }
    }
}
