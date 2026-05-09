# AI Chat Client

A Flutter-based chat application that provides a user-friendly interface for interacting with AI models via the Ollama API. The application supports user authentication, encrypted message storage, and multiple chat histories.

## Features

### 🔐 Security
- **User Authentication**: Local user registration and login with password hashing using PBKDF2
- **Message Encryption**: All messages are encrypted using AES-256 CBC mode before storage
- **Secure Storage**: Credentials stored in secure platform storage (Flutter Secure Storage)
- **Dynamic Encryption**: Adaptive key and IV sizing for flexible encryption support

### 💬 Chat Functionality
- **Multiple Chat Histories**: Create and manage multiple conversation threads
- **AI Integration**: Send messages to AI models running on Ollama
- **Message History**: Persistent storage of all conversations in SQLite database
- **Real-time Messaging**: Send messages and receive AI responses with visual feedback

### 🗄️ Data Management
- **SQLite Database**: Local database for users, chat histories, and messages
- **Persistent Storage**: All data encrypted and stored locally
- **Database Schema**:
  - `users`: User accounts with hashed passwords
  - `chat_history`: Conversation threads linked to users
  - `messages`: Encrypted messages in each conversation

### 🎨 User Interface
- **Material Design**: Clean and intuitive Material Design interface
- **Responsive Layout**: Adapts to different screen sizes
- **Loading Indicators**: Visual feedback with animated typing dots during AI responses
- **Error Handling**: User-friendly error messages and validation

### 🏗️ Architecture
- **BLoC Pattern**: Clean separation of concerns using the BLoC/Cubit pattern
- **State Management**: Efficient state management with flutter_bloc
- **Modular Structure**: Organized into services, cubits, views, and widgets

## Tech Stack

- **Framework**: Flutter 3.9.2+
- **State Management**: flutter_bloc 9.1.1
- **Database**: sqflite_common_ffi 2.4.0+2
- **Encryption**: encrypt 5.0.3
- **Password Hashing**: password_dart 2.0.1
- **HTTP Client**: dio 5.9.2
- **Secure Storage**: flutter_secure_storage 10.0.0
- **API Logger**: pretty_dio_logger 1.4.0

## Project Structure

```
lib/
├── main.dart                 # Application entry point
├── app.dart                  # Root widget configuration
├── views/                    # Screen pages
│   ├── login.dart
│   ├── create_user.dart
│   └── main_menu.dart
├── widgets/                  # Reusable UI components
│   ├── chat_bubble.dart
│   ├── message_area.dart
│   ├── chat_history.dart
│   ├── new_chat_dialog.dart
│   └── three_dots_loading.dart
├── cubit/                    # State management
│   ├── auth/                 # Authentication
│   │   ├── login/
│   │   └── register/
│   └── chat/                 # Chat functionality
│       ├── message_area/
│       ├── chat_history/
│       └── model_selection/
├── services/                 # Business logic
│   ├── sqlite.dart          # Database operations
│   ├── encryption.dart      # Encryption utilities
│   ├── dio.dart             # HTTP requests
│   └── firebase.dart        # Cloud storage (optional)
└── vars.dart                # Global variables
```

## Getting Started

### Prerequisites
- Flutter SDK (3.9.2 or higher)
- Dart SDK
- Ollama API running locally (for AI model responses)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Mohamed-Moustafa-115/Ai_UI_Chat_Client.git
   cd ai_chat_client
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up Ollama**
   - Install [Ollama](https://ollama.ai)
   - Run Ollama: `ollama serve`
   - Pull a model: `ollama pull llama2` (or your preferred model)
   - Ensure the API is running on `http://localhost:11434`

4. **Run the application**
   ```bash
   flutter run
   ```

## Usage

### Creating an Account
1. Launch the application
2. Click "Create A Local Account"
3. Enter your full name, username, and password
4. Your account is created and you're redirected to login

### Logging In
1. Enter your username and password
2. Click "Login"
3. You'll be redirected to the main chat interface

### Using the Chat
1. Click the hamburger menu to view chat histories
2. Select an existing chat or click "New Chat" to create one
3. Select a model from the dropdown (available models from Ollama)
4. Type your message and press the send button
5. Wait for the AI response

## Database Schema

### Users Table
```sql
CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    username TEXT,
    password TEXT
)
```

### Chat History Table
```sql
CREATE TABLE chat_history (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT,
    user_id INTEGER,
    FOREIGN KEY (user_id) REFERENCES users (id)
)
```

### Messages Table
```sql
CREATE TABLE messages (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    content TEXT,
    is_user_message BOOLEAN,
    chat_history_id INTEGER,
    FOREIGN KEY (chat_history_id) REFERENCES chat_history (id)
)
```

## Security Considerations

- **Password Security**: Passwords are hashed using PBKDF2 before storage
- **Message Encryption**: All messages are encrypted with AES-256 CBC
- **Local Storage**: All data stored locally on device
- **Secure Storage**: Encryption keys stored in platform-specific secure storage

## Available Platforms

- ✅ Linux (Primary)
- ✅ Android
- ✅ Web (Limited support)
- ✅ macOS
- ✅ Windows
- ✅ iOS

## Future Enhancements

- [ ] User profile customization
- [ ] Message search and filtering
- [ ] Conversation sharing
- [ ] Theme customization
- [ ] Voice message support
- [ ] Offline mode improvements

## Contributing

Contributions are welcome! Please feel free to submit pull requests.

## License

This project is licensed under the MIT License - see LICENSE file for details.

## Support

For issues, questions, or suggestions, please open an issue on the GitHub repository.
