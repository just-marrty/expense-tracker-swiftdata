//
//  Track.swift
//  OutcomeTracker
//
//  Created by Martin Hrbáček on 12.01.2026.
//

import Foundation
import SwiftData

enum TrackCategory: String, Codable, CaseIterable {
    case personal = "Personal"
    case hobby = "Hobby"
    case transport = "Transport"
    case food = "Food"
    case insurance = "Insurance"
    case savings = "Savings"
}

@Model
class Track {
    var title: String
    var amount: Decimal
    var category: TrackCategory
    var date: Date?
    
    init(title: String, amount: Decimal, category: TrackCategory, date: Date? = nil) {
        self.title = title
        self.amount = amount
        self.category = category
        self.date = date
    }
}
