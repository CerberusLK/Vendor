import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:safeshopping/models/User.dart';
import 'package:safeshopping/services/FirestoreServices.dart';
import 'UserController.dart';

class AuthController extends GetxController {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Rx<FirebaseUser> _firebaseUser = Rx<FirebaseUser>();

  FirebaseUser get user => _firebaseUser.value;

  void onInit() {
    _firebaseUser.bindStream(_auth.onAuthStateChanged);
  }

  void createUser(String email, String password, String name) async {
    try {
      AuthResult _authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      //create a user document in firestore
      UserModel _user =
          UserModel(id: _authResult.user.uid, name: name, email: email);
      if (await FirestoreServices().createNewUser(_user)) {
        Get.find<UserController>().user = _user;
        Get.find<UserController>().user =
            await FirestoreServices().getUser(_authResult.user.uid);
      }
    } catch (e) {
      print(e);
      Get.snackbar(
        "Error in Sign up",
        e.message,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  void login(String email, String password) async {
    try {
      AuthResult _authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      print(_authResult.user.uid);
      Get.find<UserController>().user =
          await FirestoreServices().getUser(_authResult.user.uid);
    } catch (e) {
      print(e);
      Get.snackbar(
        "Error in sign in",
        e.toString(),
        snackPosition: SnackPosition.TOP,
        snackStyle: SnackStyle.FLOATING,
      );
    }
  }

  void changeUserCredentials(String password) async {
    FirebaseUser firebaseUser = await _auth.currentUser();
    AuthResult authResult = await firebaseUser.reauthenticateWithCredential(
      EmailAuthProvider.getCredential(
        email: user.email,
        password: password,
      ),
    );
  }

  void changeUserPassword(String newPassword) async {
    try {
      FirebaseUser firebaseUser = await _auth.currentUser();
      user.updatePassword(newPassword);
      signOut();
    } catch (e) {
      Get.snackbar(
        "Error in change password",
        e.message,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  void signOut() async {
    try {
      await _auth.signOut();
      Get.find<UserController>().clear();
    } catch (e) {
      print(e);
      Get.snackbar(
        "Error in sign out",
        e.message,
        snackPosition: SnackPosition.TOP,
      );
    }
  }
}
