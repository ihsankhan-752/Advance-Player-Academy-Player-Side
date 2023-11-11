import 'package:advance_player_academy_players/models/user_model.dart';
import 'package:advance_player_academy_players/screens/home/request_screen/request_to_trainer_for_joining.dart';
import 'package:advance_player_academy_players/screens/home/trainers/widgets/trainer_custom_card.dart';
import 'package:advance_player_academy_players/themes/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TrainersScreen extends StatelessWidget {
  const TrainersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.mainColor,
        onPressed: () {
          Get.to(() => RequestToTrainerForJoining());
        },
        child: Icon(Icons.add, color: AppColors.primaryWhite),
      ),
      appBar: AppBar(
        title: Text("Trainers"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('isCoach', isEqualTo: true)
            .where('players', arrayContains: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("No Trainers Found"),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              UserModel userModel = UserModel.fromDoc(snapshot.data!.docs[index]);
              return TrainerCustomCard(userModel: userModel);
            },
          );
        },
      ),
    );
  }
}
