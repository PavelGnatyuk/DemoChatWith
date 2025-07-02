import Foundation

/// Handles HTTP network requests with proper error handling
class NetworkManager {
    
    // MARK: - Singleton
    static let shared = NetworkManager()
    private init() {}
    
    // MARK: - HTTP Request
    func performRequest<T: Codable>(
        url: URL,
        method: HTTPMethod = .GET,
        headers: [String: String] = [:],
        body: Data? = nil
    ) async throws -> T {
        
        // Create URL request
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.timeoutInterval = APIConfiguration.requestTimeout
        
        // Add headers
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // Add body if provided
        if let body = body {
            request.httpBody = body
        }
        
        // Perform request
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Validate response
        try validateResponse(response)
        
        // Decode response
        return try decodeResponse(data)
    }
    
    // MARK: - Response Validation
    private func validateResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.networkError(.unknown)
        }
        
        // Check for client errors (4xx)
        if httpResponse.statusCode >= 400 && httpResponse.statusCode < 500 {
            switch httpResponse.statusCode {
            case 401:
                throw APIError.authenticationFailed
            case 403:
                throw APIError.authenticationFailed
            case 429:
                throw APIError.rateLimitExceeded
            default:
                throw APIError.invalidRequest
            }
        }
        
        // Check for server errors (5xx)
        if httpResponse.statusCode >= 500 {
            throw APIError.serverError
        }
        
        // Check for success (2xx)
        guard httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
            throw APIError.networkError(.httpError(httpResponse.statusCode))
        }
    }
    
    // MARK: - Response Decoding
    private func decodeResponse<T: Codable>(_ data: Data) throws -> T {
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            // Try to decode as OpenAI error first
            if let openAIError = try? JSONDecoder().decode(OpenAIError.self, from: data) {
                throw APIError.apiError(openAIError)
            }
            
            // If not an OpenAI error, throw decoding error
            throw APIError.decodingError
        }
    }
    
    // MARK: - Utility Methods
    func createURL(endpoint: String) -> URL? {
        return URL(string: APIConfiguration.baseURL + endpoint)
    }
    
    func createHeaders(apiKey: String) -> [String: String] {
        return [
            APIConfiguration.authorizationHeader: APIConfiguration.authorizationPrefix + apiKey,
            "Content-Type": APIConfiguration.contentType
        ]
    }
    
    func encodeRequest<T: Codable>(_ request: T) throws -> Data {
        let encoder = JSONEncoder()
        return try encoder.encode(request)
    }
}

// MARK: - HTTP Method Enum
enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
    case PATCH = "PATCH"
} 