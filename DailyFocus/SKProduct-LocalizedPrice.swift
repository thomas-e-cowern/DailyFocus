//
//  SKProduct-LocalizedPrice.swift
//  DailyFocus
//
//  Created by Thomas Cowern New on 8/8/22.
//

import StoreKit

extension SKProduct {
    var localizedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)!
    }
}
