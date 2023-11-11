import 'package:get/get.dart';

showCustomMsg(String msg) {
  Get.snackbar(msg, "", snackPosition: SnackPosition.BOTTOM);
}
