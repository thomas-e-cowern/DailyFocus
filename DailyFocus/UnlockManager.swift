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

    private let dataController: DataController
    private let request: SKProductsRequest
    private var loadedProducts = [SKProduct]()

    init(dataController: DataController) {
        // Store the data controller
        self.dataController = dataController

        // Prepare to look for the unlock product
        let productIds = Set(["com.mobilesoftwareservices.DailyFocus.unlock"])
        request = SKProductsRequest(productIdentifiers: productIds)

        // NSobject requirement
        super.init()

        // Start the payment queue
        SKPaymentQueue.default().add(self)

        // Set up ntofications when product request completes
        request.delegate = self

        // Start the request
        request.start()
    }
    
    // Deinitialize payment queue
    deinit {
        SKPaymentQueue.default().remove(self)
    }

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        // More to come
    }

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        // More to come
    }
}
