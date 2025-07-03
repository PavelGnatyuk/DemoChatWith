//
//  StreamViewModel.swift
//  DemoChatWith
//
//  Handles streaming Responses API for the Stream tab
//

import Foundation
import SwiftUI

@MainActor
class StreamViewModel: ObservableObject {
    @Published var chatState = ChatViewState()
    
    // Update input text
    func updateInputText(_ text: String) {
        chatState = chatState.updateInputText(text)
    }
    
    // Send message and start streaming
    func sendMessageStreaming() {
        guard let newState = chatState.sendMessage() else { return }
        let userInput = newState.messages.last?.text ?? ""
        chatState = newState
        Task {
            await streamAssistantResponse(userInput: userInput)
        }
    }
    
    // Streaming logic
    private func streamAssistantResponse(userInput: String) async {
        // Add a placeholder assistant message to update in real-time
        let assistantMessage = ChatMessage(text: "", isUser: false, timestamp: Date())
        chatState = chatState.addMessage(assistantMessage)
        let assistantIndex = chatState.messages.count - 1
        
        do {
            // Build request
            let apiKey = APIKeyManager.shared.getAPIKey()
            print("[DEBUG] Streaming API key: \(apiKey ?? "nil")")
            guard APIKeyManager.shared.validateAPIKey(apiKey) else { return }
            guard let url = NetworkManager.shared.createURL(endpoint: APIConfiguration.responsesEndpoint) else { return }
            let headers = NetworkManager.shared.createHeaders(apiKey: apiKey)
            let requestBody: [String: Any] = [
                "model": "gpt-4.1",
                "input": userInput,
                "stream": true
            ]
            let bodyData = try JSONSerialization.data(withJSONObject: requestBody)
            
            // Create streaming request
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.timeoutInterval = APIConfiguration.requestTimeout
            for (key, value) in headers { request.setValue(value, forHTTPHeaderField: key) }
            request.httpBody = bodyData
            
            // Start streaming
            let (bytes, _) = try await URLSession.shared.bytes(for: request)
            var accumulated = ""
            for try await line in bytes.lines {
                print("Raw line: \(line)")
                let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !trimmed.isEmpty else { continue }
                // Try to parse as JSON chunk
                if let chunk = parseStreamChunk(trimmed) {
                    accumulated += chunk
                    print("Chunk: \(chunk)")
                    print("Accumulated: \(accumulated)")
                    
                    // Update the assistant message with accumulated text
                    await MainActor.run {
                        // Create a new message with the accumulated text
                        let updatedMessage = ChatMessage(
                            text: accumulated,
                            isUser: false,
                            timestamp: chatState.messages[assistantIndex].timestamp
                        )
                        
                        // Create a new state with the updated message
                        var newMessages = chatState.messages
                        newMessages[assistantIndex] = updatedMessage
                        
                        // Update the entire chat state to trigger UI refresh
                        chatState = ChatViewState(
                            messages: newMessages,
                            inputState: chatState.inputState
                        )
                    }
                }
            }
        } catch {
            print("Streaming error: \(error)")
        }
    }
    
    // Parse a streaming chunk (extract text from JSON)
    private func parseStreamChunk(_ line: String) -> String? {
        var jsonLine = line
        if jsonLine.hasPrefix("data: ") {
            jsonLine = String(jsonLine.dropFirst(6))
        }
        if jsonLine == "[DONE]" { return nil }
        
        // Parse the actual Responses API streaming structure
        struct StreamChunk: Decodable {
            let type: String?
            let delta: String?
        }
        
        if let data = jsonLine.data(using: .utf8),
           let chunk = try? JSONDecoder().decode(StreamChunk.self, from: data),
           chunk.type == "response.output_text.delta",
           let delta = chunk.delta {
            return delta
        }
        return nil
    }
} 