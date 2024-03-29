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
    @StateObject var unlockManager: UnlockManager
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        print("Inside App Init")
        let dataController = DataController()
        let unlockManager = UnlockManager(dataController: dataController)

        _dataController = StateObject(wrappedValue: dataController)
        _unlockManager = StateObject(wrappedValue: unlockManager)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
                .environmentObject(unlockManager)
                // Automatically save when we detect that we are
                // no longer the foreground app. Use this rather than
                // scene phase so we can port to macOS, where scene
                // phase won't detect our app losing focus.
                .onReceive(
                    NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification),
                    perform: save
                )
                // Setting up to ask user for review
                .onAppear(perform: dataController.appLaunched)
        }
    }

    func save(_ note: Notification) {
        dataController.save()
    }
}
