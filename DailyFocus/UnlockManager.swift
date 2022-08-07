//
//  UnlockManager.swift
//  DailyFocus
//
//  Created by Thomas Cowern New on 8/7/22.
//

import Foundation
import Combine
import StoreKit

class UnlockManager: NSObject, ObservableObject {
    enum RequestState {
        case loading
        case loaded
        case failed
        case purchased
        case deferred
    }
    
    @Published var requestState = RequestState.loading
}
