import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var name = ''.obs;
  final controller = TextEditingController();
  final names = ['ahmed', 'mohamed', 'ali', 'omar', 'hossam'];
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: DropdownMenu<String>(
            hintText: "select your name",
            requestFocusOnTap: true,
            enableFilter: true,
            enableSearch: true,
            dropdownMenuEntries: [
              for (var name in names)
                DropdownMenuEntry(value: name, label: name),
            ],
          ),
        ),
      ),
    );
  }
}
