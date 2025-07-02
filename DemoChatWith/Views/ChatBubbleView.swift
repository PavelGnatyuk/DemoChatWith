import SwiftUI

struct ChatBubbleView: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isUser {
                Spacer(minLength: 50)
            }
            
            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
                // Message bubble
                ChatBubbleStyle.standard.applyStyle(to: message)
                
                // Timestamp
                Text(message.displayTime)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 4)
            }
            
            if !message.isUser {
                Spacer(minLength: 50)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 4)
    }
}

#Preview {
    VStack(spacing: 16) {
        ChatBubbleView(message: ChatMessage(
            text: "Hello! How can I help you today?",
            isUser: false,
            timestamp: Date()
        ))
        
        ChatBubbleView(message: ChatMessage(
            text: "Hi! I'd like to know more about SwiftUI development.",
            isUser: true,
            timestamp: Date()
        ))
        
        ChatBubbleView(message: ChatMessage(
            text: "SwiftUI is Apple's modern declarative framework for building user interfaces across all Apple platforms. It's designed to be simple, powerful, and easy to learn.",
            isUser: false,
            timestamp: Date()
        ))
    }
    .padding()
} 