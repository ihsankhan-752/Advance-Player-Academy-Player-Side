import 'package:advance_player_academy_players/models/user_model.dart';
import 'package:advance_player_academy_players/services/request_services.dart';
import 'package:advance_player_academy_players/themes/app_colors.dart';
import 'package:advance_player_academy_players/themes/text_styles.dart';
import 'package:advance_player_academy_players/widgets/custom_profile_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RequestToTrainerForJoining extends StatelessWidget {
  const RequestToTrainerForJoining({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Send Request"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').where('isCoach', isEqualTo: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("No Trainer Found!"),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              UserModel userModel = UserModel.fromDoc(snapshot.data!.docs[index]);
              if (userModel.players!.contains(FirebaseAuth.instance.currentUser!.uid)) {
                return SizedBox();
              } else {
                return Column(
                  children: [
                    CustomProfileCard(
                      image: userModel.userImage!,
                      title: userModel.username!,
                      subTitle: userModel.email!,
                      trailingWidget: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBlack,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            )),
                        onPressed: () async {
                          await RequestServices().sendRequestTrainer(userModel);
                        },
                        child: userModel.requests!.contains(FirebaseAuth.instance.currentUser!.uid)
                            ? Text(
                                "Invited",
                                style: AppTextStyle.H1.copyWith(
                                  color: AppColors.primaryWhite,
                                ),
                              )
                            : userModel.players!.contains(FirebaseAuth.instance.currentUser!.uid)
                                ? Text(
                                    "Chat",
                                    style: AppTextStyle.H1.copyWith(
                                      color: AppColors.primaryWhite,
                                    ),
                                  )
                                : Text(
                                    "Invite",
                                    style: AppTextStyle.H1.copyWith(
                                      color: AppColors.primaryWhite,
                                    ),
                                  ),
                      ),
                    ),
                    Divider(thickness: 0.1, height: 1),
                  ],
                );
              }
            },
          );
        },
      ),
    );
  }
}
