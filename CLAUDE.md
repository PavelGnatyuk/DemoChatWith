# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

DemoChatWith is a SwiftUI iOS chat application that integrates with OpenAI's ChatGPT API. The project follows functional programming principles and maintains a clean, modular architecture with SOLID principles.

## Development Commands

**Build the project:**
```bash
# Open in Xcode
open DemoChatWith.xcodeproj

# Build from command line
xcodebuild -project DemoChatWith.xcodeproj -scheme DemoChatWith -sdk iphoneos build
```

**Run on simulator:**
```bash
# iOS Simulator (requires Xcode)
xcodebuild -project DemoChatWith.xcodeproj -scheme DemoChatWith -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 15' build
```

**Testing:**
- The project uses Xcode's built-in testing framework
- Run tests via Xcode: `Cmd+U`
- No dedicated test runner scripts are configured yet

## Architecture

### Core Structure
- **Models/**: Data models using functional programming patterns
  - `ChatMessage`: Core message model with computed UI properties
  - `ChatViewState`: Immutable state management for chat functionality
  - `ChatInputState`: Input field state management
- **Views/**: SwiftUI components following single responsibility principle
  - `ChatView`: Main chat interface with scroll management and keyboard handling
  - `ChatBubbleView`: Individual message display component
  - `ChatInputView`: Text input with send functionality
- **API/**: OpenAI integration layer
  - `OpenAIClient`: Main API client with async/await patterns
  - `APIConfiguration`: Centralized API settings
  - `NetworkManager`: HTTP request handling

### Key Patterns
- **Functional State Management**: State updates return new immutable state objects
- **SwiftUI Best Practices**: Uses `@State`, `@FocusState`, and proper binding patterns
- **Async/await**: Modern Swift concurrency for API calls
- **Clean Architecture**: Separation of concerns between UI, business logic, and API layers

### Configuration Requirements
- **API Key**: OpenAI API key must be configured via `APIKeyManager`
- **Target**: iOS 18.5+ (as configured in project settings)
- **Swift Version**: Swift 5.0
- **Development Team**: Configured with team ID `48DVB7QH33`

### Security Notes
- API keys are managed through `APIKeyManager` - never hardcode in source
- `Config.plist` contains sensitive configuration (excluded from git)
- Follow secure storage patterns for API credentials

### Development Workflow
1. The project follows a phased development approach as documented in `Document/Specification.md`
2. UI components are built with functional patterns and minimal state
3. API integration uses modern Swift concurrency patterns
4. All state changes go through immutable state updates

### File Organization
- Entry point: `DemoChatWithApp.swift`
- Main content: `ContentView.swift` → `ChatView.swift`
- Models use computed properties for UI-specific logic
- API layer is completely separated from UI concerns