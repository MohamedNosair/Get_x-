import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:just_audio/just_audio.dart';
import 'package:testing_app/player.dart';
import 'package:testing_app/quiz_page.dart';
import 'package:testing_app/stat_page.dart';

class PlayerPage extends StatelessWidget {
  PlayerPage({super.key});
  final playerCount = TextEditingController();
  final enable = false.obs;
  final players = <Player>[];
  final file = GetStorage();

  AudioPlayer? soundPlayer;
  @override
  Widget build(BuildContext context) {
    final lastWinner = file.read("winner");
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            lastWinner == null
                ? SizedBox()
                : Text(
                  "last winner is $lastWinner",
                  style: TextStyle(fontSize: 20),
                ),
            SizedBox(height: 20),
            TextField(
              maxLength: 20,
              onChanged: (value) {
                enable.value = value.isNotEmpty;
              },
              controller: playerCount,
              decoration: InputDecoration(
                labelText: "enter player name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Obx(
              () => ElevatedButton(
                onPressed:
                    enable.value
                        ? () async {
                          if (players.any(
                            (element) => element.name == playerCount.text,
                          )) {
                            final p = players.firstWhere(
                              (p) => p.name == playerCount.text,
                            );
                            Get.snackbar(
                              "error",
                              "this player ${p.name} already played",
                            );
                            return;
                          }
                          soundPlayer = AudioPlayer();
                          soundPlayer?.stop();
                          final score = await Get.to(
                            QuizPage(),
                            arguments: playerCount.text,
                          );

                          if (score != null) {
                            Get.snackbar("score", "your score is $score ");
                            players.add(
                              Player(name: playerCount.text, score: score),
                            );
                            soundPlayer = AudioPlayer();
                            if (score > 2) {
                              await soundPlayer?.setAsset(
                                'assets/media/success.mp3',
                              );
                              soundPlayer?.play();
                            } else {
                              await soundPlayer?.setAsset(
                                'assets/media/fail.mp3',
                              );
                              soundPlayer?.play();
                            }
                          } else {
                            Get.snackbar("error", "innvalid score");
                          }
                        }
                        : null,
                child: Text("play"),
              ),
            ),
            TextButton(
              onPressed: () {
                final winner = players.maxBy((p) => p.score);

                if (winner == null) {
                  Get.snackbar("error", "no players yet");
                  return;
                }

                Get.snackbar(
                  "winner",
                  "the winner is ${winner.name} with score ${winner.score}",
                );
                file.write('winner', winner.name);
                Get.to(StatPage(), arguments: players);
              },
              child: Text("winner"),
            ),
          ],
        ),
      ),
    );
  }
}
