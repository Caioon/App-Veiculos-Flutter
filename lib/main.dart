import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trabalho_flutter/utils/app_theme.dart';
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
      theme: AppTheme.lightTheme,
      initialRoute: '/login',
      onGenerateRoute: (settings) {
        Widget page;
        
        switch (settings.name) {
          case '/login':
            page = LoginScreen();
            break;
          case '/signup':
            page = SignupScreen();
            break;
          case '/home':
            page = Home();
            break;
          case '/veiculos':
            page = MeusVeiculosScreen();
            break;
          case '/registrar-abastecimento':
            page = RegistrarAbastecimentoScreen();
            break;
          case '/historico-abastecimentos':
            page = HistoricoAbastecimentosScreen();
            break;
          default:
            page = LoginScreen();
        }

        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOutCubic;

            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );

            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 400),
        );
      },
    );
  }
}
