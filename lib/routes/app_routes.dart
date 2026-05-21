import 'package:flutter/widgets.dart';

import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/signup_screen.dart';
import '../features/auth/presentation/screens/splash_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/navigation/presentation/screens/main_navigation_screen.dart';
import 'route_names.dart';

class AppRoutes {
  static final Map<String, WidgetBuilder> routes = {
    RouteNames.splash: (context) => const SplashScreen(),
    RouteNames.login: (context) => const LoginScreen(),
    RouteNames.signup: (context) => const SignupScreen(),
    RouteNames.home: (context) => const HomeScreen(),
    RouteNames.main: (context) => const MainNavigationScreen(),
  };
}
