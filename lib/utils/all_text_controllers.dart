import 'package:flutter/cupertino.dart';

class AppTextControllers {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController chatController = TextEditingController();

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
  }
}
