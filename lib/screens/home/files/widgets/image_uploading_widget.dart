import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../themes/app_colors.dart';

class ImageUploadingWidget extends StatelessWidget {
  final File? selectedImage;
  final Function() onPressed;
  const ImageUploadingWidget({super.key, required this.selectedImage, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (selectedImage == null)
          Container(
            height: MediaQuery.of(context).size.height * 0.15,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primaryBlack.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: GestureDetector(onTap: onPressed, child: Icon(Icons.camera_alt_outlined, size: 35)),
            ),
          )
        else
          Container(
            height: MediaQuery.of(context).size.height * 0.15,
            width: double.infinity,
            decoration: BoxDecoration(
                border: Border.all(color: AppColors.primaryBlack.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: FileImage(File(selectedImage!.path)),
                )),
          ),
      ],
    );
  }
}
