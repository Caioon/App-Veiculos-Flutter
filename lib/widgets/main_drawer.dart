import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trabalho_flutter/viewmodel/auth_viewmodel.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'Cabeçalho do Menu',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.directions_car),
            title: const Text('Meus Veículos'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/veiculos');
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_circle),
            title: const Text('Registrar Abastecimentos'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/registrar-abastecimento');
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Histórico de Abastecimentos'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/historico-abastecimentos');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sair'),
            onTap: () async {
              await ref.read(authViewModelProvider.notifier).logout();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
        ],
      ),
    );
  }
}
