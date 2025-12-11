import 'package:bot_toast/bot_toast.dart';
import 'package:coffee/core/constants/routes/app_routes.dart';
import 'package:coffee/core/constants/routes/page_routes_name.dart';
import 'package:coffee/core/constants/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'firebase_options.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeManager.themeData,
      initialRoute: PageRoutesName.login,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      builder: EasyLoading.init(builder: BotToastInit()),

    );
  }
}


