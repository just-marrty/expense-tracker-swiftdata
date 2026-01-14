//
//  ContentView.swift
//  ExpenseTracker
//
//  Created by Martin Hrbáček on 12.01.2026.
//

import SwiftUI
import SwiftData

struct TrackMainView: View {
    
    @Environment(\.modelContext) private var context
    
    @Query private var tracks: [Track]
    
    @State private var showTrackUpdate: Track? = nil
    
    var body: some View {
        NavigationStack {
            List(tracks) { track in
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Text("Title:")
                            Text(track.title)
                                .lineLimit(1)
                                .foregroundStyle(.secondary)
                        }
                        
                        HStack {
                            Text("Amount:")
                            Text(track.amount as NSNumber, formatter: NumberFormatter.currency)
                                .foregroundStyle(.secondary)
                        }
                        
                        HStack {
                            Text("Date:")
                            Text(track.date?.formatted() ?? "No date")
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 5) {
                        Text("Category:")
                        Text(track.category.rawValue)
                            .foregroundStyle(.secondary)
                    }
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Rectangle()
                    .fill(Color.gray.opacity(0.3))
                )
                .listRowInsets(EdgeInsets(top: 10, leading: 25, bottom: 10, trailing: 25))
                .swipeActions(edge: .trailing) {
                    Button {
                        showTrackUpdate = track
                    } label: {
                        Image(systemName: "pencil")
                    }
                }
                .swipeActions(edge: .leading) {
                    Button {
                        context.delete(track)
                        do {
                            try context.save()
                        } catch {
                            print("Error: \(error.localizedDescription)")
                        }
                    } label: {
                        Image(systemName: "trash.fill")
                    }
                    .tint(.red.opacity(0.7))
                }
            }
            .listRowSpacing(10)
            .sheet(item: $showTrackUpdate) { track in
                NavigationStack {
                    TrackUpdateView(track: track)
                }
            }
            .navigationTitle("My Tracks")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        AddTrackView()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .navigationDestination(for: Track.self) { track in
                TrackUpdateView(track: track)
            }
        }
    }
}

#Preview {
    TrackMainView()
        .modelContainer(for: Track.self, inMemory: false)
}
