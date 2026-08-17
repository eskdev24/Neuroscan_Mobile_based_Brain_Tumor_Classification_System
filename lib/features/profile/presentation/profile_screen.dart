import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/routing/routes.dart';
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
  String? _resetPasswordMessage;

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Error loading profile')),
        data: (profile) => SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 32),
              _buildAvatar(profile),
              const SizedBox(height: 16),
              Text(
                profile.fullName.isNotEmpty ? profile.fullName : profile.email,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              if (profile.fullName.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  profile.email,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                ),
              ],
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
              if (_resetPasswordMessage != null) ...[
                Text(
                  _resetPasswordMessage!,
                  style: TextStyle(
                    color: _resetPasswordMessage!.startsWith('Error')
                        ? Theme.of(context).colorScheme.error
                        : const Color(0xFF2962FF),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _handleResetPassword,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset Password', style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2962FF),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    if (context.mounted) context.go('/${Routes.welcome}');
                  },
                  icon: const Icon(Icons.logout, color: Color(0xFFE57373)),
                  label: const Text('Sign Out', style: TextStyle(fontSize: 16)),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
                    foregroundColor: Theme.of(context).colorScheme.onSurface,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
      initials = 'G';
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: const Color(0xFF2962FF),
          child: Text(
            initials,
            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        Positioned(
          bottom: -4,
          right: -4,
          child: CircleAvatar(
            radius: 14,
            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: CircleAvatar(
              radius: 12,
              backgroundColor: Theme.of(context).colorScheme.surface,
              child: Icon(
                Icons.edit,
                size: 14,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRoleBadge(String role) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF0F3A2B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1B5E20)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFF00E676),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            role,
            style: const TextStyle(
              color: Color(0xFF00E676),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(UserProfile profile) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 4,
              decoration: const BoxDecoration(
                color: Color(0xFF2962FF),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
                        const SizedBox(width: 8),
                        Text(
                          'Additional Information',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    if (profile.hospital.isNotEmpty) ...[
                      _buildDetailRow(Icons.business, 'HOSPITAL', profile.hospital),
                      const SizedBox(height: 16),
                    ],
                    if (profile.phone.isNotEmpty) ...[
                      _buildDetailRow(Icons.phone, 'PHONE', profile.phone),
                      const SizedBox(height: 16),
                    ],
                    if (profile.region.isNotEmpty || profile.country.isNotEmpty)
                      _buildDetailRow(
                        Icons.place,
                        'LOCATION',
                        [profile.region, profile.country].where((e) => e.isNotEmpty).join(', '),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    letterSpacing: 1,
                    color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                  ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _handleResetPassword() async {
    try {
      await ref.read(profileProvider.notifier).resetPassword();
      setState(() => _resetPasswordMessage = 'Password reset email sent.');
    } catch (e) {
      setState(() => _resetPasswordMessage = 'Error sending reset email: $e');
    }
  }
}
