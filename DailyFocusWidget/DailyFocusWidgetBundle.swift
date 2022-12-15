//
//  DailyFocusWidgetBundle.swift
//  DailyFocusWidget
//
//  Created by Thomas Cowern on 12/9/22.
//

import WidgetKit
import SwiftUI

@main
struct DaikyFocusWidgets: WidgetBundle {
    var body: some Widget {
        SimpleDailyFocusWidget()
        ComplexDailyFocusWidget()
    }
}
