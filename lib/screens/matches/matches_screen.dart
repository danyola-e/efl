import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/match_provider.dart';
import '../../config/theme.dart';
import '../../widgets/match_card.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    _loadMatches();
  }

  Future<void> _loadMatches() async {
    final matchProvider = Provider.of<MatchProvider>(context, listen: false);
    String? status = _selectedFilter == 'all' ? null : _selectedFilter;
    await matchProvider.fetchMatches(status: status);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matches'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All', 'all'),
                  _buildFilterChip('Live', 'ongoing'),
                  _buildFilterChip('Upcoming', 'scheduled'),
                  _buildFilterChip('Completed', 'completed'),
                ],
              ),
            ),
          ),
          Expanded(
            child: Consumer<MatchProvider>(
              builder: (context, matchProvider, child) {
                if (matchProvider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (matchProvider.matches.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.sports_soccer,
                          size: 64,
                          color: Colors.white24,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No matches found',
                          style: TextStyle(color: Colors.white38),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _loadMatches,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: matchProvider.matches.length,
                    itemBuilder: (context, index) {
                      final match = matchProvider.matches[index];
                      return MatchCard(match: match);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedFilter = value;
          });
          _loadMatches();
        },
        backgroundColor: AppTheme.cardBg,
        selectedColor: AppTheme.primaryNeon.withOpacity(0.3),
        side: BorderSide(
          color: isSelected ? AppTheme.primaryNeon : AppTheme.borderColor,
        ),
        labelStyle: TextStyle(
          color: isSelected ? AppTheme.primaryNeon : Colors.white70,
        ),
      ),
    );
  }
}
