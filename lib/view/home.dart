import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trabalho_flutter/viewmodel/auth_viewmodel.dart';
import 'package:trabalho_flutter/widgets/base_scaffold.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authController = ref.watch(authViewModelProvider.notifier);

    return BaseScaffold(
      title: "Home",
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Bem vindo a home screen!"),
            ElevatedButton(
              onPressed: () async {
                await authController.logout();
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
