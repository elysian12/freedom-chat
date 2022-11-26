import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freedom_chat/common/services/shared_service.dart';
import 'package:freedom_chat/models/user_model.dart';
import 'package:freedom_chat/modules/auth/repository/auth_repository.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository: authRepository, ref: ref);
});

final userProvider = StateNotifierProvider<UserNotifier, UserModel?>((ref) {
  return UserNotifier();
});

class UserNotifier extends StateNotifier<UserModel?> {
  UserNotifier() : super(null);

  void updateUser(UserModel? user) {
    state = user;
  }
}

final authStateChangeProvider = StreamProvider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges;
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;

  AuthController({required AuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref,
        super(false);

  void sendOtp(BuildContext context, String phoneNumber) async {
    state = true;
    await Future.delayed(const Duration(seconds: 2));
    // ignore: use_build_context_synchronously
    await _authRepository.sentOTP(phoneNumber, context);

    state = false;
  }

  void verifyOtp(BuildContext context, String phoneNumber) async {
    state = true;
    await Future.delayed(const Duration(seconds: 2));
    // ignore: use_build_context_synchronously
    await _authRepository.verifyOTP(phoneNumber, context);
    await _ref
        .watch(sharedServiceProvider)
        .setSharedUUID(_authRepository.currentUser!.uid);
    state = false;
  }

  Stream<UserModel?> getUserDat(String uid) {
    return _authRepository.getUserData(uid);
  }
}
