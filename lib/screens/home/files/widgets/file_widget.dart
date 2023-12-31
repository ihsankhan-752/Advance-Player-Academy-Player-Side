import 'package:advance_player_academy_players/screens/home/files/widgets/pdf_excel_doc_file.dart';
import 'package:advance_player_academy_players/screens/home/files/widgets/pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../utils/constant.dart';

companyFileWidget({dynamic data, BuildContext? context, bool isLocked = false}) {
  if (data['isPdf']) {
    return PdfExcelDocFileCompany(
      data: data,
      image: pdfImage,
      onPressed: () {
        Get.to(() => PdfViewer(url: data['url']));
      },
    );
  } else if (data['isDoc']) {
    return PdfExcelDocFileCompany(
      image: docImage,
      data: data,
      onPressed: () {
        launchURL(data['url']);
      },
    );
  } else if (data['isExcel']) {
    return PdfExcelDocFileCompany(
      image: excelImage,
      data: data,
      onPressed: () {
        launchURL(data['url']);
      },
    );
  } else {
    return const SizedBox();
  }
}

launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
