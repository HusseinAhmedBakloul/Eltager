import 'package:eltager/Items_pages/BarleyRice.dart';
import 'package:eltager/Items_pages/BathMixture.dart';
import 'package:eltager/Items_pages/Bread.dart';
import 'package:eltager/Items_pages/Precise.dart';
import 'package:eltager/Items_pages/Rada.dart';
import 'package:eltager/Items_pages/Sarsa.dart';
import 'package:eltager/Items_pages/Wheat.dart';
import 'package:eltager/Items_pages/WhiteCorn.dart';
import 'package:eltager/Items_pages/WhiteRice.dart';
import 'package:eltager/Items_pages/YellowCorn.dart';
import 'package:flutter/material.dart';

class Items extends StatefulWidget {
  const Items({super.key});

  @override
  State<Items> createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding:
            const EdgeInsets.only(right: 20, left: 20, top: 60, bottom: 40),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(300),
                  border: Border.all(color: Colors.black, width: .1)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(300),
                child: Image.asset('Images/cereals-set_1284-21149.jpg'),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Wheat()),
                      );
                    },
                    child: const CategoryWidget(
                      name: 'قمح',
                      imagePath:
                          'Images/bunch-wheat-stalks-field-transparent-background_1232542-15969-removebg-preview-removebg-preview.png',
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BarleyRice()),
                      );
                    },
                    child: const CategoryWidget(
                      name: 'أرز شعير',
                      imagePath:
                          'Images/close-up-paddy-rice-ears-isolated-transparent-background_1266257-14482-removebg-preview.png',
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WhiteRice()),
                      );
                    },
                    child: const CategoryWidget(
                      name: 'أرز أبيض',
                      imagePath:
                          'Images/dry-basmati-rice-wooden-bowl-isolated-transparent-background_84443-13263-removebg-preview.png',
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Bread()),
                      );
                    },
                    child: const CategoryWidget(
                      name: 'عيش',
                      imagePath:
                          'Images/breaking-bread_23-2147989506-removebg-preview.png',
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Sarsa()),
                      );
                    },
                    child: const CategoryWidget(
                      name: 'سرسة',
                      imagePath: 'Images/images-removebg-preview.png',
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Rada()),
                      );
                    },
                    child: const CategoryWidget(
                      name: 'رده',
                      imagePath:
                          'Images/tbl_articles_article_21046_70037bf3c04-be05-445e-ba87-c2381dc5f178-780x470.jpg',
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Precise()),
                      );
                    },
                    child: const CategoryWidget(
                      name: 'دقيق',
                      imagePath:
                          'Images/porridge-oats-oat-flour-isolated-transparent-background_617816-18830-removebg-preview.png',
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BathMixture()),
                      );
                    },
                    child: const CategoryWidget(
                      name: 'خلطة حمام',
                      imagePath:
                          'Images/de4bf637-9bd9-42eb-8f3f-d146161a3e52-1000x1000-I9BFvHtrD0pk6M0JkZK1u0PUMmAw29mQniFF7bxz.jpg',
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WhiteCorn()),
                      );
                    },
                    child: const CategoryWidget(
                      name: 'ذرة أبيض',
                      imagePath:
                          'Images/fresh-raw-corn-white-background_1262102-5260-removebg-preview.png',
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => YellowCorn()),
                      );
                    },
                    child: const CategoryWidget(
                      name: 'ذرة أصفر',
                      imagePath:
                          'Images/corn-isolated_74190-1593-removebg-preview.png',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryWidget extends StatelessWidget {
  final String name;
  final String imagePath;

  const CategoryWidget({required this.name, required this.imagePath, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, top: 60),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: Colors.black, width: .1)),
              child: Image.asset(
                imagePath,
                width: 80,
                height: 80,
                fit: BoxFit.fill,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
