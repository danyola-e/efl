import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../config/theme.dart';
import '../../widgets/custom_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).pushNamed('/edit-profile');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
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
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.primaryNeon,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryNeon.withOpacity(0.5),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: AppTheme.primaryNeon,
                      backgroundImage: user.profilePicture != null
                          ? NetworkImage(user.profilePicture!)
                          : null,
                      child: user.profilePicture == null
                          ? Text(
                              user.username[0].toUpperCase(),
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.displayName,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontFamily: 'Orbitron',
                          color: AppTheme.primaryNeon,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '@${user.username}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white60,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getRoleColor(user.role).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _getRoleColor(user.role),
                      ),
                    ),
                    child: Text(
                      user.role.toUpperCase(),
                      style: TextStyle(
                        color: _getRoleColor(user.role),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            if (user.role == 'player') ...[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        context,
                        'Wins',
                        user.wins?.toString() ?? '0',
                        Icons.emoji_events,
                        AppTheme.secondaryNeon,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        context,
                        'Losses',
                        user.losses?.toString() ?? '0',
                        Icons.close,
                        Colors.red,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        context,
                        'Goals',
                        user.goalsScored?.toString() ?? '0',
                        Icons.sports_soccer,
                        AppTheme.primaryNeon,
                      ),
                    ),
                  ],
                ),
              ),
              
              if (user.totalMatches > 0)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: AppTheme.neonGlow(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Win Rate',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          '${user.winRate.toStringAsFixed(1)}%',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: AppTheme.secondaryNeon,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
            
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Information',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontFamily: 'Orbitron',
                          color: AppTheme.primaryNeon,
                        ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(Icons.email, 'Email', user.email),
                  if (user.country != null)
                    _buildInfoRow(Icons.flag, 'Country', user.country!),
                  if (user.bio != null)
                    _buildInfoRow(Icons.info_outline, 'Bio', user.bio!),
                  _buildInfoRow(
                    Icons.calendar_today,
                    'Member Since',
                    user.dateJoined.toString().split(' ')[0],
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(16),
              child: CustomButton(
                text: 'LOGOUT',
                onPressed: () async {
                  await authProvider.logout();
                  if (context.mounted) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/login',
                      (route) => false,
                    );
                  }
                },
                color: Colors.red,
                icon: Icons.logout,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white60,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.primaryNeon, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'admin':
        return Colors.purple;
      case 'player':
        return AppTheme.primaryNeon;
      case 'fan':
        return AppTheme.secondaryNeon;
      default:
        return Colors.white;
    }
  }
}
