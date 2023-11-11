import 'package:advance_player_academy_players/models/team_model.dart';
import 'package:advance_player_academy_players/models/user_model.dart';
import 'package:advance_player_academy_players/screens/home/chat/chat_main_screen.dart';
import 'package:advance_player_academy_players/themes/text_styles.dart';
import 'package:advance_player_academy_players/widgets/custom_profile_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeamDetailsScreen extends StatelessWidget {
  final TeamModel teamModel;
  const TeamDetailsScreen({super.key, required this.teamModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(teamModel.teamName!),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Team Information",
              style: AppTextStyle.H1.copyWith(
                fontSize: 16,
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Team Name: ${teamModel.teamName}", style: AppTextStyle.H1),
                      SizedBox(height: 5),
                      Text("Team Owner: ${teamModel.teamOwnerName}", style: AppTextStyle.H1),
                      SizedBox(height: 5),
                      Text("Location: ${teamModel.teamLocation}", style: AppTextStyle.H1),
                      SizedBox(height: 5),
                      Text("Total Numbers Of Players: ${teamModel.players!.length}", style: AppTextStyle.H1),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Other Team Player Information",
              style: AppTextStyle.H1.copyWith(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where(FieldPath.documentId, whereIn: teamModel.players)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      UserModel userModel = UserModel.fromDoc(snapshot.data!.docs[index]);
                      return Column(
                        children: [
                          if (userModel.userId == FirebaseAuth.instance.currentUser!.uid)
                            SizedBox()
                          else
                            CustomProfileCard(
                              image: userModel.userImage!,
                              title: userModel.username!,
                              subTitle: userModel.email!,
                              trailingWidget: InkWell(
                                onTap: () {
                                  Get.to(() => ChatMainScreen(trainerId: userModel.userId!));
                                },
                                child: Icon(Icons.message),
                              ),
                            ),
                          Divider(height: 0.1),
                        ],
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
