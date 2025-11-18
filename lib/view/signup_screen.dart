import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trabalho_flutter/viewmodel/auth_viewmodel.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!formKey.currentState!.validate()) return;

    final auth = ref.read(authViewModelProvider.notifier);

    try {
      await auth.signup(
        nameController.text.trim(),
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao criar conta: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final signupState = ref.watch(authViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: Text("Criar Conta")),
      body: Center(
        child: SizedBox(
          width: 300,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nome do Usuário',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Digite seu nome';
                    if (value.length < 3) return 'Nome muito curto';
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),

                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Digite seu e-mail';
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
                    if (value == null || value.isEmpty) return 'Digite sua senha';
                    if (value.length < 6) return 'Senha muito curta';
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: signupState is AsyncLoading ? null : _handleSignup,
                  child: signupState is AsyncLoading
                      ? const CircularProgressIndicator()
                      : const Text('Criar Conta'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

