import Foundation

/// Custom error types for API communication
enum APIError: Error, LocalizedError, Equatable {
    
    // MARK: - Network Errors
    case networkError(NetworkError)
    case timeout
    case noInternetConnection
    
    // MARK: - API Errors
    case apiError(OpenAIError)
    case authenticationFailed
    case rateLimitExceeded
    case invalidRequest
    case serverError
    
    // MARK: - Response Errors
    case invalidResponse
    case decodingError
    case emptyResponse
    
    // MARK: - Configuration Errors
    case missingAPIKey
    case invalidAPIKey
    
    // MARK: - LocalizedError Implementation
    var errorDescription: String? {
        switch self {
        case .networkError(let networkError):
            return networkError.localizedDescription
        case .timeout:
            return "Request timed out. Please try again."
        case .noInternetConnection:
            return "No internet connection. Please check your network."
        case .apiError(let openAIError):
            return openAIError.message
        case .authenticationFailed:
            return APIConfiguration.authenticationErrorMessage
        case .rateLimitExceeded:
            return APIConfiguration.rateLimitMessage
        case .invalidRequest:
            return "Invalid request. Please check your input."
        case .serverError:
            return APIConfiguration.serverErrorMessage
        case .invalidResponse:
            return APIConfiguration.invalidResponseMessage
        case .decodingError:
            return "Failed to process server response."
        case .emptyResponse:
            return "Received empty response from server."
        case .missingAPIKey:
            return "API key is missing. Please configure your API key."
        case .invalidAPIKey:
            return "Invalid API key format."
        }
    }
}

/// Network-specific errors
enum NetworkError: Error, LocalizedError, Equatable {
    case connectionFailed
    case invalidURL
    case httpError(Int)
    case unknown
    
    var localizedDescription: String {
        switch self {
        case .connectionFailed:
            return APIConfiguration.networkErrorMessage
        case .invalidURL:
            return "Invalid URL format."
        case .httpError(let code):
            return "HTTP error: \(code)"
        case .unknown:
            return "Unknown network error occurred."
        }
    }
}

/// OpenAI API-specific error response
struct OpenAIError: Codable, Equatable {
    let error: OpenAIErrorDetail
    
    struct OpenAIErrorDetail: Codable, Equatable {
        let message: String
        let type: String?
        let code: String?
    }
    
    var message: String {
        return error.message
    }
}

/// HTTP status codes for error handling
enum HTTPStatusCode: Int {
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case tooManyRequests = 429
    case internalServerError = 500
    case badGateway = 502
    case serviceUnavailable = 503
    
    var isClientError: Bool {
        return (400...499).contains(rawValue)
    }
    
    var isServerError: Bool {
        return (500...599).contains(rawValue)
    }
} 