//
//  DailyFocusWidgetBundle.swift
//  DailyFocusWidget
//
//  Created by Thomas Cowern on 12/9/22.
//

import WidgetKit
import SwiftUI

@main
struct DailyFocusWidgetBundle: WidgetBundle {
    var body: some Widget {
        SimpleDailyFocusWidget()
        DailyFocusWidgetLiveActivity()
    }
}
