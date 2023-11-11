import 'package:advance_player_academy_players/controllers/user_controller.dart';
import 'package:advance_player_academy_players/models/training_model.dart';
import 'package:advance_player_academy_players/models/user_model.dart';
import 'package:advance_player_academy_players/screens/home/request_screen/request_screen.dart';
import 'package:advance_player_academy_players/screens/home/widgets/custom_home_drawer.dart';
import 'package:advance_player_academy_players/services/notification_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'widgets/custom_training_card.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  NotificationServices notificationServices = NotificationServices();
  @override
  void initState() {
    Provider.of<UserController>(context, listen: false).getUserFromDb();
    notificationServices.getNotificationPermission();
    notificationServices.getDeviceToken();
    notificationServices.initNotification(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Home "),
          actions: [
            InkWell(
              onTap: () {
                Get.to(() => RequestScreen());
              },
              child: Icon(Icons.notification_important_outlined),
            ),
            SizedBox(width: 10),
          ],
        ),
        drawer: CustomHomeDrawer(),
        body: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
          builder: (context, userSnap) {
            if (!userSnap.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            UserModel userModel = UserModel.fromDoc(userSnap.data!);
            var trainers = List.from(userModel.trainers!);
            if (trainers.isEmpty) {
              return Center(
                child: Text("No Trainings Found"),
              );
            } else {
              return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('trainings')
                    .where('trainerId', whereIn: trainers)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text("No Training Founds"),
                    );
                  }
                  return GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    itemCount: snapshot.data!.docs.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      TrainingModel trainingModel = TrainingModel.fromDoc(snapshot.data!.docs[index]);
                      return CustomTrainingCard(trainingModel: trainingModel);
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
