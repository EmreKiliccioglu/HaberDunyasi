import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../l10n/app_localizations.dart';

String getFriendlyErrorMessage(dynamic error, BuildContext context) {
  final t = AppLocalizations.of(context)!;

  if (error is FirebaseAuthException) {
    switch (error.code) {
      case "invalid-email":
        return t.error_invalidEmail;
      case "user-not-found":
        return t.error_userNotFound;
      case "wrong-password":
        return t.error_wrongPassword;
      case "email-already-in-use":
        return t.error_emailInUse;
      case "weak-password":
        return t.error_weakPassword;
      case "channel-error":
        return t.error_channel;
      default:
        return t.error_general;
    }
  }

  return t.error_unknown;
}

