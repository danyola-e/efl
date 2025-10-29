# EFL Mobile - eFootball League App

Flutter mobile application for the eFootball League Ecosystem.

## Features

- 🔐 User Authentication (Login, Register, Role-based access)
- 🏆 Live Match Tracking with Real-time Updates
- 💬 Real-time Chat for Matches
- 📊 Standings & Leaderboards
- 🎮 Player Profiles & Stats
- 🎥 Match Recordings & Highlights
- 📱 Push Notifications
- 🎨 Dark Theme with Neon Accents

## Setup

### Prerequisites

- Flutter SDK 3.0+
- Android Studio / Xcode
- Physical device or emulator

### Installation

1. **Clone or copy this Flutter app folder to your local machine**

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Configure Backend URL:**
   - Open `.env` file
   - Replace with your actual backend URL:
     ```
     API_BASE_URL=https://your-backend-url.repl.co
     WS_BASE_URL=wss://your-backend-url.repl.co
     ```

4. **Download Orbitron Font:**
   - Download from Google Fonts: https://fonts.google.com/specimen/Orbitron
   - Place TTF files in `assets/fonts/` folder

5. **Run the app:**
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── config/                   # App configuration
│   ├── theme.dart           # Dark theme with neon accents
│   └── routes.dart          # Navigation routes
├── models/                   # Data models
│   ├── user.dart
│   ├── match.dart
│   ├── league.dart
│   └── chat.dart
├── services/                 # Backend services
│   ├── api_service.dart     # REST API
│   ├── auth_service.dart    # Authentication
│   ├── websocket_service.dart # WebSocket connections
│   └── storage_service.dart # Local storage
├── providers/                # State management
│   ├── auth_provider.dart
│   ├── match_provider.dart
│   └── chat_provider.dart
├── screens/                  # UI screens
│   ├── auth/
│   ├── home/
│   ├── matches/
│   ├── standings/
│   ├── chat/
│   └── profile/
└── widgets/                  # Reusable widgets
    ├── custom_button.dart
    ├── match_card.dart
    └── player_avatar.dart
```

## Backend Integration

This app connects to the Django backend running at your Replit URL.

### API Endpoints Used
- `POST /api/users/register/` - User registration
- `POST /api/users/login/` - User login
- `GET /api/matches/fixtures/` - Get fixtures
- `GET /api/leagues/standings/` - Get standings
- And more...

### WebSocket Connections
- `/ws/chat/<room_id>/` - Real-time chat
- `/ws/match/<fixture_id>/` - Live match updates
- `/ws/voice/<session_id>/` - Voice sessions

## Build for Release

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## Testing

```bash
flutter test
```

## Troubleshooting

- **Connection errors**: Make sure your Django backend is running and accessible
- **WebSocket issues**: Check that your backend URL includes the correct protocol (ws:// or wss://)
- **Font not loading**: Ensure Orbitron font files are in `assets/fonts/`

## Support

For issues with the Flutter app, check the code comments and ensure your backend is properly configured.
