# 📄 DemoChatWith — Specification for Cursor AI

---

## ✅ Project Goal

This is a **demo SwiftUI project** named `DemoChatWith`.  
It will be a simple iOS chat app that connects to **OpenAI ChatGPT** via the official OpenAI API using my personal API key.




**Note:** Do not hardcode the API key in code. Store it securely for local testing.

---

## ✅ Key Rules for Cursor AI

- **⚠️ Do NOT start any development or code generation without my explicit command.**
- First, always explain your plan.
- Wait for my explicit approval to proceed.
- Follow functional programming and SOLID principles.
- Use modern Swift & SwiftUI best practices.
- Keep state minimal. Use pure functions where possible.
- If unsure — always ask.

---

## ✅ Project Folder Structure

Root folder: `DemoChatWith`

```
DemoChatWith/
├── DemoChatWith/                # App source folder
│   ├── Models/                  # Data models
│   │   ├── ChatMessage.swift
│   │   ├── ChatInputState.swift
│   │   ├── ChatViewState.swift
│   │   ├── MessageType.swift
│   │   └── ChatBubbleStyle.swift
│   ├── Views/                   # UI components
│   │   ├── ChatBubbleView.swift
│   │   ├── ChatInputView.swift
│   │   └── ChatView.swift
│   ├── ContentView.swift        # Main content view
│   ├── DemoChatWithApp.swift    # App entry point
│   └── Assets.xcassets/         # App assets
│       ├── AccentColor.colorset/
│       │   └── Contents.json
│       ├── AppIcon.appiconset/
│       │   └── Contents.json
│       └── Contents.json
├── DemoChatWith.xcodeproj/      # Xcode project
│   ├── project.pbxproj
│   ├── project.xcworkspace/
│   │   ├── contents.xcworkspacedata
│   │   ├── xcshareddata/
│   │   │   └── swiftpm/
│   │   │       └── configuration/
│   │   └── xcuserdata/
│   └── xcuserdata/
├── Document/                    # Project documentation
│   ├── phase1.md               # Phase 1 completion report
│   ├── phase2.md               # Phase 2 completion report
│   └── Specification.md        # This specification
└── README.md                    # Project overview
```


---

## ✅ Phase 1 — Init

**Tasks:**
1. Create the `Document` folder inside the project root.
2. Save this specification in `Document/Specification.md`.
3. Keep `README.md` file (can be empty for now).
4. Commit all these changes to the Git repository.

---

## ✅ Next Phase — UI Only

**Do NOT start until I approve Phase 1 completion.**

When Phase 1 is done:
- Implement **only the UI**, no network logic yet.
- The UI must allow:
  - User types multiline text in a text input field.
  - User taps Send button.
  - The sent text appears nicely in a chat bubble style (like in ChatGPT iOS app or Cursor IDE chat).
  - The input field clears automatically.
- Use modern SwiftUI, readable and maintainable.
- Design should be minimal, clean, and easy to extend later.

---

## ✅ Additional Notes

- API details for reference: [https://platform.openai.com/docs/api-reference/chat](https://platform.openai.com/docs/api-reference/chat)
- For streaming: [https://platform.openai.com/docs/api-reference/chat/create#chat-create-stream](https://platform.openai.com/docs/api-reference/chat/create#chat-create-stream)
- This app **may support switching between JSON short response and streaming** in future phases.

---

## ✅ Reminder for Cursor

📌 **DO NOT GENERATE OR MODIFY CODE** until you have:
1. Explained your plan.
2. Received my explicit approval.
3. Followed the phase structure step-by-step. 