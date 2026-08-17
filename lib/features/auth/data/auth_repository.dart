import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseDatabase _db;

  AuthRepository({FirebaseAuth? auth, FirebaseDatabase? db})
      : _auth = auth ?? FirebaseAuth.instance,
        _db = db ?? FirebaseDatabase.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    return _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> sendEmailVerification() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user signed in');
    await user.sendEmailVerification();
  }

  bool get isEmailVerified => _auth.currentUser?.emailVerified ?? false;

  Future<void> saveUserProfile({
    required String uid,
    required String name,
    required String role,
    String? phone,
  }) async {
    await _db.ref('users/$uid').set({
      'name': name,
      'role': role,
      if (phone != null) 'phone': phone,
      'email': _auth.currentUser?.email,
      'createdAt': ServerValue.timestamp,
    });
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
