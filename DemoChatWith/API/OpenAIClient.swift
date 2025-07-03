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
    
    // MARK: - Send Responses Request
    // New request model for /responses endpoint
    struct OpenAIResponsesRequest: Encodable {
        let model: String
        let input: String
    }
    
    // Model for /responses endpoint response
    struct OpenAIResponsesAPIResponse: Codable {
        struct Output: Codable {
            struct Content: Codable {
                let text: String
            }
            let content: [Content]
        }
        let output: [Output]
    }
    
    // Simple struct for UI
    struct ResponsesReply {
        let content: String?
    }
    
    func sendResponsesRequest(
        input: String,
        model: String = "gpt-4.1"
    ) async throws -> ResponsesReply {
        // 1. Get API key
        let apiKey = APIKeyManager.shared.getAPIKey()
        guard APIKeyManager.shared.validateAPIKey(apiKey) else {
            throw APIError.missingAPIKey
        }
        
        // 2. Build request
        guard let url = NetworkManager.shared.createURL(endpoint: APIConfiguration.responsesEndpoint) else {
            throw APIError.networkError(.invalidURL)
        }
        let headers = NetworkManager.shared.createHeaders(apiKey: apiKey)
        let openAIRequest = OpenAIResponsesRequest(
            model: model,
            input: input
        )
        let requestBody = try JSONEncoder().encode(openAIRequest)
        
        // --- DEBUG LOGGING ---
        if let requestBodyString = String(data: requestBody, encoding: .utf8) {
            print("\n[DEBUG] OpenAI Responses API Request:")
            print("URL: \(url)")
            print("Headers: \(headers)")
            print("Body: \(requestBodyString)\n")
        }
        // --- END DEBUG LOGGING ---
        
        // 3. Perform request and decode
        let response: OpenAIResponsesAPIResponse = try await NetworkManager.shared.performRequest(
            url: url,
            method: .POST,
            headers: headers,
            body: requestBody
        )
        
        // 4. Extract reply text
        let reply = response.output.first?.content.first?.text
        return ResponsesReply(content: reply)
    }
    
    // MARK: - Streaming Support (Future)
    // func sendStreamingChatRequest(...) async throws -> AsyncStream<StreamingResponse> { ... }
} 
