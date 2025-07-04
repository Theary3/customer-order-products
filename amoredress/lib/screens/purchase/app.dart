import 'package:flutter/material.dart';

import '../login/splash.dart';
import '../homepage/home.dart';
import '../homepage/search.dart';
import '../homepage/favorite.dart';
import 'details.dart';
import 'cart.dart';
import '../profile/order_history.dart';
import '../login/register_screen.dart';
import '../login/login_screen.dart';
import '../profile/profile_user.dart';
import '../login/onboarding_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      onGenerateRoute: (settings) {
        final uri = Uri.parse(settings.name ?? '');
        Widget page;
        if (uri.pathSegments.length == 2 && uri.pathSegments[0] == 'product') {
          final productName = uri.pathSegments[1];
          // Decode URI component in case productName has spaces or special chars
          final decodedName = Uri.decodeComponent(productName);

          return PageRouteBuilder(
            pageBuilder: (_, __, ___) =>
                ProductDetailPage(productName: decodedName),
            transitionsBuilder: (_, animation, __, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;
              var tween = Tween(
                begin: begin,
                end: end,
              ).chain(CurveTween(curve: curve));
              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          );
        }
        switch (settings.name) {
          case '/search':
            page = SearchPage();
            break;
          case '/favorites':
            page = FavoritesPage();
            break;
          case '/cart':
            page = CartPage();
            break;
          case '/profile':
            page = ProfileUser();
            break;
          case '/orderhistory':
            page = OrdersHistory();
            break;
          case '/register':
            page = RegisterScreen();
            break;
          case '/login':
            page = LoginScreen();
            break;
          case '/onboarding':
            page = OnboardingScreen();
            break;
          case '/home':
            page = HomePage();
            break;
          case '/signin':
            page = LoginScreen();
            break;

          default:
            page = HomePage();
        }

        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => page,
          transitionsBuilder: (_, animation, __, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            var tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
      },
    );
  }
}
