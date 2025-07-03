//
//  CompletionsChatView.swift
//  DemoChatWith
//
//  Created by Pavel Gnatyuk on 02/07/2025.
//

import SwiftUI

struct CompletionsChatView: View {
    @State private var chatState = ChatViewState()
    @FocusState private var isInputFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Messages list
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(chatState.messages) { message in
                            ChatBubbleView(message: message)
                                .id(message.id)
                        }
                    }
                    .padding(.vertical, 8)
                }
                .onChange(of: chatState.messages.count) { _, _ in
                    // Scroll to bottom when new message is added
                    if let lastMessage = chatState.messages.last {
                        withAnimation(.easeOut(duration: 0.3)) {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
                .gesture(
                    // Tap gesture to dismiss keyboard
                    TapGesture()
                        .onEnded { _ in
                            isInputFocused = false
                        }
                )
                .gesture(
                    // Swipe down gesture to dismiss keyboard
                    DragGesture(minimumDistance: 20, coordinateSpace: .local)
                        .onEnded { value in
                            if value.translation.height > 0 && abs(value.translation.width) < abs(value.translation.height) {
                                isInputFocused = false
                            }
                        }
                )
            }
            
            // Input view
            ChatInputView(
                text: Binding(
                    get: { chatState.inputState.text },
                    set: { newText in
                        chatState = chatState.updateInputText(newText)
                    }
                ),
                isInputFocused: $isInputFocused,
                onSend: sendMessage
            )
        }
        .background(Color(.systemBackground))
        .onAppear {
            // Auto-focus the input field when the view appears
            isInputFocused = true
        }
    }
    
    // Pure function for sending messages
    private func sendMessage() {
        if let newState = chatState.sendMessage() {
            chatState = newState
            // Keep the input field focused after sending
            isInputFocused = true

            // Call the API after sending the user message
            Task {
                await fetchAssistantResponse()
            }
        }
    }

    private func fetchAssistantResponse() async {
        do {
            let response = try await OpenAIClient.shared.sendChatRequest(messages: chatState.apiMessages)
            if let reply = response.content {
                // Update chat state with assistant's reply on the main thread
                await MainActor.run {
                    chatState = chatState.addAssistantMessage(reply)
                }
            }
        } catch {
            // Optionally, handle error (e.g., show error message in chat)
            print("API error: \(error.localizedDescription)")
        }
    }
}

#Preview {
    CompletionsChatView()
} 