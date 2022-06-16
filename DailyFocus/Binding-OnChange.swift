//
//  Binding-OnChange.swift
//  DailyFocus
//
//  Created by Thomas Cowern New on 6/16/22.
//

import SwiftUI

extension Binding {
    func onChange (_ handler: @escaping () -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler()
            }
        )
    }
}
