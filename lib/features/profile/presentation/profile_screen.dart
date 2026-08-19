import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/routing/routes.dart';
import '../../../shared/widgets/top_snackbar.dart';
import '../application/profile_controller.dart';

final profileProvider = AsyncNotifierProvider<ProfileController, UserProfile>(
  ProfileController.new,
);

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileProvider);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Error loading profile')),
        data: (profile) => SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 32),
              _buildAvatar(profile),
              const SizedBox(height: 20),
              Text(
                profile.fullName.isNotEmpty ? profile.fullName : 'User',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: cs.onSurface,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                profile.email,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 12),
              _buildRoleBadge(profile.role),
              if (profile.hospital.isNotEmpty ||
                  profile.phone.isNotEmpty ||
                  profile.region.isNotEmpty ||
                  profile.country.isNotEmpty) ...[
                const SizedBox(height: 32),
                _buildInfoCard(profile),
              ],
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _handleResetPassword,
                  icon: const Icon(Icons.lock_reset, size: 22),
                  label: const Text('Reset Password', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.primaryContainer,
                    foregroundColor: cs.onPrimaryContainer,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    await ref.read(profileProvider.notifier).signOut();
                    if (context.mounted) context.go('/${Routes.welcome}');
                  },
                  icon: const Icon(Icons.logout, size: 22),
                  label: const Text('Sign Out', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: cs.outline),
                    foregroundColor: cs.onSurface,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(UserProfile profile) {
    String initials;
    if (profile.fullName.trim().isNotEmpty) {
      final names = profile.fullName.trim().split(RegExp(r'\s+'));
      if (names.length >= 2) {
        initials = '${names.first[0]}${names.last[0]}'.toUpperCase();
      } else {
        initials = names.first[0].toUpperCase();
      }
    } else if (profile.email.isNotEmpty) {
      initials = profile.email[0].toUpperCase();
    } else {
      initials = 'U';
    }

    return CircleAvatar(
      radius: 52,
      backgroundColor: const Color(0xFF3B6BF7),
      child: Text(
        initials,
        style: const TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildRoleBadge(String role) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2E7D5B),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        role,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildInfoCard(UserProfile profile) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Additional Information',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                ),
          ),
          const SizedBox(height: 20),
          if (profile.hospital.isNotEmpty) ...[
            _buildDetailRow(Icons.local_hospital_outlined, 'Hospital', profile.hospital),
            const SizedBox(height: 18),
          ],
          if (profile.phone.isNotEmpty) ...[
            _buildDetailRow(Icons.phone_outlined, 'Phone', profile.phone),
            const SizedBox(height: 18),
          ],
          if (profile.region.isNotEmpty || profile.country.isNotEmpty)
            _buildDetailRow(
              Icons.location_on_outlined,
              'Location',
              [profile.region, profile.country].where((e) => e.isNotEmpty).join(' , '),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 22, color: cs.onSurfaceVariant),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: cs.onSurface,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _handleResetPassword() async {
    try {
      await ref.read(profileProvider.notifier).resetPassword();
      if (mounted) showTopSnackBar(context, 'Password reset email sent.');
    } catch (e) {
      if (mounted) showTopSnackBar(context, 'Error: $e', isError: true);
    }
  }
}
