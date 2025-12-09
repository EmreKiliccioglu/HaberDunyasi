import 'package:flutter/material.dart' hide MenuBar;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled5/finance/main_finance.dart';
import 'package:untitled5/pharmacy/main_pharmacy.dart';
import 'core/global.dart';
import 'l10n/app_localizations.dart';
import 'core/main_button.dart';
import 'news/main_news.dart';
import 'football/main_football.dart';
import 'weather/main_weather.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/firebase_options.dart';
import 'core/app_theme.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SharedPreferences prefs = await SharedPreferences.getInstance(); //uygulama açılırken son tema
  bool savedTheme = prefs.getBool('darkTheme') ?? false;
  isDarkTheme.value = savedTheme;

  String? savedLanguageCode = prefs.getString('appLanguage'); //uygulama açılırken son dil
  if (savedLanguageCode != null) {
    appLocale.value = Locale(savedLanguageCode);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) { //uygulama içi anlık dil ve tema değişimi
    return ValueListenableBuilder<Locale>(
      valueListenable: appLocale,
      builder: (context, locale, child) {
        return ValueListenableBuilder<bool>(
          valueListenable: isDarkTheme,
          builder: (context, darkMode, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              locale: locale,
              supportedLocales: const [
                Locale('tr'),
                Locale('en'),
              ],
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
              home: HomePage(),
            );
          },
        );
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0; // Alt buton için sekme değerini tutan değişken

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ]; // SEKME GEÇMİŞİ TUTMAK İÇİN GLOBALKEY

  void _selectTab(int index) {
    if (index == _currentIndex) {
      _navigatorKeys[index].currentState?.popUntil((r) => r.isFirst);
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  } // ALT BUTON SEKME TAKİP

  Widget _buildOffstageNavigator(int index, Widget child) {
    return Offstage(
      offstage: _currentIndex != index,
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(
            builder: (_) => child,
            settings: settings,
          );
        },
      ),
    );
  }

  //globalKey ile sekme geçmişi saklama
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        final NavigatorState? currentNavigator =
            _navigatorKeys[_currentIndex].currentState;

        if (currentNavigator != null && currentNavigator.canPop()) {
          currentNavigator.pop();
          return;
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            _buildOffstageNavigator(0, const MainFinance()),
            _buildOffstageNavigator(1, const MainFootball()),
            _buildOffstageNavigator(2, const MainNews()),
            _buildOffstageNavigator(3, const MainWeather()),
            _buildOffstageNavigator(4, const MainPharmacy()),
          ],
        ),
        bottomNavigationBar: CustomBottomNav(
          currentIndex: _currentIndex,
          onTap: _selectTab,
        ),
      ),
    );
  }
}

