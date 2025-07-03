//
//  MainTabView.swift
//  DemoChatWith
//
//  Created by Pavel Gnatyuk on 02/07/2025.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            CompletionsChatView()
                .tabItem {
                    Image(systemName: "message.fill")
                    Text("Completions")
                }
            
            ResponsesChatView()
                .tabItem {
                    Image(systemName: "message.badge.waveform.fill")
                    Text("Responses")
                }
        }
        .navigationTitle("DemoChatWith")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        MainTabView()
    }
} 