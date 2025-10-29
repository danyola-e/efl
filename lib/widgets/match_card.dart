import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/match.dart';
import '../config/theme.dart';

class MatchCard extends StatelessWidget {
  final Match match;
  final VoidCallback? onTap;

  const MatchCard({
    super.key,
    required this.match,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap ?? () {
          Navigator.of(context).pushNamed(
            '/match-detail',
            arguments: match,
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              if (match.isLive)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: AppTheme.liveIndicator(),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.circle,
                        size: 8,
                        color: AppTheme.secondaryNeon,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'LIVE',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              if (match.isLive) const SizedBox(height: 12),
              
              Text(
                match.competitionName,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.primaryNeon,
                ),
              ),
              const SizedBox(height: 12),
              
              Row(
                children: [
                  Expanded(
                    child: _buildTeam(
                      context,
                      match.homePlayer.displayName,
                      match.homeScore,
                      true,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      match.isCompleted ? 'FT' : 'VS',
                      style: TextStyle(
                        color: Colors.white38,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Expanded(
                    child: _buildTeam(
                      context,
                      match.awayPlayer.displayName,
                      match.awayScore,
                      false,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 14, color: Colors.white38),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('MMM dd, HH:mm').format(match.scheduledTime),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white38,
                        ),
                      ),
                    ],
                  ),
                  if (match.hasRecording)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.red.withOpacity(0.5)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.play_circle_outline, size: 14, color: Colors.red),
                          const SizedBox(width: 4),
                          Text(
                            'Recording',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeam(BuildContext context, String name, int? score, bool isHome) {
    return Column(
      crossAxisAlignment: isHome ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Text(
          name,
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: isHome ? TextAlign.left : TextAlign.right,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (score != null) ...[
          const SizedBox(height: 4),
          Text(
            score.toString(),
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: AppTheme.primaryNeon,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    );
  }
}
