import Foundation

/// Message role types for OpenAI API
enum MessageRole: String, Codable, CaseIterable {
    case system = "system"
    case user = "user"
    case assistant = "assistant"
}

/// Individual message in a conversation
struct Message: Codable, Equatable, Identifiable {
    let id = UUID()
    let role: MessageRole
    let content: String
    
    init(role: MessageRole, content: String) {
        self.role = role
        self.content = content
    }
    
    // MARK: - Codable Implementation
    enum CodingKeys: String, CodingKey {
        case role, content
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        role = try container.decode(MessageRole.self, forKey: .role)
        content = try container.decode(String.self, forKey: .content)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(role, forKey: .role)
        try container.encode(content, forKey: .content)
    }
}

/// Main request structure for OpenAI Chat API
struct OpenAIRequest: Codable, Equatable {
    let model: String
    let messages: [Message]
    let temperature: Double?
    let max_tokens: Int?
    let top_p: Double?
    let frequency_penalty: Double?
    let presence_penalty: Double?
    let stream: Bool?

    enum CodingKeys: String, CodingKey {
        case model, messages, temperature, max_tokens, top_p, frequency_penalty, presence_penalty, stream
    }

    init(
        model: String = APIConfiguration.defaultModel,
        messages: [Message],
        temperature: Double? = APIConfiguration.defaultTemperature,
        max_tokens: Int? = APIConfiguration.defaultMaxTokens,
        top_p: Double? = nil,
        frequency_penalty: Double? = nil,
        presence_penalty: Double? = nil,
        stream: Bool? = false
    ) {
        self.model = model
        self.messages = messages
        self.temperature = temperature
        self.max_tokens = max_tokens
        self.top_p = top_p
        self.frequency_penalty = frequency_penalty
        self.presence_penalty = presence_penalty
        self.stream = stream
    }

    // MARK: - Validation
    var isValid: Bool {
        guard !messages.isEmpty else { return false }
        for message in messages {
            if message.content.count < APIConfiguration.minMessageLength ||
               message.content.count > APIConfiguration.maxMessageLength {
                return false
            }
        }
        if messages.count > APIConfiguration.maxConversationLength {
            return false
        }
        return true
    }

    // MARK: - Utility Methods
    func addingMessage(_ message: Message) -> OpenAIRequest {
        return OpenAIRequest(
            model: self.model,
            messages: self.messages + [message],
            temperature: self.temperature,
            max_tokens: self.max_tokens,
            top_p: self.top_p,
            frequency_penalty: self.frequency_penalty,
            presence_penalty: self.presence_penalty,
            stream: self.stream
        )
    }
} 