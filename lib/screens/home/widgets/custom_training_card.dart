import 'package:advance_player_academy_players/models/training_model.dart';
import 'package:advance_player_academy_players/screens/home/training_detail_screen.dart';
import 'package:advance_player_academy_players/themes/text_styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../themes/app_colors.dart';

class CustomTrainingCard extends StatelessWidget {
  final TrainingModel trainingModel;
  const CustomTrainingCard({super.key, required this.trainingModel});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Get.to(() => TrainingDetailScreen(trainingModel: trainingModel));
          },
          child: Container(
            height: 170,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(AppColors.primaryBlack.withOpacity(0.3), BlendMode.srcATop),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: trainingModel.image!,
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                    child: CircularProgressIndicator(value: downloadProgress.progress),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          ),
        ),
        Center(
          child: Text(trainingModel.categoryName!,
              style: AppTextStyle.H1.copyWith(
                fontSize: 14,
                color: AppColors.primaryWhite,
                fontWeight: FontWeight.bold,
              )),
        )
      ],
    );
  }
}
