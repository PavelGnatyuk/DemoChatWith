import Foundation

/// Configuration constants for OpenAI API communication
struct APIConfiguration {
    
    // MARK: - API Endpoints
    static let baseURL = "https://api.openai.com/v1"
    static let chatEndpoint = "/chat/completions"
    static let responsesEndpoint = "/responses"
    
    // MARK: - Model Configuration
    static let defaultModel = "gpt-3.5-turbo"
    static let defaultTemperature: Double = 0.7
    static let defaultMaxTokens = 1000
    
    // MARK: - Request Configuration
    static let requestTimeout: TimeInterval = 30.0
    static let maxRetries = 3
    
    // MARK: - Headers
    static let contentType = "application/json"
    static let authorizationHeader = "Authorization"
    static let authorizationPrefix = "Bearer "
    
    // MARK: - Error Messages
    static let networkErrorMessage = "Network connection error. Please check your internet connection."
    static let authenticationErrorMessage = "Authentication failed. Please check your API key."
    static let invalidResponseMessage = "Invalid response from server."
    static let rateLimitMessage = "Rate limit exceeded. Please try again later."
    static let serverErrorMessage = "Server error. Please try again later."
    
    // MARK: - Validation
    static let minMessageLength = 1
    static let maxMessageLength = 4000
    static let maxConversationLength = 50
} 