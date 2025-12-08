import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
  ];

  /// No description provided for @hello.
  ///
  /// In tr, this message translates to:
  /// **'Merhaba'**
  String get hello;

  /// No description provided for @settings.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar'**
  String get settings;

  /// No description provided for @changeLanguage.
  ///
  /// In tr, this message translates to:
  /// **'Dili Değiştir'**
  String get changeLanguage;

  /// No description provided for @darkTheme.
  ///
  /// In tr, this message translates to:
  /// **'Koyu Tema'**
  String get darkTheme;

  /// No description provided for @guest.
  ///
  /// In tr, this message translates to:
  /// **'Misafir'**
  String get guest;

  /// No description provided for @downloading.
  ///
  /// In tr, this message translates to:
  /// **'Yükleniyor...'**
  String get downloading;

  /// No description provided for @homePage.
  ///
  /// In tr, this message translates to:
  /// **'Ana Sayfa'**
  String get homePage;

  /// No description provided for @about.
  ///
  /// In tr, this message translates to:
  /// **'Hakkında'**
  String get about;

  /// No description provided for @login.
  ///
  /// In tr, this message translates to:
  /// **'Giriş Yap'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In tr, this message translates to:
  /// **'Çıkış Yap'**
  String get logout;

  /// No description provided for @loggedOut.
  ///
  /// In tr, this message translates to:
  /// **'Çıkış Yapıldı'**
  String get loggedOut;

  /// No description provided for @finance.
  ///
  /// In tr, this message translates to:
  /// **'Finans'**
  String get finance;

  /// No description provided for @sport.
  ///
  /// In tr, this message translates to:
  /// **'Spor'**
  String get sport;

  /// No description provided for @news.
  ///
  /// In tr, this message translates to:
  /// **'Haberler'**
  String get news;

  /// No description provided for @weather.
  ///
  /// In tr, this message translates to:
  /// **'Hava'**
  String get weather;

  /// No description provided for @pharmacy.
  ///
  /// In tr, this message translates to:
  /// **'Eczane'**
  String get pharmacy;

  /// No description provided for @enterCityPrompt.
  ///
  /// In tr, this message translates to:
  /// **'Hava durumunu öğrenmek istediğiniz şehri girin'**
  String get enterCityPrompt;

  /// No description provided for @noData.
  ///
  /// In tr, this message translates to:
  /// **'Henüz Bilgi Yok'**
  String get noData;

  /// No description provided for @night.
  ///
  /// In tr, this message translates to:
  /// **'Gece'**
  String get night;

  /// No description provided for @date.
  ///
  /// In tr, this message translates to:
  /// **'Tarih'**
  String get date;

  /// No description provided for @time.
  ///
  /// In tr, this message translates to:
  /// **'Saat'**
  String get time;

  /// No description provided for @humidity.
  ///
  /// In tr, this message translates to:
  /// **'Nem'**
  String get humidity;

  /// No description provided for @loginSuccess.
  ///
  /// In tr, this message translates to:
  /// **'Giriş başarılı!'**
  String get loginSuccess;

  /// No description provided for @googleLoginSuccess.
  ///
  /// In tr, this message translates to:
  /// **'Google ile giriş başarılı!'**
  String get googleLoginSuccess;

  /// No description provided for @registerSuccess.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt başarılı!'**
  String get registerSuccess;

  /// No description provided for @newsWorld.
  ///
  /// In tr, this message translates to:
  /// **'Haber Dünyası'**
  String get newsWorld;

  /// No description provided for @error.
  ///
  /// In tr, this message translates to:
  /// **'Hata'**
  String get error;

  /// No description provided for @register.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt'**
  String get register;

  /// No description provided for @developer.
  ///
  /// In tr, this message translates to:
  /// **'Geliştirici'**
  String get developer;

  /// No description provided for @noOnDutyPharmacy.
  ///
  /// In tr, this message translates to:
  /// **'Bu il/ilçe için nöbetçi eczane bulunamadı.'**
  String get noOnDutyPharmacy;

  /// No description provided for @address.
  ///
  /// In tr, this message translates to:
  /// **'Adres'**
  String get address;

  /// No description provided for @phone.
  ///
  /// In tr, this message translates to:
  /// **'Tel'**
  String get phone;

  /// No description provided for @district.
  ///
  /// In tr, this message translates to:
  /// **'İlçe'**
  String get district;

  /// No description provided for @search.
  ///
  /// In tr, this message translates to:
  /// **'Ara'**
  String get search;

  /// No description provided for @onDutyPharmacy.
  ///
  /// In tr, this message translates to:
  /// **'Nöbetçi Eczane'**
  String get onDutyPharmacy;

  /// No description provided for @source.
  ///
  /// In tr, this message translates to:
  /// **'Kaynak'**
  String get source;

  /// No description provided for @linkNotOpen.
  ///
  /// In tr, this message translates to:
  /// **'Link açılamıyor'**
  String get linkNotOpen;

  /// No description provided for @score.
  ///
  /// In tr, this message translates to:
  /// **'Skor'**
  String get score;

  /// No description provided for @notPlayedYet.
  ///
  /// In tr, this message translates to:
  /// **'Henüz oynanmadı'**
  String get notPlayedYet;

  /// No description provided for @leagues.
  ///
  /// In tr, this message translates to:
  /// **'Ligler'**
  String get leagues;

  /// No description provided for @standings.
  ///
  /// In tr, this message translates to:
  /// **'Puan Durumu'**
  String get standings;

  /// No description provided for @fixture.
  ///
  /// In tr, this message translates to:
  /// **'Fikstür'**
  String get fixture;

  /// No description provided for @statistics.
  ///
  /// In tr, this message translates to:
  /// **'İstatistikler'**
  String get statistics;

  /// No description provided for @goal.
  ///
  /// In tr, this message translates to:
  /// **'Gol'**
  String get goal;

  /// No description provided for @team.
  ///
  /// In tr, this message translates to:
  /// **'Takım'**
  String get team;

  /// No description provided for @position.
  ///
  /// In tr, this message translates to:
  /// **'Sıra'**
  String get position;

  /// No description provided for @played.
  ///
  /// In tr, this message translates to:
  /// **'O'**
  String get played;

  /// No description provided for @wins.
  ///
  /// In tr, this message translates to:
  /// **'G'**
  String get wins;

  /// No description provided for @loses.
  ///
  /// In tr, this message translates to:
  /// **'L'**
  String get loses;

  /// No description provided for @points.
  ///
  /// In tr, this message translates to:
  /// **'P'**
  String get points;

  /// No description provided for @marketData.
  ///
  /// In tr, this message translates to:
  /// **'Piyasa Verileri'**
  String get marketData;

  /// No description provided for @showLess.
  ///
  /// In tr, this message translates to:
  /// **'Daha az göster'**
  String get showLess;

  /// No description provided for @showMore.
  ///
  /// In tr, this message translates to:
  /// **'Daha fazla göster'**
  String get showMore;

  /// No description provided for @exchangeRates.
  ///
  /// In tr, this message translates to:
  /// **'Döviz Kurları'**
  String get exchangeRates;

  /// No description provided for @buying.
  ///
  /// In tr, this message translates to:
  /// **'Alış'**
  String get buying;

  /// No description provided for @selling.
  ///
  /// In tr, this message translates to:
  /// **'Satış'**
  String get selling;

  /// No description provided for @goldPrices.
  ///
  /// In tr, this message translates to:
  /// **'Altın Fiyatları'**
  String get goldPrices;

  /// No description provided for @cryptocurrencies.
  ///
  /// In tr, this message translates to:
  /// **'Kripto Paralar'**
  String get cryptocurrencies;

  /// No description provided for @price.
  ///
  /// In tr, this message translates to:
  /// **'Değer'**
  String get price;

  /// No description provided for @changeRate.
  ///
  /// In tr, this message translates to:
  /// **'Oran'**
  String get changeRate;

  /// No description provided for @key.
  ///
  /// In tr, this message translates to:
  /// **'Şifre'**
  String get key;

  /// No description provided for @email.
  ///
  /// In tr, this message translates to:
  /// **'E-posta'**
  String get email;

  /// No description provided for @forgotPassword.
  ///
  /// In tr, this message translates to:
  /// **'Şifremi unuttum?'**
  String get forgotPassword;

  /// No description provided for @signInWithGoogle.
  ///
  /// In tr, this message translates to:
  /// **'Google ile giriş yap'**
  String get signInWithGoogle;

  /// No description provided for @confirmPassword.
  ///
  /// In tr, this message translates to:
  /// **'Şifreyi Tekrar Girin'**
  String get confirmPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In tr, this message translates to:
  /// **'Şifreler eşleşmiyor!'**
  String get passwordsDoNotMatch;

  /// No description provided for @enterFullName.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen ad ve soyad girin!'**
  String get enterFullName;

  /// No description provided for @name.
  ///
  /// In tr, this message translates to:
  /// **'Ad'**
  String get name;

  /// No description provided for @surname.
  ///
  /// In tr, this message translates to:
  /// **'Soyad'**
  String get surname;

  /// No description provided for @city.
  ///
  /// In tr, this message translates to:
  /// **'İl'**
  String get city;

  /// No description provided for @commodities.
  ///
  /// In tr, this message translates to:
  /// **'Emtialar'**
  String get commodities;

  /// No description provided for @currencyConverter.
  ///
  /// In tr, this message translates to:
  /// **'Para Birimi Dönüştürücü'**
  String get currencyConverter;

  /// No description provided for @close.
  ///
  /// In tr, this message translates to:
  /// **'Kapat'**
  String get close;

  /// No description provided for @calculate.
  ///
  /// In tr, this message translates to:
  /// **'Hesaplama'**
  String get calculate;

  /// No description provided for @tlAmount.
  ///
  /// In tr, this message translates to:
  /// **'Türk Lirası Miktarı'**
  String get tlAmount;

  /// No description provided for @userInfo.
  ///
  /// In tr, this message translates to:
  /// **'Haber Dünyası gündelik yaşamda ihtiyaç duyduğun tüm bilgi akışını tek bir uygulama altında toplamayı hedefleyen modern bir içerik platformudur. Finans piyasalarını takip etmek isteyenler için döviz, altın, kripto ve emtia verilerini anlık olarak sunar. Spor bölümünde lig puan durumları, maç sonuçları, fikstürler ve futbolcu istatistikleri yer alır. Türkiye gündemine dair önemli gelişmeler haber akışıyla kullanıcıya ulaştırılır. Ayrıca ile göre haftalık hava durumu tahminleri ve nöbetçi eczane bilgileri de uygulama içinde kolayca görüntülenebilir. Haber Dünyası  sade tasarımı, hızlı yapısı ve kapsamlı içerik desteğiyle kullanıcılarına pratik ve modern bir deneyim sunar.'**
  String get userInfo;

  /// No description provided for @selectCity.
  ///
  /// In tr, this message translates to:
  /// **'Şehir Seç'**
  String get selectCity;

  /// No description provided for @cityHint.
  ///
  /// In tr, this message translates to:
  /// **'Şehir seç veya ara'**
  String get cityHint;

  /// No description provided for @districtHint.
  ///
  /// In tr, this message translates to:
  /// **'İlçe seç veya ara'**
  String get districtHint;

  /// No description provided for @noDistrict.
  ///
  /// In tr, this message translates to:
  /// **'İlçe yok'**
  String get noDistrict;

  /// No description provided for @forgotPassword_description.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt olurken kullandığın e-posta adresini gir. Sana sıfırlama bağlantısı gönderelim.'**
  String get forgotPassword_description;

  /// No description provided for @forgotPassword_sendButton.
  ///
  /// In tr, this message translates to:
  /// **'Şifre Sıfırlama E-postası Gönder'**
  String get forgotPassword_sendButton;

  /// No description provided for @forgotPassword_emptyEmail.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen e-posta adresinizi girin'**
  String get forgotPassword_emptyEmail;

  /// No description provided for @forgotPassword_emailSent.
  ///
  /// In tr, this message translates to:
  /// **'Şifre sıfırlama e-postası gönderildi'**
  String get forgotPassword_emailSent;

  /// No description provided for @forgotPassword_title.
  ///
  /// In tr, this message translates to:
  /// **'Şifreni Sıfırla'**
  String get forgotPassword_title;

  /// No description provided for @forgotPassword_userNotFound.
  ///
  /// In tr, this message translates to:
  /// **'Bu e-posta ile kayıtlı kullanıcı bulunamadı'**
  String get forgotPassword_userNotFound;

  /// No description provided for @error_invalidEmail.
  ///
  /// In tr, this message translates to:
  /// **'Geçersiz e-posta adresi.'**
  String get error_invalidEmail;

  /// No description provided for @error_userNotFound.
  ///
  /// In tr, this message translates to:
  /// **'Bu e-posta ile kayıtlı kullanıcı bulunamadı.'**
  String get error_userNotFound;

  /// No description provided for @error_wrongPassword.
  ///
  /// In tr, this message translates to:
  /// **'Şifre yanlış.'**
  String get error_wrongPassword;

  /// No description provided for @error_emailInUse.
  ///
  /// In tr, this message translates to:
  /// **'Bu e-posta zaten kullanılıyor.'**
  String get error_emailInUse;

  /// No description provided for @error_weakPassword.
  ///
  /// In tr, this message translates to:
  /// **'Şifre çok zayıf.'**
  String get error_weakPassword;

  /// No description provided for @error_channel.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen tüm alanları doldurun.'**
  String get error_channel;

  /// No description provided for @error_general.
  ///
  /// In tr, this message translates to:
  /// **'Bir hata oluştu. Lütfen tekrar deneyin.'**
  String get error_general;

  /// No description provided for @error_unknown.
  ///
  /// In tr, this message translates to:
  /// **'Bir şeyler ters gitti. Lütfen tekrar deneyin.'**
  String get error_unknown;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
