//
//  ContentView.swift
//  OutcomeTracker
//
//  Created by Martin Hrbáček on 12.01.2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) private var context
    
    @Query private var tracks: [Track]
    
    var body: some View {
        NavigationStack {
            List(tracks) { track in
                NavigationLink(value: track) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(track.title)
                        Text(track.amount)
                        Text(track.category.rawValue)
                    }
                    .swipeActions(edge: .trailing) {
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
    ContentView()
        .modelContainer(for: Track.self, inMemory: false)
}
