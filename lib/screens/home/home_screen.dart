import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/match_provider.dart';
import '../../config/theme.dart';
import '../../widgets/match_card.dart';
import '../matches/matches_screen.dart';
import '../standings/standings_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const _HomeTab(),
    const MatchesScreen(),
    const StandingsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_soccer),
            label: 'Matches',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'Standings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _HomeTab extends StatefulWidget {
  const _HomeTab();

  @override
  State<_HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<_HomeTab> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final matchProvider = Provider.of<MatchProvider>(context, listen: false);
    await matchProvider.fetchLiveMatches();
    await matchProvider.fetchMatches();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('eFootball League'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: AppTheme.neonGlow(),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: AppTheme.primaryNeon,
                      child: Text(
                        authProvider.currentUser?.username[0].toUpperCase() ?? 'U',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back,',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            authProvider.currentUser?.displayName ?? 'Player',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: AppTheme.primaryNeon,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              _buildSectionHeader(context, 'Live Matches', Icons.circle, AppTheme.secondaryNeon),
              const SizedBox(height: 12),
              Consumer<MatchProvider>(
                builder: (context, matchProvider, child) {
                  if (matchProvider.liveMatches.isEmpty) {
                    return _buildEmptyState('No live matches at the moment');
                  }
                  
                  return Column(
                    children: matchProvider.liveMatches
                        .map((match) => MatchCard(match: match))
                        .toList(),
                  );
                },
              ),
              const SizedBox(height: 24),
              
              _buildSectionHeader(context, 'Upcoming Matches', Icons.schedule, AppTheme.primaryNeon),
              const SizedBox(height: 12),
              Consumer<MatchProvider>(
                builder: (context, matchProvider, child) {
                  final upcomingMatches = matchProvider.matches
                      .where((m) => m.isScheduled)
                      .take(3)
                      .toList();
                  
                  if (upcomingMatches.isEmpty) {
                    return _buildEmptyState('No upcoming matches');
                  }
                  
                  return Column(
                    children: upcomingMatches
                        .map((match) => MatchCard(match: match))
                        .toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontFamily: 'Orbitron',
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      padding: const EdgeInsets.all(32),
      alignment: Alignment.center,
      child: Text(
        message,
        style: TextStyle(color: Colors.white38),
      ),
    );
  }
}
