//
//  TrackViewModel.swift
//  OutcomeTracker
//
//  Created by Martin Hrbáček on 13.01.2026.
//

import Foundation
import Observation

@Observable
@MainActor
class TrackViewModel {
    var title: String = ""
    var amountString: String = ""
    var category: TrackCategory
    var date: Date = Date()
    
    var isLoadingAmountValues: Bool = false
    var isDateOn: Bool = false
    
    init(category: TrackCategory) {
        self.category = category
    }
    
    func formattedAmount() -> NumberFormatter {
        let formattedAmount = NumberFormatter()
        formattedAmount.numberStyle = .decimal
        formattedAmount.usesGroupingSeparator = false
        formattedAmount.minimumFractionDigits = 2
        return formattedAmount
    }
    
    func decimalSeparator(newValue: String, oldValue: String) -> String {
        let separator = Locale.current.decimalSeparator ?? "."
        let escapedSeparator = NSRegularExpression.escapedPattern(for: separator)
        let pattern = #"^\d+\#(escapedSeparator)?\d?\d?$"#
        let isValidAmount = newValue.range(of: pattern, options: .regularExpression) != nil
        
        return (newValue.isEmpty || isValidAmount) ? newValue : oldValue
    }
    
    func isFormValidate() -> Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !amountString.isEmpty
    }
    
    func trimmedTitle() -> String {
        return title.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func isTitleRowValid() -> Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func isAmountRowValid() -> Bool {
        let separator = Locale.current.decimalSeparator ?? "."
        let escapedSeparator = NSRegularExpression.escapedPattern(for: separator)
        let pattern = #"^\d+\#(escapedSeparator)?\d?\d?$"#
        
        return !amountString.isEmpty || amountString.range(of: pattern, options: .regularExpression) != nil
    }
}
