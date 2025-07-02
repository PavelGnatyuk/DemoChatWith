import Foundation

/// Individual choice in OpenAI response
struct Choice: Codable, Equatable, Identifiable {
    let id = UUID()
    let index: Int
    let message: ResponseMessage
    let finishReason: String?
    
    // MARK: - Codable Implementation
    enum CodingKeys: String, CodingKey {
        case index, message, finishReason = "finish_reason"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        index = try container.decode(Int.self, forKey: .index)
        message = try container.decode(ResponseMessage.self, forKey: .message)
        finishReason = try container.decodeIfPresent(String.self, forKey: .finishReason)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(index, forKey: .index)
        try container.encode(message, forKey: .message)
        try container.encodeIfPresent(finishReason, forKey: .finishReason)
    }
}

/// Message content in OpenAI response
struct ResponseMessage: Codable, Equatable {
    let role: MessageRole
    let content: String
    
    // MARK: - Utility Methods
    func toMessage() -> Message {
        return Message(role: role, content: content)
    }
}

/// Token usage information
struct Usage: Codable, Equatable {
    let promptTokens: Int
    let completionTokens: Int
    let totalTokens: Int
    
    // MARK: - Codable Implementation
    enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        promptTokens = try container.decode(Int.self, forKey: .promptTokens)
        completionTokens = try container.decode(Int.self, forKey: .completionTokens)
        totalTokens = try container.decode(Int.self, forKey: .totalTokens)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(promptTokens, forKey: .promptTokens)
        try container.encode(completionTokens, forKey: .completionTokens)
        try container.encode(totalTokens, forKey: .totalTokens)
    }
}

/// Main response structure from OpenAI Chat API
struct OpenAIResponse: Codable, Equatable {
    let id: String
    let object: String
    let created: Int
    let model: String
    let choices: [Choice]
    let usage: Usage
    
    // MARK: - Utility Methods
    var firstChoice: Choice? {
        return choices.first
    }
    
    var firstMessage: ResponseMessage? {
        return firstChoice?.message
    }
    
    var content: String? {
        return firstMessage?.content
    }
    
    var isComplete: Bool {
        return firstChoice?.finishReason == "stop"
    }
    
    var isTruncated: Bool {
        return firstChoice?.finishReason == "length"
    }
    
    // MARK: - Validation
    var isValid: Bool {
        return !choices.isEmpty && 
               firstMessage != nil && 
               !(firstMessage?.content.isEmpty ?? true)
    }
}

/// Streaming response chunk for real-time responses
struct StreamingResponse: Codable, Equatable {
    let id: String?
    let object: String?
    let created: Int?
    let model: String?
    let choices: [StreamingChoice]?
    
    struct StreamingChoice: Codable, Equatable {
        let index: Int
        let delta: ResponseMessage?
        let finishReason: String?
        
        enum CodingKeys: String, CodingKey {
            case index, delta, finishReason = "finish_reason"
        }
    }
    
    var isDone: Bool {
        return choices?.first?.finishReason != nil
    }
    
    var content: String? {
        return choices?.first?.delta?.content
    }
} 