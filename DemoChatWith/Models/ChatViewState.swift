import Foundation

struct ChatViewState {
    var messages: [ChatMessage] = []
    var inputState = ChatInputState()
    
    // Pure functions for state management
    func addMessage(_ message: ChatMessage) -> ChatViewState {
        var newState = self
        newState.messages.append(message)
        return newState
    }
    
    func clearInput() -> ChatViewState {
        var newState = self
        newState.inputState = newState.inputState.clearInput()
        return newState
    }
    
    func updateInputText(_ text: String) -> ChatViewState {
        var newState = self
        newState.inputState.text = text
        return newState
    }
    
    func sendMessage() -> ChatViewState? {
        guard let message = inputState.createUserMessage() else { return nil }
        return addMessage(message).clearInput()
    }
}

// MARK: - OpenAI API Integration Helpers
extension ChatViewState {
    // Convert local messages to API messages
    var apiMessages: [Message] {
        messages.map { msg in
            Message(
                role: msg.isUser ? .user : .assistant,
                content: msg.text
            )
        }
    }

    // Add an assistant message to the chat
    func addAssistantMessage(_ text: String) -> ChatViewState {
        var newState = self
        let assistantMessage = ChatMessage(
            text: text,
            isUser: false,
            timestamp: Date()
        )
        newState.messages.append(assistantMessage)
        return newState
    }
} 