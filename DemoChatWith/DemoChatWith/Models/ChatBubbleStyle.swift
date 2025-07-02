import SwiftUI

struct ChatBubbleStyle {
    let cornerRadius: CGFloat = 12
    let padding: EdgeInsets = EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
    let maxWidth: CGFloat = 280
    let shadowRadius: CGFloat = 2
    let shadowOpacity: Double = 0.1
    
    // Pure function for bubble styling
    func applyStyle(to message: ChatMessage) -> some View {
        Text(message.text)
            .foregroundColor(message.textColor)
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(message.bubbleColor)
                    .shadow(
                        color: .black.opacity(shadowOpacity),
                        radius: shadowRadius,
                        x: 0,
                        y: 1
                    )
            )
            .frame(maxWidth: maxWidth, alignment: message.alignment)
    }
    
    // Static instance for easy access
    static let standard = ChatBubbleStyle()
} 