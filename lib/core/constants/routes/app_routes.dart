
import 'package:coffee/core/constants/routes/page_routes_name.dart';
import 'package:coffee/modules/authentication/create_account.dart';
import 'package:coffee/modules/authentication/login_screen.dart';
import 'package:flutter/material.dart';

abstract class AppRoutes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case PageRoutesName.login:
        return MaterialPageRoute(
          builder: (_) => LoginScreen(),
          settings: settings,
        );
      case PageRoutesName.register:
        return MaterialPageRoute(
          builder: (_) => CreateAccount(),
          settings: settings,
        );
      default: return MaterialPageRoute(builder: (_) => LoginScreen(),settings: settings);
    }
  }
}
