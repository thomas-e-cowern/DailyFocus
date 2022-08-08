//
//  PurchaseButton.swift
//  DailyFocus
//
//  Created by Thomas Cowern New on 8/8/22.
//

import SwiftUI

struct PurchaseButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 200, height: 44)
            .background(Color("Light Blue"))
            .clipShape(Capsule())
            .foregroundColor(.white)
            .opacity(configuration.isPressed ? 0.5 : 1)
    }
}
