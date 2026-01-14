//
//  TrackUpdateView.swift
//  ExpenseTracker
//
//  Created by Martin Hrbáček on 12.01.2026.
//

import SwiftUI
import SwiftData
import Combine

struct TrackUpdateView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @State private var trackVM = TrackViewModel(category: .personal)
    
    @FocusState private var focusField: FocusField?
    
    let track: Track
    
    var body: some View {
        Form {
            Section {
                TextField("Type your track", text: $trackVM.title)
                    .focused($focusField, equals: .string)
                    .autocorrectionDisabled()
                    .onReceive(Just(trackVM.title)) { inputValue in
                        if inputValue.count > 15 {
                            self.trackVM.title.removeLast()
                        }
                    }
            } header: {
                Text("Title")
            } footer: {
                if !trackVM.isTitleRowValid() {
                    Text("Title must be filled!")
                        .foregroundStyle(.red.opacity(0.8))
                } else {
                    Text("Approved!")
                        .foregroundStyle(.green.opacity(0.8))
                }
            }
            
            Section {
                TextField("Type your amount", text: $trackVM.amountString)
                    .focused($focusField, equals: .decimal)
                    .keyboardType(.decimalPad)
                    .onChange(of: trackVM.amountString) { oldValue, newValue in
                        if !trackVM.isLoadingAmountValues {
                            trackVM.amountString = trackVM.decimalSeparator(newValue: newValue, oldValue: oldValue)
                        }
                    }
            } header: {
                Text("Amount")
            } footer: {
                if !trackVM.isAmountRowValid() {
                    Text("Title must be filled! Only numbers , and . are allowed!")
                        .foregroundStyle(.red.opacity(0.8))
                } else {
                    Text("Approved!")
                        .foregroundStyle(.green.opacity(0.8))
                }
            }
            
            Section {
                Picker("Choose category", selection: $trackVM.category) {
                    ForEach(TrackCategory.allCases, id: \.self) { category in
                        Text(category.rawValue)
                            .tag(category)
                    }
                }
                .pickerStyle(.menu)
            } header: {
                Text("Category")
            }
            
            Section {
                Toggle("Choose date (optiona)", isOn: $trackVM.isDateOn)
                
                if trackVM.isDateOn {
                    DatePicker("Choose date", selection: $trackVM.date)
                        .datePickerStyle(.compact)
                }
            } header: {
                Text("Date")
            }
        }
        .onAppear {
            focusField = .string
            UITextField.appearance().clearButtonMode = .whileEditing
            
            trackVM.isLoadingAmountValues = true
            
            trackVM.title = track.title
            
            let formatter = trackVM.formattedAmount()
            trackVM.amountString = formatter.string(from: track.amount as NSDecimalNumber) ?? ""
            
            trackVM.category = track.category
            
            if let savedDate = track.date {
                trackVM.isDateOn = true
                trackVM.date = savedDate
            } else {
                trackVM.isDateOn = false
            }
            
            trackVM.isLoadingAmountValues = false
        }
        .onTapGesture {
            focusField = nil
        }
        .navigationTitle("Update track")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    let trimmingTitle = trackVM.trimmedTitle()
                    guard let number = trackVM.formattedAmount().number(from: trackVM.amountString) else { return }
                    let decimalAmount = number.decimalValue
                    track.title = trimmingTitle
                    track.amount = decimalAmount
                    track.category = trackVM.category
                    track.date = trackVM.isDateOn ? trackVM.date : nil
                    do {
                        try context.save()
                    } catch {
                        print("Error: \(error.localizedDescription)")
                    }
                    dismiss()
                } label: {
                    Text("Update")
                }
                .disabled(!trackVM.isFormValidate())
            }
        }
    }
}

#Preview {
    NavigationStack {
        TrackUpdateView(track: Track(title: "", amount: 0, category: TrackCategory.personal, date: .now))
            .modelContainer(for: Track.self, inMemory: false)
    }
}
