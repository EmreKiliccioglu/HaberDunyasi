import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> createUser({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        try {
          await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "createdAt": FieldValue.serverTimestamp(),
          });
        } catch (e) {
          debugPrint("Firestore yazma hatası: $e");
          rethrow;
        }
      }
    } on FirebaseAuthException catch (e) {
      debugPrint("Auth hatası: $e");
      rethrow;
    } catch (e) {
      debugPrint("Bilinmeyen hata: $e");
      rethrow;
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      debugPrint("Giriş hatası: $e");
      rethrow;
    } catch (e) {
      debugPrint("Bilinmeyen hata: $e");
      rethrow;
    }
  }
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw Exception("Google girişi iptal edildi");

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        try {
          final names = user.displayName?.split(" ") ?? ["", ""];
          final firstName = names.isNotEmpty ? names.first : "";
          final lastName = names.length > 1 ? names.sublist(1).join(" ") : "";

          await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
            "firstName": firstName,
            "lastName": lastName,
            "email": user.email ?? "",
            "createdAt": FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
        } catch (e) {
          debugPrint("Firestore yazma hatası (Google): $e");
          rethrow;
        }
      }
    } on FirebaseAuthException catch (e) {
      debugPrint("Google Auth hatası: $e");
      rethrow;
    } catch (e) {
      debugPrint("Bilinmeyen Google girişi hatası: $e");
      rethrow;
    }
  }
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();
    } catch (e) {
      debugPrint("Çıkış hatası: $e");
      rethrow;
    }
  }
}
