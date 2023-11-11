import 'dart:async';

import 'package:advance_player_academy_players/screens/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../screens/auth/login_screen.dart';

splashTimer() {
  Timer(Duration(seconds: 3), () {
    if (FirebaseAuth.instance.currentUser != null) {
      Get.to(() => Home());
    } else {
      Get.to(LoginScreen());
    }
  });
}
