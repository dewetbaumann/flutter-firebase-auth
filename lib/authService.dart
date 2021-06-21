import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth fsAuth;
  AuthService(this.fsAuth);

  Stream<User> get authStateChanges => fsAuth.authStateChanges();

  Future<String> signIn({String email, String pass}) async {
    try {
      await fsAuth.signInWithEmailAndPassword(email: email, password: pass);
      return 'Secion iniciada correctamente';
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String> signUp({String email, String pass}) async {
    try {
      await fsAuth.createUserWithEmailAndPassword(email: email, password: pass);
      return 'Secion iniciada correctamente';
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
