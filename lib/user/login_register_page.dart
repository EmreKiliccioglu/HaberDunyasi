import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import 'auth.dart';
import 'ui_login.dart';
import 'ui_register.dart';
import 'package:untitled5/user/error_handler.dart';

class LoginRegisterPage extends StatefulWidget {
  const LoginRegisterPage({super.key});

  @override
  State<LoginRegisterPage> createState() => _LoginRegisterPageState();
}

class _LoginRegisterPageState extends State<LoginRegisterPage>
    with SingleTickerProviderStateMixin {

  final Auth _auth = Auth();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() { setState(() {}); });
  }
//FIREBASE LOGIN
  Future<void> loginUser(String email, String password) async {
    try {
      await _auth.signIn(email: email, password: password);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.loginSuccess)),
      );

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomePage()),
            (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      final readable = getFriendlyErrorMessage(e,context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(readable)),
      );
    }
  }
//GOOGLE LOGIN
  Future<void> loginWithGoogle() async {
    try {
      await _auth.signOut();
      await _auth.signInWithGoogle();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.googleLoginSuccess)),
      );

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomePage()),
            (route) => false,
      );

    } catch (e) {
      if (!mounted) return;

      final readable = getFriendlyErrorMessage(e,context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(readable)),
      );
    }
  }
// REGISTER
  Future<void> registerUser(
      String email, String password, String firstName, String lastName) async {

    final scaffold = ScaffoldMessenger.of(context);
    final successMsg = AppLocalizations.of(context)!.registerSuccess;

    try {
      await _auth.createUser(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );

      scaffold.showSnackBar(
        SnackBar(content: Text(successMsg)),
      );

      _tabController.index = 0;

    } catch (e) {
      final readable = getFriendlyErrorMessage(e,context);

      scaffold.showSnackBar(
        SnackBar(content: Text(readable)),
      );
    }
  }
//UI
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final appBarGradient = LinearGradient(
      colors: [
        theme.colorScheme.primary,
        theme.colorScheme.primary.withValues(alpha: 0.8),
      ],
    );

    final tabLabelColor = theme.brightness == Brightness.dark
        ? Colors.white
        : Colors.black;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(gradient: appBarGradient),
            ),
            title: Text(
              AppLocalizations.of(context)!.newsWorld,
              style: theme.textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  height: 55,
                  decoration: BoxDecoration(
                    color: theme.cardColor.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    indicatorColor: Colors.transparent,
                    dividerColor: Colors.transparent,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorPadding: EdgeInsets.zero,
                    labelColor: tabLabelColor,
                    unselectedLabelColor: theme.textTheme.bodyMedium?.color,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    tabs: [
                      Tab(text: AppLocalizations.of(context)!.login),
                      Tab(text: AppLocalizations.of(context)!.register),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            UILogin(
              onLogin: loginUser,
              onGoogleLogin: loginWithGoogle,
            ),
            UIRegister(
              onRegister: registerUser,
            ),
          ],
        ),
      ),
    );
  }
}
