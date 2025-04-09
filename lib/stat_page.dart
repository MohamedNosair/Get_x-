// import 'dart:math';

import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:testing_app/player.dart';

class StatPage extends StatelessWidget {
  StatPage({super.key});

  // var players = List.generate(
  //   100,
  //   (index) => Player(name: 'player $index', score: Random().nextInt(5)),
  // );
  var players = <Player>[].obs;
  var playerOriginal = <Player>[];
  final sortByName = false.obs;
  final sortByScore = false.obs;
  @override
  Widget build(BuildContext context) {
    final result = Get.arguments ;
    players.addAll(result);
    playerOriginal.addAll(players);
    // players = players.sortedByDescending((p) => p.score).toList();
    // players = players.sortedBy((p) => p.name.split(' ')[1].toInt()).toList();
    // players.sort((a, b) {
    //   if (a.score != b.score) {
    //     return b.score.compareTo(a.score); // ترتيب تنازلي
    //     // return a.score.compareTo(b.score); ترتيب تصاعدي
    //   } else {
    //     final aIndex = int.parse(a.name.split(' ')[1]);
    //     final bIndex = int.parse(b.name.split(' ')[1]);
    //     return aIndex.compareTo(bIndex); // الـ index ثانياً
    //   }
    // });

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'search',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      players.value =
                          playerOriginal
                              .where((element) => element.name.contains(value))
                              .toList();
                    },
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    if (sortByScore.value) {
                      players.value =
                          players.sortedByDescending((p) => p.score).toList();
                    } else {
                      players.value = players.sortedBy((p) => p.score).toList();
                    }
                    sortByScore.value = !sortByScore.value;
                  },
                  label: Text('sort by score'),
                  icon: Icon(Icons.sort),
                ),
                TextButton.icon(
                  onPressed: () {
                    if (sortByName.value) {
                      players.value =
                          players.sortedByDescending((p) => p.name).toList();
                    } else {
                      players.value = players.sortedBy((p) => p.name).toList();
                    }
                    sortByName.value = !sortByName.value;
                  },
                  label: Text('sort by name'),
                  icon: Icon(Icons.sort),
                ),
              ],
            ),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  cacheExtent: 100,
                  itemBuilder: (ctx, index) {
                    if (players.isEmpty) return Center(child: Text('no data'));

                    return ListTile(
                      leading: Text(
                        players[index].name,
                        style: TextStyle(fontSize: 20),
                      ),
                      trailing: Text(
                        "${players[index].score}",
                        style: TextStyle(fontSize: 20),
                      ),
                    );
                  },
                  itemCount: players.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
