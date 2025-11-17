import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthRepository {
  final FirebaseAuth _auth;

  AuthRepository(this._auth);

  Future<UserCredential> signIn(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      print('Erro de autenticação: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      print('Erro desconhecido: $e');
      rethrow;
    }
  }

  Future<UserCredential> signUp(
    String name,
    String email,
    String password,
  ) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      print('Erro de autenticação: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      print('Erro desconhecido: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      print('Erro de autenticação: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      print('Erro desconhecido: $e');
      rethrow;
    }
  }

  Stream<User?> get authState => _auth.authStateChanges();
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(FirebaseAuth.instance);
});

