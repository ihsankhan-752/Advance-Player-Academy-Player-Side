import 'package:advance_player_academy_players/models/user_model.dart';
import 'package:advance_player_academy_players/screens/home/trainers/trainers_screen.dart';
import 'package:advance_player_academy_players/themes/app_colors.dart';
import 'package:advance_player_academy_players/themes/text_styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'chat_main_screen.dart';

class UserChatList extends StatelessWidget {
  const UserChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.mainColor,
        onPressed: () {
          Get.to(() => TrainersScreen());
        },
        child: Icon(Icons.message, color: AppColors.primaryWhite),
      ),
      appBar: AppBar(
        title: Text("Chat"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .where('uids', arrayContains: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("Sorry Your Chat Section is Empty"),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var data = snapshot.data!.docs[index];
              getUser() {
                if (data['uids'][0] == FirebaseAuth.instance.currentUser!.uid) {
                  return data['uids'][1];
                } else {
                  return data['uids'][0];
                }
              }

              return StreamBuilder(
                stream: FirebaseFirestore.instance.collection('users').doc(getUser()).snapshots(),
                builder: (context, snap) {
                  if (!snap.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  UserModel userModel = UserModel.fromDoc(snap.data!);
                  return Column(
                    children: [
                      ListTile(
                        onTap: () {
                          Get.to(() => ChatMainScreen(trainerId: userModel.userId!));
                        },
                        leading: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(userModel.userImage!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Text(userModel.username!, style: AppTextStyle.H1),
                        subtitle: Text(
                          data['msg'],
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        trailing: Text(
                          timeago.format(
                            data['createdAt'].toDate(),
                          ),
                        ),
                      ),
                      Divider(height: 0.1),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
