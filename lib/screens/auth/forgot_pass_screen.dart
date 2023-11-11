import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_services.dart';
import '../../widgets/buttons.dart';
import '../../widgets/custom_text_input.dart';
import '../../widgets/logo_widget.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    final authController = Provider.of<AuthController>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: SizedBox(height: 130, child: LogoWidget())),
            SizedBox(height: 25),
            CustomTextInput(controller: emailController, hintText: "E-mail"),
            SizedBox(height: 30),
            authController.isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : PrimaryButton(
                    title: "Reset",
                    onPressed: () async {
                      await authController.resetPassword(emailController.text);
                      emailController.clear();
                    }),
          ],
        ),
      ),
    );
  }
}
