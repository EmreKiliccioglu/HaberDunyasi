import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class UIRegister extends StatefulWidget {
  final Future<void> Function(
      String email, String password, String firstName, String lastName) onRegister;
  const UIRegister({super.key, required this.onRegister});

  @override
  State<UIRegister> createState() => _UIRegisterState();
}

class _UIRegisterState extends State<UIRegister> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isLoading = false;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final inputFillColor = isDark ? Colors.grey[800] : Colors.grey[200];

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Image.asset('assets/images/app_icon.png'),
                ),
              ),


              const SizedBox(height: 30),

              TextField(
                controller: firstNameController,
                style: TextStyle(color: theme.textTheme.bodyLarge!.color),
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.name,
                  hintStyle: TextStyle(color: theme.textTheme.bodyMedium!.color),
                  prefixIcon: Icon(Icons.person, color: theme.iconTheme.color),
                  filled: true,
                  fillColor: inputFillColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 15),

              TextField(
                controller: lastNameController,
                style: TextStyle(color: theme.textTheme.bodyLarge!.color),
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.surname,
                  hintStyle: TextStyle(color: theme.textTheme.bodyMedium!.color),
                  prefixIcon: Icon(Icons.person_outline, color: theme.iconTheme.color),
                  filled: true,
                  fillColor: inputFillColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 15),

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
              const SizedBox(height: 15),

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

              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                style: TextStyle(color: theme.textTheme.bodyLarge!.color),
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.confirmPassword,
                  hintStyle: TextStyle(color: theme.textTheme.bodyMedium!.color),
                  prefixIcon: Icon(Icons.lock_outline, color: theme.iconTheme.color),
                  filled: true,
                  fillColor: inputFillColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              if (errorMessage != null)
                Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 20),

              GestureDetector(
                onTap: () async {
                  setState(() {
                    errorMessage = null;
                  });

                  final firstName = firstNameController.text.trim();
                  final lastName = lastNameController.text.trim();
                  final email = emailController.text.trim();
                  final password = passwordController.text.trim();
                  final confirmPassword = confirmPasswordController.text.trim();

                  if (firstName.isEmpty || lastName.isEmpty) {
                    setState(() {
                      errorMessage = AppLocalizations.of(context)!.enterFullName;
                    });
                    return;
                  }

                  if (password != confirmPassword) {
                    setState(() {
                      errorMessage = AppLocalizations.of(context)!.passwordsDoNotMatch;
                    });
                    return;
                  }

                  setState(() => isLoading = true);

                  await widget.onRegister(email, password, firstName, lastName);

                  firstNameController.clear();
                  lastNameController.clear();
                  emailController.clear();
                  passwordController.clear();
                  confirmPasswordController.clear();

                  setState(() => isLoading = false);
                },
                child: Container(
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
                      AppLocalizations.of(context)!.register,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
