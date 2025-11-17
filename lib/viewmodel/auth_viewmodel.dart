import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trabalho_flutter/model/auth_repository.dart';

class AuthViewModel extends AsyncNotifier<User?> {
  @override
  Future<User?> build() async {
    return ref.watch(authRepositoryProvider).authState.first;
  }

  Future<void> login(String email, String password) async {
    final repo = ref.read(authRepositoryProvider);

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final credential = await repo.signIn(email, password);
      return credential.user;
    });
  }

  Future<void> signup(String name, String email, String password) async {
    final repo = ref.read(authRepositoryProvider);

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final credential = await repo.signUp(name, email, password);
      return credential.user;
    });
  }

  Future<void> logout() async {
    final repo = ref.read(authRepositoryProvider);

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await repo.signOut();
      return null; 
    });
  }
}

final authViewModelProvider = AsyncNotifierProvider<AuthViewModel, User?>(
  AuthViewModel.new,
);

