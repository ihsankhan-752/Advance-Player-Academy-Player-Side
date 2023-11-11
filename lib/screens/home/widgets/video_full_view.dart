import 'package:advance_player_academy_players/models/training_model.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoFullView extends StatelessWidget {
  final TrainingModel trainerModel;
  const VideoFullView({super.key, required this.trainerModel});

  @override
  Widget build(BuildContext context) {
    String? youtubeVideoId = "";
    if (trainerModel.videoUrl == "") {
      youtubeVideoId = "";
    } else {
      youtubeVideoId = YoutubePlayer.convertUrlToId(trainerModel.videoUrl!);
    }

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            height: MediaQuery.of(context).size.height * 0.5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: YoutubePlayer(
                controller: YoutubePlayerController(
                  initialVideoId: youtubeVideoId!,
                  flags: YoutubePlayerFlags(
                    showLiveFullscreenButton: false,
                    hideThumbnail: true,
                    enableCaption: false,
                    forceHD: false,
                    autoPlay: false,
                    mute: false,
                  ),
                ),
                bottomActions: [
                  ProgressBar(isExpanded: false),
                ],
                showVideoProgressIndicator: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
