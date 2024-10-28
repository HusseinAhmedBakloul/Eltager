import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class Notebook extends StatefulWidget {
  const Notebook({super.key});

  @override
  State<Notebook> createState() => _NotebookState();
}

class _NotebookState extends State<Notebook> {
  List<String> thoughtsList = [];
  List<String> imagesPathsList = [];
  List<Widget> thoughtsContainers = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadThoughts();
  }

  Future<void> _loadThoughts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      thoughtsList = prefs.getStringList('thoughtsList') ?? [];

      imagesPathsList = prefs
              .getStringList('imagesPathsList')
              ?.map((path) => path ?? '')
              .toList() ??
          [];

      if (thoughtsList.isEmpty) {
        thoughtsList.add('');
        imagesPathsList.add('');
      }
      _buildThoughtsContainers();
    });
  }

  Future<void> _saveThoughts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('thoughtsList', thoughtsList);

    await prefs.setStringList('imagesPathsList', imagesPathsList);
  }

  void addThoughtContainer() {
    setState(() {
      thoughtsList.add('');
      imagesPathsList.add('');
      _buildThoughtsContainers();
    });
    _saveThoughts();
  }

  Future<void> _pickImage(int index, {bool fromCamera = false}) async {
    final pickedFile = await _picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        imagesPathsList[index] = pickedFile.path;
      });
      _saveThoughts();
    }
  }

  void _buildThoughtsContainers() {
    thoughtsContainers = thoughtsList.asMap().entries.map((entry) {
      int index = entry.key;
      String thought = entry.value;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Container(
          height: 220,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.yellow,
            border: Border.all(width: 0.2, color: Colors.green),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: TextFormField(
                  initialValue: thought,
                  textDirection: TextDirection.rtl,
                  maxLines: null,
                  style: TextStyle(color: Colors.black, fontSize: 20),
                  onChanged: (value) {
                    setState(() {
                      thoughtsList[index] = value;
                    });
                    _saveThoughts();
                  },
                  decoration: InputDecoration(
                    hintText: 'ما الجديد في العمل...',
                    hintTextDirection: TextDirection.rtl,
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 160),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _pickImage(index, fromCamera: true),
                      icon: Icon(CupertinoIcons.camera, color: Colors.black),
                      label: Text("التقاط صورة",
                          style: TextStyle(color: Colors.black)),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightGreenAccent),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (imagesPathsList[index].isNotEmpty) {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              content: SizedBox(
                                width: double.infinity,
                                height:
                                    MediaQuery.of(context).size.height * 0.8,
                                child: Image.file(File(imagesPathsList[index]),
                                    fit: BoxFit.fill),
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("برجاء اختيار صورة أولاً")),
                          );
                        }
                      },
                      icon: Icon(CupertinoIcons.photo, color: Colors.black),
                      label: Text('عرض الصورة',
                          style: TextStyle(color: Colors.black)),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightGreenAccent),
                    ),
                  ],
                ),
              ),
              if (imagesPathsList[index].isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text("تم إضافة صورة!",
                      style: TextStyle(color: Colors.green, fontSize: 14)),
                ),
              Positioned(
                top: 5,
                left: 5,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      thoughtsList.removeAt(index);
                      imagesPathsList.removeAt(index);
                      _buildThoughtsContainers();
                    });
                    _saveThoughts();
                  },
                  child: Icon(CupertinoIcons.xmark_circle_fill,
                      color: Colors.red, size: 26),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: addThoughtContainer,
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.yellow,
                        border: Border.all(width: 0.2, color: Colors.green),
                      ),
                      child: Icon(CupertinoIcons.plus,
                          color: Colors.black, size: 28),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Column(
                  children: thoughtsContainers,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
