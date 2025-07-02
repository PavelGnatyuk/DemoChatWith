//
//  ContentView.swift
//  DemoChatWith
//
//  Created by Pavel Gnatyuk on 02/07/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ChatView()
            .navigationTitle("DemoChatWith")
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        ContentView()
    }
}
