import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap; //sekmeye tıklandığında çalışacak fonksiyonu tutar

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.shifting,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: AppLocalizations.of(context)!.finance),
        BottomNavigationBarItem(icon: Icon(Icons.sports_soccer), label: AppLocalizations.of(context)!.sport),
        BottomNavigationBarItem(icon: Icon(Icons.newspaper), label: AppLocalizations.of(context)!.news),
        BottomNavigationBarItem(icon: Icon(Icons.sunny), label: AppLocalizations.of(context)!.weather),
        BottomNavigationBarItem(icon: Icon(Icons.medical_services), label: AppLocalizations.of(context)!.pharmacy),
      ], // alt buton tasarımı
    );
  }
}
