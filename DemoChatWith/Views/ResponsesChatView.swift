//
//  ResponsesChatView.swift
//  DemoChatWith
//
//  Created by Pavel Gnatyuk on 02/07/2025.
//

import SwiftUI

struct ResponsesChatView: View {
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
                    scrollToBottom(proxy: proxy)
                }
                .onChange(of: chatState.messages) { _, _ in
                    // Auto-scroll when any message content changes
                    scrollToBottom(proxy: proxy)
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
            let userInput = newState.messages.last?.text ?? ""
            chatState = newState
            isInputFocused = true
            Task {
                await fetchAssistantResponse(userInput: userInput)
            }
        }
    }

    private func fetchAssistantResponse(userInput: String) async {
        do {
            let response = try await OpenAIClient.shared.sendResponsesRequest(input: userInput)
            if let reply = response.content {
                await MainActor.run {
                    chatState = chatState.addAssistantMessage(reply)
                }
            }
        } catch {
            print("Responses API error: \(error.localizedDescription)")
        }
    }

    private func scrollToBottom(proxy: ScrollViewProxy) {
        if let lastMessage = chatState.messages.last {
            withAnimation(.easeOut(duration: 0.3)) {
                proxy.scrollTo(lastMessage.id, anchor: .bottom)
            }
        }
    }
}

#Preview {
    ResponsesChatView()
} 