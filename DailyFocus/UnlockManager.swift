//
//  UnlockManager.swift
//  DailyFocus
//
//  Created by Thomas Cowern New on 8/7/22.
//

import Foundation
import Combine
import StoreKit

class UnlockManager: NSObject, ObservableObject, SKPaymentTransactionObserver, SKProductsRequestDelegate {

    enum RequestState {
        case loading
        case loaded
        case failed
        case purchased
        case deferred
    }

    @Published var requestState = RequestState.loading
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        // More to come
    }

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        // More to come
    }
}
