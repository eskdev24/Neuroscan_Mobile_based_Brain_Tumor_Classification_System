import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class UserProfile {
  final String email, role, fullName, hospital, phone, region, country;
  const UserProfile({required this.email, required this.role, required this.fullName, required this.hospital, required this.phone, required this.region, required this.country});
}

class ProfileController extends AsyncNotifier<UserProfile> {
  @override
  Future<UserProfile> build() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const UserProfile(email: '', role: '', fullName: '', hospital: '', phone: '', region: '', country: '');
    try {
      final snapshot = await FirebaseDatabase.instance.ref('users/${user.uid}').get();
      final data = snapshot.value as Map?;
      return UserProfile(
        email: user.email ?? '',
        role: data?['role'] as String? ?? 'Unknown',
        fullName: data?['fullName'] as String? ?? '',
        hospital: data?['hospital'] as String? ?? '',
        phone: data?['phone'] as String? ?? '',
        region: data?['region'] as String? ?? '',
        country: data?['country'] as String? ?? '',
      );
    } catch (_) {
      return UserProfile(email: user.email ?? '', role: 'Error', fullName: '', hospital: '', phone: '', region: '', country: '');
    }
  }

  Future<void> resetPassword() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user?.email != null) {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: user!.email!);
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    state = const AsyncValue.data(UserProfile(email: '', role: '', fullName: '', hospital: '', phone: '', region: '', country: ''));
  }
}
