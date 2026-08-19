import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/auth_repository.dart';
import 'auth_state.dart';
import '../../scan/data/scan_repository.dart';
import '../../scan/data/scan_local_dao.dart';
import '../../profile/application/profile_controller.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  try {
    return AuthRepository(
      auth: FirebaseAuth.instance,
      db: FirebaseDatabase.instance,
    );
  } catch (e) {
    throw StateError(
      'Failed to create AuthRepository. Firebase may not be initialized. Error: $e',
    );
  }
});

final authControllerProvider =
    NotifierProvider<AuthController, AuthState>(AuthController.new);

class AuthController extends Notifier<AuthState> {
  AuthRepository get _repo => ref.read(authRepositoryProvider);

  @override
  AuthState build() => const AuthIdle();

  Future<void> signIn(String email, String password) async {
    state = const AuthLoading();
    try {
      await _repo.signInWithEmail(email: email, password: password);
      if (!_repo.isEmailVerified) {
        await _repo.sendEmailVerification();
        state = const AuthError(
          'Please verify your email. A verification link has been sent.',
        );
        return;
      }
      state = const AuthSuccess();
      ref.invalidate(profileProvider);
      ScanRepository(ScanLocalDao()).syncFromFirebase();
    } on FirebaseAuthException catch (e) {
      state = AuthError(e.message ?? 'Sign in failed');
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required String role,
    String? phone,
    String? hospital,
    String? region,
    String? country,
  }) async {
    state = const AuthLoading();
    try {
      final cred = await _repo.signUpWithEmail(
        email: email,
        password: password,
      );
      await _repo.saveUserProfile(
        uid: cred.user!.uid,
        name: name,
        role: role,
        phone: phone,
        hospital: hospital,
        region: region,
        country: country,
      );
      await _repo.sendEmailVerification();
      state = const AuthSignUpSuccess();
    } on FirebaseAuthException catch (e) {
      state = AuthError(e.message ?? 'Sign up failed');
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  Future<void> resetPassword(String email) async {
    state = const AuthLoading();
    try {
      await _repo.resetPassword(email);
      state = const AuthPasswordResetSent();
    } on FirebaseAuthException catch (e) {
      state = AuthError(e.message ?? 'Failed to send reset link');
    } catch (e) {
      state = AuthError('Failed to send reset link: $e');
    }
  }

  void reset() {
    state = const AuthIdle();
  }
}
