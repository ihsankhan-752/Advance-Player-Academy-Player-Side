import 'package:advance_player_academy_players/controllers/user_controller.dart';
import 'package:advance_player_academy_players/screens/auth/login_screen.dart';
import 'package:advance_player_academy_players/screens/home/chat/user_chat_list.dart';
import 'package:advance_player_academy_players/screens/home/files/files.dart';
import 'package:advance_player_academy_players/screens/home/teams/my_team_screen.dart';
import 'package:advance_player_academy_players/widgets/alert_dialog.dart';
import 'package:advance_player_academy_players/widgets/custom_list_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../themes/app_colors.dart';
import '../../../themes/text_styles.dart';
import '../trainers/trainers_screen.dart';

class CustomHomeDrawer extends StatelessWidget {
  const CustomHomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<UserController>(context).user;
    return Drawer(
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.25,
            width: double.infinity,
            color: AppColors.mainColor,
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(height: 20),
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(userController.userImage ?? ""),
              ),
              SizedBox(height: 10),
              Text(
                userController.username ?? "",
                style: AppTextStyle.H1.copyWith(color: AppColors.primaryWhite, fontSize: 16),
              ),
              SizedBox(height: 2),
              Text(
                userController.email ?? "",
                style: AppTextStyle.H1.copyWith(color: AppColors.primaryWhite, fontSize: 14),
              ),
            ]),
          ),
          CustomListTile(
            icon: FontAwesomeIcons.dumbbell,
            title: 'Trainings',
            onPressed: () async {
              Get.back();
            },
          ),
          CustomListTile(
            icon: FontAwesomeIcons.baseball,
            title: 'My Team',
            onPressed: () async {
              Get.to(() => MyTeamScreen());
            },
          ),
          CustomListTile(
            icon: Icons.file_copy,
            title: 'Files',
            onPressed: () async {
              Get.to(() => FilesScreen());
            },
          ),
          CustomListTile(
            icon: Icons.groups,
            title: 'Trainers',
            onPressed: () async {
              Get.to(() => TrainersScreen());
            },
          ),
          CustomListTile(
            icon: Icons.chat,
            title: 'Chat',
            onPressed: () async {
              Get.to(() => UserChatList());
            },
          ),
          CustomListTile(
            icon: Icons.logout,
            title: 'Log Out',
            onPressed: () async {
              customAlertDialog(context, () async {
                await FirebaseAuth.instance.signOut();
                Get.to(() => LoginScreen());
              }, 'Are you Sure to LogOut?');
            },
          )
        ],
      ),
    );
  }
}
