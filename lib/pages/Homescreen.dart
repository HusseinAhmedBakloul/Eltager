import 'package:eltager/Notes/Items.dart';
import 'package:eltager/Notes/Notebook.dart';
import 'package:eltager/Notes/newnotes.dart';
import 'package:eltager/Notes/notes.dart';
import 'package:flutter/material.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  late Widget container;

  @override
  void initState() {
    super.initState();
    container = const Newnotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'تي',
              style: TextStyle(
                  color: Color.fromARGB(255, 82, 136, 21),
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'AmiriQuran'),
            ),
            Text(
              'ملاحظا',
              style: TextStyle(
                  color: Color.fromARGB(255, 192, 176, 33),
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'AmiriQuran'),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          CategoriesName(
            updateSelectedCategory: updateSelectedCategory,
            selectedCategory: 'المهمة القادمة',
          ),
          Expanded(
            child: container,
          ),
        ],
      ),
    );
  }

  void updateSelectedCategory(String category) {
    setState(() {
      if (category == 'المهمة القادمة') {
        container = const Newnotes();
      } else if (category == 'المهام') {
        container = const Notes();
      } else if (category == 'الأجندة') {
        container = const Notebook();
      } else if (category == 'الأصناف') {
        container = const Items();
      }
    });
  }
}

class CategoriesName extends StatefulWidget {
  final Function(String) updateSelectedCategory;
  final String selectedCategory;

  const CategoriesName(
      {super.key,
      required this.updateSelectedCategory,
      required this.selectedCategory});

  @override
  _CategoriesNameState createState() => _CategoriesNameState();
}

class _CategoriesNameState extends State<CategoriesName> {
  late String selectedCategory;

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.selectedCategory;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Row(
          children: [
            categoryItem('المهمة القادمة'),
            categoryItem('المهام'),
            categoryItem('الأجندة'),
            categoryItem('الأصناف'),
          ],
        ),
      ),
    );
  }

  Widget categoryItem(String category) {
    bool isSelected = selectedCategory == category;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category;
        });
        widget.updateSelectedCategory(category);
      },
      child: Container(
        margin: const EdgeInsets.only(top: 20, right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.yellow,
          borderRadius: BorderRadius.circular(60),
        ),
        child: Text(
          category,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isSelected
                ? Colors.white
                : const Color.fromARGB(255, 12, 75, 14),
          ),
        ),
      ),
    );
  }
}
