//
//  NumberFormatter+Extensions.swift
//  OutcomeTracker
//
//  Created by Martin Hrbáček on 12.01.2026.
//

import Foundation

extension NumberFormatter {
    static var currency: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }
}
