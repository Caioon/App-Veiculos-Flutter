import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trabalho_flutter/viewmodel/auth_viewmodel.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!formKey.currentState!.validate()) return;

    final auth = ref.read(authViewModelProvider.notifier);

    try {
      await auth.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email ou Senha incorretos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(authViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Center(
        child: SizedBox(
          width: 300,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Digite seu e-mail';
                    }
                    if (!value.contains('@')) return 'E-mail inválido';
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Digite sua senha';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: loginState is AsyncLoading ? null : _handleLogin,
                  child: loginState is AsyncLoading
                      ? const CircularProgressIndicator()
                      : const Text('Login'),
                ),

                const SizedBox(height: 16),

                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: const Text('Criar nova conta'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
