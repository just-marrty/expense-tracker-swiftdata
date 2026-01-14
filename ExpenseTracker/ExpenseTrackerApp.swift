//
//  OutcomeTrackerApp.swift
//  ExpenseTracker
//
//  Created by Martin Hrbáček on 12.01.2026.
//

import SwiftUI
import SwiftData

@main
struct ExpenseTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            TrackMainView()
        }
        .modelContainer(for: Track.self, inMemory: false)
    }
}
