import 'package:flutter/material.dart';

import '../../themes/app_colors.dart';
import '../../utils/splash_timer.dart';
import '../../widgets/logo_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    splashTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryWhite,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: LogoWidget(),
        ),
      ),
    );
  }
}
