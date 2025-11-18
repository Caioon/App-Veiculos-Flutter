import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trabalho_flutter/view/home.dart';
import 'package:trabalho_flutter/view/login_screen.dart';
import 'package:trabalho_flutter/view/signup_screen.dart';
import 'package:trabalho_flutter/view/meus_veiculos_screen.dart';
import 'package:trabalho_flutter/view/registrar_abastecimento_screen.dart';
import 'package:trabalho_flutter/view/historico_abastecimentos_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login', 
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/home' : (context) => Home(),
        '/veiculos': (context) => MeusVeiculosScreen(),
        '/registrar-abastecimento': (context) => RegistrarAbastecimentoScreen(),
        '/historico-abastecimentos': (context) => HistoricoAbastecimentosScreen(),
      },
    );
  }
}
