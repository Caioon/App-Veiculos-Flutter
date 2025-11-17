import 'package:flutter/material.dart';
import 'package:trabalho_flutter/widgets/main_drawer.dart';

class BaseScaffold extends StatelessWidget {
  final String title;
  final Widget body;

  const BaseScaffold({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      drawer: const AppDrawer(),
      body: body,
    );
  }
}

