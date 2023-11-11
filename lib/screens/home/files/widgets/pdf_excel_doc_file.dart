import 'package:flutter/material.dart';

import '../../../../../../../themes/app_colors.dart';

class PdfExcelDocFileCompany extends StatelessWidget {
  final dynamic data;
  final String? image;
  final Function()? onPressed;
  PdfExcelDocFileCompany({Key? key, this.data, this.image, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed ?? () {},
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.mainColor),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 80, width: 100, child: Image.network(image!)),
            SizedBox(height: 20),
            Text(
              data['description'].toString().toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.primaryBlack,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
