import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/matches/matches_screen.dart';
import '../screens/matches/match_detail_screen.dart';
import '../screens/standings/standings_screen.dart';
import '../screens/chat/chat_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/edit_profile_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String matches = '/matches';
  static const String matchDetail = '/match-detail';
  static const String standings = '/standings';
  static const String chat = '/chat';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  
  static Map<String, WidgetBuilder> get routes {
    return {
      splash: (context) => const SplashScreen(),
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      home: (context) => const HomeScreen(),
      matches: (context) => const MatchesScreen(),
      matchDetail: (context) => const MatchDetailScreen(),
      standings: (context) => const StandingsScreen(),
      chat: (context) => const ChatScreen(),
      profile: (context) => const ProfileScreen(),
      editProfile: (context) => const EditProfileScreen(),
    };
  }
}
