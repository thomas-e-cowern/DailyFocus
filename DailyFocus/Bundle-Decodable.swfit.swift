//
//  Bundle-Decodable.swfit.swift
//  DailyFocus
//
//  Created by Thomas Cowern New on 7/7/22.
//

import Foundation

extension Bundle {
    func decode<T: Decodable>(_ type: T.Type, from file: String, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate, keyCodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) -> T {
        // more will happen here
    }
}
