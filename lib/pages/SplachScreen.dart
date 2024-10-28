import 'package:eltager/pages/homescreen.dart';
import 'package:flutter/material.dart';
import 'dart:async'; 

class Splachscreen extends StatefulWidget {
  const Splachscreen({super.key});

  @override
  State<Splachscreen> createState() => _SplachscreenState();
}

class _SplachscreenState extends State<Splachscreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _imageAnimation;
  late Animation<double> _textAnimation;

  @override
  void initState() {
    super.initState();

    // إعداد AnimationController
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _imageAnimation =
        Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    _textAnimation =
        Tween<double>(begin: -1.0, end: 0.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    _controller.forward();

    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const Homescreen())); 
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.only(right: 20, left: 20, top: 140),
          child: Column(
            children: [
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(_controller),
                child: Image.asset(
                  'Images/agricultural-man-with-baskets-full-veggies_52683-22992-removebg-preview.png',
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(
                height: 120,
              ),
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(-1.0, 0.0), 
                  end: Offset.zero,
                ).animate(_controller),
                child: const Text(
                  'التاجـــر حســـن',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'AmiriQuran',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
