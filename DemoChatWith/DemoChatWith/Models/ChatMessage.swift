import SwiftUI

struct ChatMessage: Identifiable, Equatable {
    let id = UUID()
    let text: String
    let isUser: Bool
    let timestamp: Date
    
    // Computed properties for UI
    var displayTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: timestamp)
    }
    
    var bubbleColor: Color {
        isUser ? .blue : Color(.systemGray5)
    }
    
    var textColor: Color {
        isUser ? .white : .primary
    }
    
    var alignment: Alignment {
        isUser ? .trailing : .leading
    }
} 