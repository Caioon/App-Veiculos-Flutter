import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trabalho_flutter/viewmodel/auth_viewmodel.dart';
import 'package:trabalho_flutter/widgets/main_drawer.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(authViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      drawer: const AppDrawer(),
      body: Center(
        child: Text(
          "Bem vindo à home, ${userAsync.value?.displayName ?? 'usuário'}!",
          style: const TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
