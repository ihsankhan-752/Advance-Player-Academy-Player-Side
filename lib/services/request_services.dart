import 'package:advance_player_academy_players/screens/home/chat/chat_main_screen.dart';
import 'package:advance_player_academy_players/services/notification_services.dart';
import 'package:advance_player_academy_players/widgets/show_custom_msg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../models/user_model.dart';

class RequestServices {
  sendRequestTrainer(UserModel userModel) async {
    try {
      DocumentSnapshot userSnap = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();

      if (userModel.requests!.contains(FirebaseAuth.instance.currentUser!.uid)) {
        showCustomMsg("Invitation Sent!");
      } else if (userModel.players!.contains(FirebaseAuth.instance.currentUser!.uid)) {
        Get.to(() => ChatMainScreen(trainerId: userModel.userId!));
      } else {
        await FirebaseFirestore.instance.collection('users').doc(userModel.userId).update({
          'requests': FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
        });
        await FirebaseFirestore.instance.collection('requests').add({
          'toUserId': userModel.userId,
          'fromUserId': FirebaseAuth.instance.currentUser!.uid,
          'createdAt': DateTime.now(),
        });
        await NotificationServices.sendNotificationToUser(
          title: "Request For Team Joining",
          body: "${userSnap['username']} Want to Join Your Team",
          userId: userModel.userId,
        );
      }
    } on FirebaseAuthException catch (e) {
      showCustomMsg(e.message.toString());
    }
  }

  cancelSendRequest(UserModel userModel, requestId) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userModel.userId).update({
        'requests': FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid]),
      });
      await FirebaseFirestore.instance.collection('requests').doc(requestId).delete();
    } on FirebaseException catch (e) {
      showCustomMsg(e.message.toString());
    }
  }

  cancelReceiveRequest(String trainerId, requestId) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
        'requests': FieldValue.arrayRemove([trainerId]),
      });
      await FirebaseFirestore.instance.collection('requests').doc(requestId).delete();
    } on FirebaseException catch (e) {
      showCustomMsg(e.message.toString());
    }
  }

  acceptReceiveRequest({String? trainerId, String? requestId}) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
        'trainers': FieldValue.arrayUnion([trainerId]),
        'requests': FieldValue.arrayRemove([trainerId]),
      });
      await FirebaseFirestore.instance.collection('users').doc(trainerId).update({
        'players': FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
      });
      await NotificationServices.sendNotificationToUser(
        title: "Request Accepted",
        body: "${snapshot['username']} Accept Request of Player Joining",
        userId: trainerId,
      );
      await FirebaseFirestore.instance.collection('requests').doc(requestId).delete();
    } on FirebaseAuthException catch (e) {
      showCustomMsg(e.message.toString());
    }
  }
}
