import SwiftUI

enum MessageType {
    case user
    case assistant
    
    var bubbleColor: Color {
        switch self {
        case .user: return .blue
        case .assistant: return Color(.systemGray5)
        }
    }
    
    var textColor: Color {
        switch self {
        case .user: return .white
        case .assistant: return .primary
        }
    }
    
    var alignment: Alignment {
        switch self {
        case .user: return .trailing
        case .assistant: return .leading
        }
    }
    
    var iconName: String {
        switch self {
        case .user: return "person.circle.fill"
        case .assistant: return "brain.head.profile"
        }
    }
} 