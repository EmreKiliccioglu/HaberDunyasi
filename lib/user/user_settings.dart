import 'package:flutter/material.dart' hide MenuBar;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled5/l10n/app_localizations.dart';
import 'package:untitled5/core/menu.dart';
import '../core/global.dart';


class UserSettingsPage extends StatefulWidget {
  const UserSettingsPage({super.key});

  @override
  State<UserSettingsPage> createState() => _UserSettingsPageState();
}

class _UserSettingsPageState extends State<UserSettingsPage> {
  bool _isDarkTheme = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool savedTheme = prefs.getBool('darkTheme') ?? false;
    setState(() => _isDarkTheme = savedTheme);
    isDarkTheme.value = savedTheme;
  }

  Future<void> _updateTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() => _isDarkTheme = value);
    isDarkTheme.value = value;
    await prefs.setBool('darkTheme', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MenuBar.build(title: AppLocalizations.of(context)!.settings, context: context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              title: Text(AppLocalizations.of(context)!.darkTheme),
              value: _isDarkTheme,
              onChanged: _updateTheme,
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.changeLanguage),
              trailing: DropdownButton<Locale>(
                value: appLocale.value,
                items: const [
                  DropdownMenuItem(
                    value: Locale('tr'),
                    child: Text("Türkçe"),
                  ),
                  DropdownMenuItem(
                    value: Locale('en'),
                    child: Text("English"),
                  ),
                ],
                onChanged: (Locale? newLocale) async {
                  if (newLocale == null) return;

                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  appLocale.value = newLocale;
                  await prefs.setString('appLanguage', newLocale.languageCode);
                  setState(() {});
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}
