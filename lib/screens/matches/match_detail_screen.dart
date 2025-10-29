import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/match.dart';
import '../../config/theme.dart';

class MatchDetailScreen extends StatefulWidget {
  const MatchDetailScreen({super.key});

  @override
  State<MatchDetailScreen> createState() => _MatchDetailScreenState();
}

class _MatchDetailScreenState extends State<MatchDetailScreen> {
  Match? match;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (match == null) {
      match = ModalRoute.of(context)!.settings.arguments as Match;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (match == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Match Details'),
        actions: [
          if (match!.isLive)
            IconButton(
              icon: const Icon(Icons.chat),
              onPressed: () {
                Navigator.of(context).pushNamed('/chat', arguments: match!.id);
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppTheme.cardBg,
                    AppTheme.darkBg,
                  ],
                ),
              ),
              child: Column(
                children: [
                  if (match!.isLive)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: AppTheme.liveIndicator(),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.circle, size: 10, color: AppTheme.secondaryNeon),
                          const SizedBox(width: 8),
                          const Text(
                            'LIVE NOW',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 16),
                  
                  Text(
                    match!.competitionName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppTheme.primaryNeon,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildPlayerInfo(
                        match!.homePlayer.displayName,
                        match!.homeScore,
                      ),
                      Text(
                        'VS',
                        style: TextStyle(
                          color: Colors.white38,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      _buildPlayerInfo(
                        match!.awayPlayer.displayName,
                        match!.awayScore,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  Text(
                    DateFormat('EEEE, MMMM dd, yyyy • HH:mm').format(match!.scheduledTime),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),
            ),
            
            if (match!.goals != null && match!.goals!.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Goals',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontFamily: 'Orbitron',
                        color: AppTheme.primaryNeon,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...match!.goals!.map((goal) => _buildGoalItem(goal)),
                  ],
                ),
              ),
            ],
            
            if (match!.hasRecording)
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.play_circle_outline),
                  label: const Text('Watch Recording'),
                  onPressed: () {
                    // TODO: Play video
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerInfo(String name, int? score) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: AppTheme.primaryNeon,
          child: Text(
            name[0].toUpperCase(),
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          name,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        if (score != null) ...[
          const SizedBox(height: 8),
          Text(
            score.toString(),
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: AppTheme.primaryNeon,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildGoalItem(Goal goal) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Row(
        children: [
          Icon(Icons.sports_soccer, color: AppTheme.secondaryNeon, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              goal.playerName,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Text(
            "${goal.minute}'",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.primaryNeon,
            ),
          ),
        ],
      ),
    );
  }
}
