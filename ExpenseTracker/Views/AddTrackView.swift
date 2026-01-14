//
//  AddTrackView.swift
//  ExpenseTracker
//
//  Created by Martin Hrbáček on 12.01.2026.
//

import SwiftUI
import SwiftData
import Combine

struct AddTrackView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @State private var trackVM = TrackViewModel(category: .personal)
    
    @FocusState private var focusField: FocusField?
    
    var body: some View {
        Form {
            Section {
                TextField("Type your track", text: $trackVM.title)
                    .focused($focusField, equals: .string)
                    .autocorrectionDisabled()
                    .onReceive(Just(self.trackVM.title)) { inputValue in
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
                        trackVM.amountString = trackVM.decimalSeparator(newValue: newValue, oldValue: oldValue)
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
                Toggle("Date (optiona)", isOn: $trackVM.isDateOn)
                
                if trackVM.isDateOn {
                    DatePicker("Select date", selection: $trackVM.date)
                        .datePickerStyle(.compact)
                }
            } header: {
                Text("Date")
            }
        }
        .onAppear {
            focusField = .string
            UITextField.appearance().clearButtonMode = .whileEditing
        }
        .onTapGesture {
            focusField = nil
        }
        .navigationTitle("Add track")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    let trimmedTitle = trackVM.trimmedTitle()
                    guard let number = trackVM.formattedAmount().number(from: trackVM.amountString) else { return }
                    let amountDecimal = number.decimalValue
                    let newTrack = Track(title: trimmedTitle, amount: amountDecimal, category: trackVM.category, date: trackVM.isDateOn ? trackVM.date : nil)
                    context.insert(newTrack)
                    do {
                        try context.save()
                    } catch {
                        print("Error: \(error.localizedDescription)")
                    }
                    dismiss()
                } label: {
                    Text("Save")
                }
                .disabled(!trackVM.isFormValidate())
            }
        }
    }
}

#Preview {
    NavigationStack {
        AddTrackView()
            .modelContainer(for: Track.self, inMemory: false)
    }
}
