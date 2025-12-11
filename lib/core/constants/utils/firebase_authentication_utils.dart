import 'package:coffee/core/constants/services/snackbar_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class FirebaseAuthenticationUtils {
  static Future<bool> createUserWithEmailAndPassword({
    required String emailAddress,
    required String password,
  }) async {
    try {
      final _ = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailAddress,
            password: password,
          );
      SnackbarService.showSuccessNotification("Created Successfully");
      return Future.value(true);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        SnackbarService.showErrorNotification(
          e.message ?? "Something Went Wrong",
        );
      } else if (e.code == 'email-already-in-use') {
        SnackbarService.showErrorNotification(
          e.message ?? "Something Went Wrong",
        );
      }
      return Future.value(false);
    } catch (e) {
      // SnackbarService.showErrorNotification("Something Went Wrong");
      return Future.value(false);
    }
  }
  static Future<bool> signInWithEmailAndPassword({
    required String emailAddress,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      SnackbarService.showSuccessNotification("Login Successfully");
      return true;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          SnackbarService.showErrorNotification("Invalid email format.");
          break;
        case 'user-disabled':
          SnackbarService.showErrorNotification("This account has been disabled.");
          break;
        case 'invalid-credential': // covers both user-not-found & wrong-password
          SnackbarService.showErrorNotification("Invalid email or password.");
          break;
        default:
          SnackbarService.showErrorNotification("Login failed. ${e.message}");
      }

      return false;
    } catch (e) {
      SnackbarService.showErrorNotification("Something went wrong.");
      return false;
    }
  }


}
