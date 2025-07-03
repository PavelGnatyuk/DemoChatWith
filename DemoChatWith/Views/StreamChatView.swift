//
//  StreamChatView.swift
//  DemoChatWith
//
//  Created for streaming Responses API demo
//

import SwiftUI

struct StreamChatView: View {
    @StateObject private var viewModel = StreamViewModel()
    @FocusState private var isInputFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Messages list
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(viewModel.chatState.messages) { message in
                            ChatBubbleView(message: message)
                                .id(message.id)
                        }
                    }
                    .padding(.vertical, 8)
                }
                .onChange(of: viewModel.chatState.messages.count) { _, _ in
                    scrollToBottom(proxy: proxy)
                }
                .onChange(of: viewModel.chatState.messages) { _, _ in
                    // Auto-scroll when any message content changes (for streaming updates)
                    scrollToBottom(proxy: proxy)
                }
                .gesture(
                    TapGesture()
                        .onEnded { _ in
                            isInputFocused = false
                        }
                )
                .gesture(
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
                    get: { viewModel.chatState.inputState.text },
                    set: { newText in
                        viewModel.updateInputText(newText)
                    }
                ),
                isInputFocused: $isInputFocused,
                onSend: sendMessage
            )
        }
        .background(Color(.systemBackground))
        .onAppear {
            isInputFocused = true
        }
    }
    
    private func sendMessage() {
        viewModel.sendMessageStreaming()
        isInputFocused = true
    }
    
    private func scrollToBottom(proxy: ScrollViewProxy) {
        if let lastMessage = viewModel.chatState.messages.last {
            withAnimation(.easeOut(duration: 0.3)) {
                proxy.scrollTo(lastMessage.id, anchor: .bottom)
            }
        }
    }
}

#Preview {
    StreamChatView()
} 