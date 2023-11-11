import 'package:advance_player_academy_players/models/user_model.dart';
import 'package:advance_player_academy_players/screens/home/chat/chat_main_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../themes/text_styles.dart';

class TrainerCustomCard extends StatelessWidget {
  final UserModel userModel;
  const TrainerCustomCard({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            Get.to(() => ChatMainScreen(trainerId: userModel.userId!));
          },
          leading: Container(
            height: 65,
            width: 65,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(08),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: userModel.userImage!,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                  child: CircularProgressIndicator(value: downloadProgress.progress),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ),
          title: Text(userModel.username!, style: AppTextStyle.H1),
          subtitle: Text(userModel.email!, style: AppTextStyle.H2),
          trailing: Icon(Icons.message, size: 20),
        ),
        Divider(),
      ],
    );
  }
}
