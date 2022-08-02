//
//  HomeViewModel.swift
//  DailyFocus
//
//  Created by Thomas Cowern New on 8/2/22.
//

import Foundation
import CoreData

extension HomeView {
    class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
        private let projectsController: NSFetchedResultsController<Project>
        private let itemsController: NSFetchedResultsController<Item>
    }
}
