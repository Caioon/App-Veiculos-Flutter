import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trabalho_flutter/model/auth_repository.dart';

class AuthViewModel extends StreamNotifier<User?> {
  @override
  Stream<User?> build() {
    return ref.watch(authRepositoryProvider).authState;
  }

  Future<void> login(String email, String password) async {
    final repo = ref.read(authRepositoryProvider);
    
    try {
      await repo.signIn(email, password);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signup(String name, String email, String password) async {
    final repo = ref.read(authRepositoryProvider);

    try {
      await repo.signUp(name, email, password);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    final repo = ref.read(authRepositoryProvider);

    try {
      await repo.signOut();
    } catch (e) {
      rethrow;
    }
  }
}

final authViewModelProvider = StreamNotifierProvider<AuthViewModel, User?>(
  AuthViewModel.new,
);
