import 'package:flutter/material.dart';
import 'package:untitled5/user/user_password.dart';
import '../l10n/app_localizations.dart';

class UILogin extends StatefulWidget {
  final Future<void> Function(String email, String password) onLogin;
  final Future<void> Function()? onGoogleLogin;
  const UILogin({super.key, required this.onLogin, this.onGoogleLogin});

  @override
  State<UILogin> createState() => _UILoginState();
}

class _UILoginState extends State<UILogin> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool isGoogleLoading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final inputFillColor = isDark ? Colors.grey[800] : Colors.grey[200];

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        height: size.height * 0.85,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 120,
              height: 120,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Image.asset('assets/images/app_icon.png'),
              ),
            ),


            const SizedBox(height: 40),

            TextField(
              controller: emailController,
              style: TextStyle(color: theme.textTheme.bodyLarge!.color),
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.email,
                hintStyle: TextStyle(color: theme.textTheme.bodyMedium!.color),
                prefixIcon: Icon(Icons.email, color: theme.iconTheme.color),
                filled: true,
                fillColor: inputFillColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: passwordController,
              obscureText: true,
              style: TextStyle(color: theme.textTheme.bodyLarge!.color),
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.key,
                hintStyle: TextStyle(color: theme.textTheme.bodyMedium!.color),
                prefixIcon: Icon(Icons.lock, color: theme.iconTheme.color),
                filled: true,
                fillColor: inputFillColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 15),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserPasswordPage()),
                  );
                },
                child: Text(
                  AppLocalizations.of(context)!.forgotPassword,
                  style: TextStyle(color: theme.colorScheme.primary),
                ),
              ),
            ),

            const SizedBox(height: 20),

            GestureDetector(
              onTap: () async {
                setState(() => isLoading = true);
                final email = emailController.text.trim();
                final password = passwordController.text.trim();
                await widget.onLogin(email, password);
                setState(() => isLoading = false);
              },
              child: Container(
                width: double.infinity,
                height: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.primary.withValues(alpha: 0.8)
                    ],
                  ),
                ),
                child: Center(
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                    AppLocalizations.of(context)!.login,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            GestureDetector(
              onTap: widget.onGoogleLogin == null
                  ? null
                  : () async {
                setState(() => isGoogleLoading = true);
                await widget.onGoogleLogin!();
                setState(() => isGoogleLoading = false);
              },
              child: Container(
                width: double.infinity,
                height: 55,
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: theme.dividerColor),
                ),
                child: Center(
                  child: isGoogleLoading
                      ? const CircularProgressIndicator()
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/google.png',
                        width: 24,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        AppLocalizations.of(context)!.signInWithGoogle,
                        style: TextStyle(
                          fontSize: 16,
                          color: theme.textTheme.bodyLarge!.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
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
