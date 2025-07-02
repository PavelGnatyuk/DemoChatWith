import Foundation

/// Main client for interacting with OpenAI's Chat API
class OpenAIClient {
    static let shared = OpenAIClient()
    private init() {}
    
    // MARK: - Send Chat Request
    func sendChatRequest(
        messages: [Message],
        model: String = APIConfiguration.defaultModel,
        temperature: Double? = APIConfiguration.defaultTemperature,
        max_tokens: Int? = APIConfiguration.defaultMaxTokens,
        top_p: Double? = nil,
        frequency_penalty: Double? = nil,
        presence_penalty: Double? = nil,
        stream: Bool? = false
    ) async throws -> OpenAIResponse {
        // 1. Get API key
        let apiKey = APIKeyManager.shared.getAPIKey()
        guard APIKeyManager.shared.validateAPIKey(apiKey) else {
            throw APIError.missingAPIKey
        }
        
        // 2. Build request
        guard let url = NetworkManager.shared.createURL(endpoint: APIConfiguration.chatEndpoint) else {
            throw APIError.networkError(.invalidURL)
        }
        let headers = NetworkManager.shared.createHeaders(apiKey: apiKey)
        let openAIRequest = OpenAIRequest(
            model: model,
            messages: messages,
            temperature: temperature,
            max_tokens: max_tokens,
            top_p: top_p,
            frequency_penalty: frequency_penalty,
            presence_penalty: presence_penalty,
            stream: stream
        )
        let requestBody = try NetworkManager.shared.encodeRequest(openAIRequest)
        
        // 3. Perform request
        let response: OpenAIResponse = try await NetworkManager.shared.performRequest(
            url: url,
            method: .POST,
            headers: headers,
            body: requestBody
        )
        
        // 4. Validate response
        guard response.isValid else {
            throw APIError.invalidResponse
        }
        
        return response
    }
    
    // MARK: - Streaming Support (Future)
    // func sendStreamingChatRequest(...) async throws -> AsyncStream<StreamingResponse> { ... }
} 