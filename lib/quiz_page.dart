import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing_app/question.dart';

class QuizPage extends StatelessWidget {
  QuizPage({super.key});
  final question = ''.obs;
  final answerCont = TextEditingController();
  // final cities = ['cairo', 'paris', 'london', 'ws'];
  // final countries = ['egypt', 'usa', 'france', 'uk'];
  final questions = <Question>[
    Question(country: 'egypt', city: 'cairo'),
    Question(country: 'usa', city: 'ws'),
    Question(country: 'france', city: 'paris'),
    Question(country: 'uk', city: 'london'),
  ];
  final items =
      [
        'cairo',
        'paris',
        'london',
        'ws',
        'khartoum',
        'nasr city',
        'baghdad',
      ].obs;
  var index = 0, score = 0;
  var gameStarted = false.obs;
  var selected = false.obs;
  @override
  Widget build(BuildContext context) {
    final name = Get.arguments;
    return Scaffold(
      appBar: AppBar(title: Text("welcome $name")),
      body: Column(
        spacing: 20,
        children: [
          Obx(() => Text("$question")),
          Obx(
            () => DropdownMenu(
              onSelected: (val) {
                selected.value = val!.isNotEmpty;
              },
              controller: answerCont,
              enabled: gameStarted.value,
              hintText: "select your answer",
              requestFocusOnTap: true,
              enableFilter: true,
              enableSearch: true,
              dropdownMenuEntries: [
                for (var item in items)
                  DropdownMenuEntry(value: item, label: item),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  gameStarted.value = true;
                  index = 0;
                  score = 0;
                  question.value =
                      'what is the  capital of ${questions[index].country}';
                  // items.clear();
                  // items.addAll([
                  //   'cairo',
                  //   'paris',
                  //   'london',
                  //   'ws',
                  //   'khartoum',
                  //   'nasr city',
                  //   'baghdad',
                  // ]);
                  //! assign all (clear and add all)
                  items.assignAll([
                    'cairo',
                    'paris',
                    'london',
                    'ws',
                    'khartoum',
                    'nasr city',
                    'baghdad',
                  ]);
                  items.shuffle();
                },
                child: Text("start"),
              ),
              Obx(
                () => ElevatedButton(
                  onPressed:
                      selected.value
                          ? () {
                            selected.value = false;
                            if (answerCont.text.isEmpty) {
                              Get.snackbar("error", "please enter your answer");
                              return;
                            }
                            if (answerCont.text == questions[index].city) {
                              score++;
                              items.remove(answerCont.text);
                            }
                            index++;
                            if (index < questions.length) {
                              question.value =
                                  'what is the  capital of ${questions[index].country}';
                            } else {
                              // Get.snackbar("score", "your score is $score ");
                              Get.back(result: score);
                            }
                            answerCont.clear();
                          }
                          : null,
                  child: Text("answer"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
