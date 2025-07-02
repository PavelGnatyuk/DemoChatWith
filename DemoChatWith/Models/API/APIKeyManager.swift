import Foundation
import Security

/// Manages secure storage and retrieval of API keys
class APIKeyManager {
    
    // MARK: - Singleton
    static let shared = APIKeyManager()
    private init() {}
    
    // MARK: - Constants
    private let keychainService = "com.demoChatWith.openai"
    private let keychainAccount = "apiKey"
    private static let environmentKey = "OPENAI_API_KEY"
    
    // MARK: - API Key Retrieval
    func getAPIKey() -> String {
        // Priority order: Keychain > Environment > Config File
        if let keychainKey = getAPIKeyFromKeychain() {
            return keychainKey
        }
        
        if let environmentKey = getAPIKeyFromEnvironment() {
            return environmentKey
        }
        
        if let configKey = getAPIKeyFromConfig() {
            return configKey
        }
        
        return ""
    }
    
    // MARK: - Keychain Storage
    func saveAPIKeyToKeychain(_ apiKey: String) -> Bool {
        guard !apiKey.isEmpty else { return false }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: keychainAccount,
            kSecValueData as String: apiKey.data(using: .utf8)!
        ]
        
        // Delete existing key first
        SecItemDelete(query as CFDictionary)
        
        // Add new key
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    private func getAPIKeyFromKeychain() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: keychainAccount,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let data = result as? Data,
              let apiKey = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        return apiKey
    }
    
    // MARK: - Environment Variables
    private func getAPIKeyFromEnvironment() -> String? {
        print("All env vars: \(ProcessInfo.processInfo.environment)")
        print("API key from env: \(ProcessInfo.processInfo.environment[Self.environmentKey] ?? "nil")")
        return ProcessInfo.processInfo.environment[Self.environmentKey]
    }
    
    // MARK: - Configuration File (Development Only)
    private func getAPIKeyFromConfig() -> String? {
        // For development, you can create a Config.plist file
        // This should NOT be committed to git
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let config = NSDictionary(contentsOfFile: path),
              let apiKey = config["OpenAIAPIKey"] as? String else {
            return nil
        }
        
        return apiKey
    }
    
    // MARK: - Validation
    func validateAPIKey(_ apiKey: String) -> Bool {
        // Basic validation: starts with "sk-" and has reasonable length
        return apiKey.hasPrefix("sk-") && apiKey.count > 20
    }
    
    func isAPIKeyConfigured() -> Bool {
        let apiKey = getAPIKey()
        return !apiKey.isEmpty && validateAPIKey(apiKey)
    }
    
    // MARK: - Clear API Key
    func clearAPIKey() -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: keychainAccount
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess || status == errSecItemNotFound
    }
} 
