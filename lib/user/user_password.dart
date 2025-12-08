import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../l10n/app_localizations.dart';

class UserPasswordPage extends StatefulWidget {
  const UserPasswordPage({Key? key}) : super(key: key);

  @override
  State<UserPasswordPage> createState() => _UserPasswordPageState();
}

class _UserPasswordPageState extends State<UserPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  Future<void> resetPassword(BuildContext context) async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.forgotPassword_emptyEmail)),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.forgotPassword_emailSent)),
      );
    } on FirebaseAuthException catch (e) {
      String message = AppLocalizations.of(context)!.error;
      if (e.code == 'user-not-found') {
        message = AppLocalizations.of(context)!.forgotPassword_userNotFound;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: theme.textTheme.bodyLarge!.color,
        title: Text(
          AppLocalizations.of(context)!.forgotPassword,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: theme.textTheme.bodyLarge!.color,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 40),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Image.asset(
                "assets/images/app_icon.png",
                height: 130,
                width: 130,
              ),
            ),

            const SizedBox(height: 30),

            Text(
              AppLocalizations.of(context)!.forgotPassword_title,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyLarge!.color,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              AppLocalizations.of(context)!.forgotPassword_description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: theme.textTheme.bodyMedium!.color!.withValues(alpha: 0.7),
              ),
            ),

            const SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  if (theme.brightness == Brightness.light)
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                ],
              ),
              child: TextField(
                controller: emailController,
                style: TextStyle(color: theme.textTheme.bodyLarge!.color),
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 18, horizontal: 16),
                  labelText: AppLocalizations.of(context)!.email,
                  labelStyle: TextStyle(
                    color: theme.textTheme.bodyMedium!.color!.withValues(alpha: 0.8),
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 30),

            isLoading
                ? const CircularProgressIndicator()
                : GestureDetector(
              onTap: () => resetPassword(context),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    vertical: 18, horizontal: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xff5B86E5),
                      Color(0xff36D1DC),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueAccent.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.forgotPassword_sendButton,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
