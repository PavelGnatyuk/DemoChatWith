import SwiftUI

struct ChatView: View {
    @State private var chatState = ChatViewState()
    
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
            }
            
            // Input view
            ChatInputView(
                text: Binding(
                    get: { chatState.inputState.text },
                    set: { newText in
                        chatState = chatState.updateInputText(newText)
                    }
                ),
                onSend: sendMessage
            )
        }
        .background(Color(.systemBackground))
    }
    
    // Pure function for sending messages
    private func sendMessage() {
        if let newState = chatState.sendMessage() {
            chatState = newState
        }
    }
}

#Preview {
    ChatView()
} 