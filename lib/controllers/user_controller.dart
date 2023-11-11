import 'package:advance_player_academy_players/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class UserController extends ChangeNotifier {
  UserModel _userModel = UserModel();

  UserModel get user => _userModel;

  getUserFromDb() async {
    if (FirebaseAuth.instance.currentUser != null) {
      try {
        DocumentSnapshot snap = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
        if (snap.exists) {
          _userModel = UserModel.fromDoc(snap);
          notifyListeners();
        } else {
          Get.snackbar("No User Found!", "", snackPosition: SnackPosition.BOTTOM);
        }
      } on FirebaseAuthException catch (error) {
        Get.snackbar(error.message.toString(), "", snackPosition: SnackPosition.BOTTOM);
      }
    } else {
      Get.snackbar("User is Not Logged In", "", snackPosition: SnackPosition.BOTTOM);
    }
  }
}
