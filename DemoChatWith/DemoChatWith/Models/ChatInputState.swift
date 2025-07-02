import Foundation

struct ChatInputState {
    var text: String = ""
    
    var isInputValid: Bool {
        !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    // Pure function to create message
    func createUserMessage() -> ChatMessage? {
        guard isInputValid else { return nil }
        return ChatMessage(
            text: text.trimmingCharacters(in: .whitespacesAndNewlines),
            isUser: true,
            timestamp: Date()
        )
    }
    
    // Pure function to clear input
    func clearInput() -> ChatInputState {
        var newState = self
        newState.text = ""
        return newState
    }
} 