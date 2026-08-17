import 'package:firebase_core/firebase_core.dart';

class FirebaseInit {
  static Future<void> initialize() async {
    await Firebase.initializeApp();
  }
}
