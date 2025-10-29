import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/league_provider.dart';
import '../../config/theme.dart';
import '../../models/league.dart';

class StandingsScreen extends StatefulWidget {
  const StandingsScreen({super.key});

  @override
  State<StandingsScreen> createState() => _StandingsScreenState();
}

class _StandingsScreenState extends State<StandingsScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final leagueProvider = Provider.of<LeagueProvider>(context, listen: false);
    await leagueProvider.fetchLeagues();
    if (leagueProvider.leagues.isNotEmpty) {
      await leagueProvider.fetchStandings(
        competitionId: leagueProvider.leagues.first.id,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Standings'),
      ),
      body: Consumer<LeagueProvider>(
        builder: (context, leagueProvider, child) {
          if (leagueProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (leagueProvider.leagues.isEmpty) {
            return Center(
              child: Text(
                'No competitions available',
                style: TextStyle(color: Colors.white38),
              ),
            );
          }

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: DropdownButtonFormField<League>(
                  value: leagueProvider.selectedLeague ?? leagueProvider.leagues.first,
                  decoration: const InputDecoration(
                    labelText: 'Select Competition',
                    prefixIcon: Icon(Icons.emoji_events),
                  ),
                  items: leagueProvider.leagues.map((league) {
                    return DropdownMenuItem(
                      value: league,
                      child: Text(league.name),
                    );
                  }).toList(),
                  onChanged: (league) async {
                    if (league != null) {
                      leagueProvider.selectLeague(league);
                      await leagueProvider.fetchStandings(competitionId: league.id);
                    }
                  },
                ),
              ),
              Expanded(
                child: leagueProvider.standings.isEmpty
                    ? Center(
                        child: Text(
                          'No standings data available',
                          style: TextStyle(color: Colors.white38),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadData,
                        child: ListView(
                          padding: const EdgeInsets.all(16),
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: AppTheme.cardBg,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppTheme.borderColor),
                              ),
                              child: Column(
                                children: [
                                  _buildStandingsHeader(),
                                  ...leagueProvider.standings.asMap().entries.map((entry) {
                                    final index = entry.key;
                                    final standing = entry.value;
                                    return _buildStandingRow(
                                      standing,
                                      index < leagueProvider.standings.length - 1,
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStandingsHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.primaryNeon.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Text(
              '#',
              style: TextStyle(
                color: AppTheme.primaryNeon,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'PLAYER',
              style: TextStyle(
                color: AppTheme.primaryNeon,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          _buildHeaderCell('P'),
          _buildHeaderCell('W'),
          _buildHeaderCell('D'),
          _buildHeaderCell('L'),
          _buildHeaderCell('PTS', width: 45),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, {double width = 35}) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppTheme.primaryNeon,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildStandingRow(Standing standing, bool showDivider) {
    Color? positionColor;
    if (standing.position <= 3) {
      positionColor = AppTheme.secondaryNeon;
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              SizedBox(
                width: 40,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: positionColor?.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                    border: positionColor != null
                        ? Border.all(color: positionColor)
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    standing.position.toString(),
                    style: TextStyle(
                      color: positionColor ?? Colors.white70,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  standing.player.displayName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              _buildStatCell(standing.played.toString()),
              _buildStatCell(standing.won.toString()),
              _buildStatCell(standing.drawn.toString()),
              _buildStatCell(standing.lost.toString()),
              _buildStatCell(
                standing.points.toString(),
                color: AppTheme.primaryNeon,
                isBold: true,
                width: 45,
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            color: AppTheme.borderColor,
            indent: 12,
            endIndent: 12,
          ),
      ],
    );
  }

  Widget _buildStatCell(
    String text, {
    Color? color,
    bool isBold = false,
    double width = 35,
  }) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: color ?? Colors.white70,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
