# EFL Mobile App - Complete Setup Guide

This Flutter app is now **ready to run** and connects to your Django backend!

## 📋 Quick Start

### 1. Prerequisites
- Flutter SDK 3.0+ installed ([Get Flutter](https://flutter.dev/docs/get-started/install))
- Android Studio or VS Code with Flutter extensions
- Android device or emulator / iOS device or simulator

### 2. Installation Steps

```bash
# Navigate to the flutter_app directory
cd flutter_app

# Install all dependencies
flutter pub get

# Check your Flutter installation
flutter doctor
```

### 3. Configure Backend Connection

Open `.env` file and update with your actual backend URL:

```env
API_BASE_URL=https://your-replit-project-name.repl.co
WS_BASE_URL=wss://your-replit-project-name.repl.co
```

**IMPORTANT**: Make sure your Django backend is running and accessible!

### 4. Download Orbitron Font (Optional but Recommended)

1. Visit: https://fonts.google.com/specimen/Orbitron
2. Download the font family
3. Extract and place these files in `assets/fonts/`:
   - `Orbitron-Regular.ttf`
   - `Orbitron-Bold.ttf`
   - `Orbitron-Black.ttf`

If you skip this step, the app will fall back to system fonts (still looks good!).

### 5. Run the App

```bash
# Run on connected device or emulator
flutter run

# Or for specific device
flutter devices  # List available devices
flutter run -d <device-id>
```

## 🎯 Features Implemented

### ✅ Complete Feature List

#### Authentication
- ✅ Splash screen with animated logo
- ✅ User registration (Player/Fan roles)
- ✅ Login with username/password
- ✅ Persistent authentication (stays logged in)
- ✅ Token-based API authentication
- ✅ Logout functionality

#### Home Screen
- ✅ Welcome banner with user info
- ✅ Live matches section with real-time status
- ✅ Upcoming matches preview
- ✅ Pull-to-refresh
- ✅ Bottom navigation

#### Matches
- ✅ All matches list with filtering
- ✅ Filter by: All, Live, Upcoming, Completed
- ✅ Match cards with scores and competition info
- ✅ Live match indicators with neon glow
- ✅ Match detail view
- ✅ Goals and events display
- ✅ Recording availability indicator

#### Real-Time Chat
- ✅ WebSocket-based chat for each match
- ✅ Send and receive messages in real-time
- ✅ Typing indicators
- ✅ Connection status indicator
- ✅ Message timestamps
- ✅ User avatars
- ✅ Authenticated messaging

#### Standings/Leaderboard
- ✅ Competition selection dropdown
- ✅ Full league table with:
  - Position, Player, Played, Won, Drawn, Lost, Points
- ✅ Top 3 positions highlighted
- ✅ Goal difference display
- ✅ Pull-to-refresh

#### Profile
- ✅ User profile display
- ✅ Player stats (Wins, Losses, Goals, Win Rate)
- ✅ Edit profile functionality
- ✅ Role badges
- ✅ Member since date
- ✅ Logout button

### 🎨 UI/UX
- ✅ Dark theme with neon accents (matching web design)
- ✅ Futuristic gaming aesthetic
- ✅ Smooth animations
- ✅ Custom buttons and cards
- ✅ Responsive layouts
- ✅ Loading states
- ✅ Error handling

## 📡 API Integration

### REST Endpoints Used
```
POST /api/users/register/       - User registration
POST /api/users/login/          - User login
POST /api/users/logout/         - User logout
GET  /api/users/profile/        - Get user profile
PUT  /api/users/profile/        - Update profile

GET  /api/matches/fixtures/     - List matches
GET  /api/matches/fixtures/:id/ - Match details
PUT  /api/matches/fixtures/:id/ - Update match

GET  /api/leagues/competitions/ - List competitions
GET  /api/leagues/standings/    - Get standings
```

### WebSocket Connections
```
/ws/chat/:room_id/        - Match chat (real-time messaging)
/ws/match/:fixture_id/    - Live match updates
/ws/voice/:session_id/    - Voice sessions (future)
```

## 📱 Testing the App

### Test Flow 1: New User Registration
1. Open app → Splash screen
2. Click "Register"
3. Fill in details (use role: Player)
4. Submit → Auto-login → Home screen

### Test Flow 2: View Live Matches
1. Navigate to "Matches" tab
2. Filter by "Live"
3. Tap on a match → Match details
4. Tap chat icon → Real-time chat

### Test Flow 3: Check Standings
1. Navigate to "Standings" tab
2. Select a competition
3. View league table with your position

### Test Flow 4: Edit Profile
1. Navigate to "Profile" tab
2. Tap edit icon
3. Update gamertag/bio
4. Save changes

## 🔒 Security Features

### Secure Credential Storage
The app uses **platform-specific secure storage** for authentication tokens and user data:

- **Android**: Keystore-backed encrypted storage with `encryptedSharedPreferences`
- **iOS**: Secure Keychain with `first_unlock` accessibility

**Benefits**:
- Tokens are encrypted and protected by hardware security modules
- Data is isolated from other apps (no root/backup access)
- Automatic migration from legacy storage if upgrading

**What this means**: Your authentication tokens are as secure as your device's biometric lock or PIN.

### Automatic Migration
If you had an older version of the app, tokens stored in SharedPreferences are automatically:
1. Migrated to secure storage on first read
2. Removed from the old insecure location
3. All future reads/writes use secure storage only

## 🔧 Troubleshooting

### Issue: Connection errors
**Solution**: 
- Ensure Django backend is running
- Check `.env` has correct URL
- Verify CORS is enabled on backend
- Check firewall/network settings

### Issue: WebSocket not connecting
**Solution**:
- Use `wss://` (not `ws://`) for HTTPS backends
- Ensure WebSocket routes are configured on backend
- Check Django Channels and Daphne are running

### Issue: Font not loading
**Solution**:
- Download Orbitron font from Google Fonts
- Place TTF files in `assets/fonts/`
- Run `flutter clean && flutter pub get`

### Issue: Build errors
**Solution**:
```bash
flutter clean
flutter pub get
flutter pub upgrade
flutter run
```

## 🚀 Building for Release

### Android APK
```bash
# Build release APK
flutter build apk --release

# Find APK at: build/app/outputs/flutter-apk/app-release.apk
```

### Android App Bundle (for Play Store)
```bash
flutter build appbundle --release

# Find at: build/app/outputs/bundle/release/app-release.aab
```

### iOS (requires macOS and Xcode)
```bash
flutter build ios --release
```

## 📂 Project Structure

```
flutter_app/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── config/
│   │   ├── theme.dart           # Dark theme + neon colors
│   │   └── routes.dart          # Navigation routes
│   ├── models/
│   │   ├── user.dart
│   │   ├── match.dart
│   │   ├── league.dart
│   │   └── chat.dart
│   ├── services/
│   │   ├── api_service.dart     # REST API calls
│   │   ├── auth_service.dart    # Authentication
│   │   ├── websocket_service.dart # WebSocket connections
│   │   └── storage_service.dart # Local storage
│   ├── providers/               # State management
│   │   ├── auth_provider.dart
│   │   ├── match_provider.dart
│   │   ├── chat_provider.dart
│   │   └── league_provider.dart
│   ├── screens/                 # All UI screens
│   │   ├── auth/               # Login, Register, Splash
│   │   ├── home/               # Home screen
│   │   ├── matches/            # Matches list and details
│   │   ├── standings/          # Leaderboard
│   │   ├── chat/               # Real-time chat
│   │   └── profile/            # User profile
│   └── widgets/                # Reusable components
│       ├── custom_button.dart
│       └── match_card.dart
├── assets/
│   ├── fonts/                  # Orbitron fonts
│   ├── images/                 # App images
│   └── icons/                  # App icons
├── pubspec.yaml                # Dependencies
├── .env                        # Backend configuration
└── README.md                   # Documentation
```

## 🎯 Next Steps

### Immediate Improvements
1. Add push notifications (Firebase Cloud Messaging)
2. Implement match recording video player
3. Add photo upload for profile pictures
4. Create highlights/clips feature
5. Add dark/light theme toggle

### Advanced Features
6. Offline mode with local caching
7. Social features (friends, messaging)
8. Tournament brackets visualization
9. Live match commentary
10. Statistics and analytics dashboards

## 🆘 Need Help?

- **Flutter Docs**: https://flutter.dev/docs
- **Provider State Management**: https://pub.dev/packages/provider
- **WebSocket in Flutter**: https://pub.dev/packages/web_socket_channel

## ✨ You're All Set!

Your EFL mobile app is ready to connect to the Django backend. Run `flutter run` and start testing! 🚀⚽

Happy coding! 🎮
