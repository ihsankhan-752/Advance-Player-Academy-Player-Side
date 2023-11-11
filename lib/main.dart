import 'package:advance_player_academy_players/controllers/get_trainer_details.dart';
import 'package:advance_player_academy_players/controllers/image_controller.dart';
import 'package:advance_player_academy_players/controllers/user_controller.dart';
import 'package:advance_player_academy_players/screens/splash/splash_screen.dart';
import 'package:advance_player_academy_players/services/chat_db_services.dart';
import 'package:advance_player_academy_players/themes/app_colors.dart';
import 'package:advance_player_academy_players/themes/text_styles.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';

import 'controllers/visibility_controller.dart';
import 'services/auth_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => VisibilityController()),
        ChangeNotifierProvider(create: (_) => UserController()),
        ChangeNotifierProvider(create: (_) => ImageController()),
        ChangeNotifierProvider(create: (_) => GetUserDetails()),
        ChangeNotifierProvider(create: (_) => ChatDbServices()),
      ],
      child: GetMaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(
              color: AppColors.primaryWhite,
            ),
            backgroundColor: Color(0xff3374B4),
            titleTextStyle: AppTextStyle.H1.copyWith(fontSize: 18, color: AppColors.primaryWhite),
            centerTitle: true,
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
          useMaterial3: true,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
