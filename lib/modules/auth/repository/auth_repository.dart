import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freedom_chat/common/constants/colors.dart';
import 'package:freedom_chat/common/utils/utils.dart';
import 'package:freedom_chat/models/user_model.dart';
import 'package:freedom_chat/modules/auth/controller/auth_controller.dart';
import 'package:freedom_chat/modules/auth/screens/otp_screen.dart';
import 'package:freedom_chat/modules/chat/screens/chat_screen.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
      firebaseAuth: FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance,
      ref: ref);
});

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final ProviderRef _ref;

  AuthRepository(
      {required FirebaseAuth firebaseAuth,
      required FirebaseFirestore firestore,
      required ProviderRef ref})
      : _firebaseAuth = firebaseAuth,
        _firestore = firestore,
        _ref = ref;

  String _verificationId = '';
  String phoneNumber = '';

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  User? get currentUser => _firebaseAuth.currentUser;

  Future<void> sentOTP(String phoneNumber, BuildContext context) async {
    this.phoneNumber = phoneNumber;
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: '+91$phoneNumber',
        verificationCompleted: (phoneAuthCredential) {},
        verificationFailed: (ex) {
          showSnackBar(context, ex.message!, backroundColor: kErrorColor);
        },
        codeSent: (verificationId, forceResendingToken) {
          _verificationId = verificationId;
          showSnackBar(context, 'Otp sent to $phoneNumber');
          Navigator.pushNamed(context, OtpScreen.routeName);
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!, backroundColor: kErrorColor);
    }
  }

  Future<void> verifyOTP(String otp, BuildContext context) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: otp,
      );

      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      if (userCredential.user == null) {
        // ignore: use_build_context_synchronously
        showSnackBar(context, 'something went Wrong !!!');
      } else {
        var user = await getUserData(userCredential.user!.uid).first;

        if (user != null) {
          _ref.watch(userProvider.notifier).updateUser(user);
          // ignore: use_build_context_synchronously
          Navigator.pushNamedAndRemoveUntil(
              context, ChatScreen.routeName, (route) => false);
        } else {
          user = UserModel(
            name: 'Untitled',
            profilePic:
                'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__480.png',
            phoneNumber: _firebaseAuth.currentUser!.phoneNumber!,
            uid: userCredential.user!.uid,
            isOnline: true,
          );
          await _firestore
              .collection('users')
              .doc(userCredential.user!.uid)
              .set(user.toMap());
          _ref.watch(userProvider.notifier).updateUser(user);
          // ignore: use_build_context_synchronously
          Navigator.pushNamedAndRemoveUntil(
              context, ChatScreen.routeName, (route) => false);
        }
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Stream<UserModel?> getUserData(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((event) {
      if (event.exists) {
        return UserModel.fromMap(event.data()!);
      } else {
        return null;
      }
    });
  }
}
