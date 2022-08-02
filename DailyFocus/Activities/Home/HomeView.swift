//
//  HomeView.swift
//  DailyFocus
//
//  Created by Thomas Cowern New on 6/8/22.
//

import SwiftUI
import CoreData

struct HomeView: View {

    // MARK: Properties
    static let tag: String? = "Home"
    @StateObject var viewModel: ViewModel

    var projectRows: [GridItem] {
        [GridItem(.fixed(100))]
    }

    // Construct a fetch request to show the 10 highest-priority, incomplete items from open projects.
    init (dataController: DataController) {
        let viewModel = ViewModel(dataController: dataController)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: Body
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: projectRows) {
                            ForEach(viewModel.projects, content: ProjectSummaryView.init)
                        } // End of LazyHGrid
                        .padding([.horizontal, .top])
                        .fixedSize(horizontal: false, vertical: true)
                    }

                    VStack(alignment: .leading) {
                        ItemListView(title: "Up Next", items: viewModel.upNext)
                        ItemListView(title: "More To Explore", items:  viewModel.moreToExplore)
                    }
                    .padding()
                } // End of VStack
                .toolbar {
                    Button("Add Data") {
                        viewModel.addSampleData()
                    }
                }
            } // End of Scrollview
            .background(Color.systemGroupedBackground.ignoresSafeArea())
            .navigationTitle("Home")
        }
    }
}

// MARK: Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(dataController: .preview)
            .previewInterfaceOrientation(.portrait)
    }
}
