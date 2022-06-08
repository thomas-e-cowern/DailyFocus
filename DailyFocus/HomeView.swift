//
//  HomeView.swift
//  DailyFocus
//
//  Created by Thomas Cowern New on 6/8/22.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var dataController: DataController
    
    var body: some View {
        NavigationView {
            VStack {
                Button("Add Data") {
                    dataController.deleteAll()
                    try? dataController.createSampleData()
                }
            }
            navigationBarTitle("Home")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
