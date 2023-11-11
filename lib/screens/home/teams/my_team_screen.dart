import 'package:advance_player_academy_players/models/team_model.dart';
import 'package:advance_player_academy_players/screens/home/teams/team_details_screen.dart';
import 'package:advance_player_academy_players/themes/text_styles.dart';
import 'package:advance_player_academy_players/widgets/custom_profile_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../themes/app_colors.dart';

class MyTeamScreen extends StatelessWidget {
  const MyTeamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Teams"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('teams')
            .where('players', arrayContains: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("You Are Not Add in Teams"),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              TeamModel teamModel = TeamModel.fromDoc(snapshot.data!.docs[index]);
              return Column(
                children: [
                  CustomProfileCard(
                    image: teamModel.teamLogo!,
                    title: teamModel.teamName!,
                    subTitle: "Owner :${teamModel.teamOwnerName}",
                    trailingWidget: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlack,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          )),
                      onPressed: () {
                        Get.to(() => TeamDetailsScreen(teamModel: teamModel));
                      },
                      child: Text(
                        "See Details",
                        style: AppTextStyle.H1.copyWith(
                          color: AppColors.primaryWhite,
                        ),
                      ),
                    ),
                  ),
                  Divider(height: 0.1),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
