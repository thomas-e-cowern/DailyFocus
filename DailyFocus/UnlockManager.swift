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
        case loaded(SKProduct)
        case failed(Error?)
        case purchased
        case deferred
    }

    private enum StoreError: Error {
        case invalidIdentifiers, missingProduct
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
        DispatchQueue.main.async {
              // Store the returned products for later, if we need them.
              self.loadedProducts = response.products

              guard let unlock = self.loadedProducts.first else {
                  self.requestState = .failed(StoreError.missingProduct)
                  return
              }

              if response.invalidProductIdentifiers.isEmpty == false {
                  print("ALERT: Received invalid product identifiers: \(response.invalidProductIdentifiers)")
                  self.requestState = .failed(StoreError.invalidIdentifiers)
                  return
              }

              self.requestState = .loaded(unlock)
          }
    }
    
    func buy(product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    func restore() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}
