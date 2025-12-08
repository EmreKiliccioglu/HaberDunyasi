import 'package:flutter/material.dart';
import 'package:untitled5/l10n/app_localizations.dart';
import 'package:untitled5/main.dart';
import 'package:untitled5/user/login_register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled5/user/user_settings.dart';
import 'package:untitled5/user/user_info.dart';
import '../core/global.dart';

class MenuBar {
  static AppBar build({
    required String title,
    required BuildContext context,
  }) {
    final theme = Theme.of(context).colorScheme;

    return AppBar(
      elevation: 3,
      backgroundColor: theme.primary,
      title: Text(
        title,
        style: TextStyle(
          color: theme.onPrimary,
          fontSize: 20,
        ),
      ),
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.menu, color: theme.onPrimary),
          onPressed: () => _openLeftPanel(context),
        ),
      ),
    );
  }

  static void _openLeftPanel(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Panel',
      barrierColor: Colors.black38,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation1, animation2) {
        return Align(
          alignment: Alignment.centerLeft,
          child: ValueListenableBuilder<bool>(
            valueListenable: isDarkTheme, // theme değişimlerini takip ediyor
            builder: (context, isDark, child) {
              final cs = Theme.of(context).colorScheme;

              return Material(
                color: cs.surface,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                child: SizedBox(
                  width: 280,
                  height: double.infinity,
                  child: Column(
                    children: [
                      const SizedBox(height: 60),

                      FutureBuilder(
                        future: _getUserInfo(),
                        builder: (context, snapshot) {
                          String displayName = "";

                          if (snapshot.connectionState == ConnectionState.waiting) {
                            displayName = AppLocalizations.of(context)!.downloading;
                          } else if (snapshot.hasData) {
                            displayName = snapshot.data.toString();
                          } else {
                            displayName = AppLocalizations.of(context)!.guest;
                          }

                          return Column(
                            children: [
                              ClipOval(
                                child: Image.asset(
                                  "assets/images/app_icon.png",
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                displayName,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: cs.primary,
                                ),
                              ),
                              const SizedBox(height: 30),
                            ],
                          );
                        },
                      ),

                      _buildMenuButton(
                        context,
                        Icons.home,
                        AppLocalizations.of(context)!.homePage,
                            () => Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => HomePage()),
                              (route) => false,
                        ),
                      ),

                      _buildMenuButton(
                        context,
                        Icons.settings,
                        AppLocalizations.of(context)!.settings,
                            () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => UserSettingsPage()),
                        ),
                      ),

                      _buildMenuButton(
                        context,
                        Icons.info,
                        AppLocalizations.of(context)!.about,
                            () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => UserInfoPage()),
                        ),
                      ),

                      const Spacer(), // esnek boşluk
                      // Firebase auth ile kullanıcı oturum durumu
                      StreamBuilder<User?>(
                        stream: FirebaseAuth.instance.authStateChanges(),
                        builder: (context, snapshot) {
                          final user = snapshot.data; //kullanıcı giriş yaparsa user objesi

                          return _buildMenuButton(
                            context,
                            user == null ? Icons.login : Icons.logout,
                            user == null
                                ? AppLocalizations.of(context)!.login
                                : AppLocalizations.of(context)!.logout,
                                () async {
                              Navigator.of(context).pop();

                              if (user == null) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const LoginRegisterPage(),
                                  ),
                                );
                              } else {
                                await FirebaseAuth.instance.signOut();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(AppLocalizations.of(context)!.loggedOut),
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
      //panel açılma kapanma animasyonu
      transitionBuilder: (context, animation1, animation2, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1, 0),
            end: Offset.zero,
          ).animate(animation1),
          child: child,
        );
      },
    );
  }
// Auth kullanıcı kontrolü ve Firestore kullanıcı bilgileri çekme
  static Future<String?> _getUserInfo() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return null;

    final snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get();

    if (!snapshot.exists) return null;

    final firstName = (snapshot["firstName"] ?? "").toString().toUpperCase();
    final lastName = (snapshot["lastName"] ?? "").toString().toUpperCase();

    return "$firstName $lastName".trim();
  }
  //_buildMenuButton tasarım
  static Widget _buildMenuButton(
      BuildContext context,
      IconData icon,
      String title,
      VoidCallback? onTap,
      ) {
    final cs = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(
        icon,
        color: cs.primary,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: cs.onSurface,
        ),
      ),
      onTap: onTap,
    );
  }
}
