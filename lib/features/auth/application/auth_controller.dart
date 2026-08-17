import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/auth_repository.dart';
import 'auth_state.dart';

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
      state = const AuthSuccess();
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  void reset() {
    state = const AuthIdle();
  }
}
