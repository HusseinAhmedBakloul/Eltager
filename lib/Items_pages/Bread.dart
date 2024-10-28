import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Bread extends StatefulWidget {
  const Bread({super.key});

  @override
  State<Bread> createState() => _BreadState();
}

class _BreadState extends State<Bread> {
  final List<Map<String, dynamic>> transactions = [];
  double totalStock = 0.0;
  double totalReceived = 0.0;
  double totalDispatched = 0.0;

  TextEditingController weightController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController reasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('bread_transactions', jsonEncode(transactions));
    prefs.setDouble('bread_totalStock', totalStock);
    prefs.setDouble('bread_totalReceived', totalReceived);
    prefs.setDouble('bread_totalDispatched', totalDispatched);
  }

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedTransactions = prefs.getString('bread_transactions');
    if (savedTransactions != null) {
      setState(() {
        transactions.addAll(
            List<Map<String, dynamic>>.from(jsonDecode(savedTransactions)));
        totalStock = prefs.getDouble('bread_totalStock') ?? 0.0;
        totalReceived = prefs.getDouble('bread_totalReceived') ?? 0.0;
        totalDispatched = prefs.getDouble('bread_totalDispatched') ?? 0.0;
      });
    }
  }

  void addTransaction(bool isReceived) {
    double weight = double.tryParse(weightController.text) ?? 0.0;
    String date = dateController.text;
    String reason = reasonController.text;

    if (weight > 0 && date.isNotEmpty && reason.isNotEmpty) {
      try {
        DateTime transactionDate = DateTime.parse(_convertDateFormat(date));

        setState(() {
          transactions.add({
            'type': isReceived ? 'وارد' : 'منصرف',
            'weight': weight,
            'date': date,
            'reason': reason,
          });

          if (isReceived) {
            totalStock += weight;
            totalReceived += weight;
          } else {
            totalStock -= weight;
            totalDispatched += weight;
          }

          weightController.clear();
          dateController.clear();
          reasonController.clear();

          _saveData();
        });
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('خطأ في إدخال التاريخ'),
            content:
                const Text('يرجى إدخال التاريخ بالتنسيق الصحيح (DD/MM/YYYY).'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('موافق'),
              ),
            ],
          ),
        );
      }
    }
  }

  String _convertDateFormat(String date) {
    List<String> parts = date.split('/');
    if (parts.length == 3) {
      return '${parts[2]}-${parts[1]}-${parts[0]}'; // تحويل إلى YYYY-MM-DD
    } else {
      throw FormatException("Invalid date format");
    }
  }

  void _deleteTransaction(int index) {
    setState(() {
      totalStock -= transactions[index]['weight'] *
          (transactions[index]['type'] == 'وارد' ? 1 : -1);
      transactions.removeAt(index);
      _saveData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(CupertinoIcons.back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'إدارة مخزون العيش',
          style: TextStyle(
            color: Colors.green,
            fontFamily: 'Amiri',
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'إضافة عملية',
              style: TextStyle(
                color: Color.fromARGB(255, 192, 176, 33),
                fontSize: 26,
                fontWeight: FontWeight.bold,
                fontFamily: 'Amiri',
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    textDirection: TextDirection.rtl,
                    controller: weightController,
                    decoration: const InputDecoration(
                      labelText: 'الوزن (كجم)',
                      hintTextDirection: TextDirection.rtl,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    textDirection: TextDirection.rtl,
                    controller: dateController,
                    decoration: const InputDecoration(
                      labelText: 'التاريخ',
                      hintTextDirection: TextDirection.rtl,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              textDirection: TextDirection.rtl,
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'سبب العملية',
                hintTextDirection: TextDirection.rtl,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreenAccent,
                  ),
                  onPressed: () => addTransaction(true),
                  child: const Text(
                    'إضافة وارد',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreenAccent,
                  ),
                  onPressed: () => addTransaction(false),
                  child: const Text(
                    'إضافة منصرف',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              'تقرير الشهر',
              style: TextStyle(
                color: Color.fromARGB(255, 192, 176, 33),
                fontSize: 26,
                fontWeight: FontWeight.bold,
                fontFamily: 'Amiri',
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'إجمالي المخزون: ${totalStock.toStringAsFixed(1)} كجم',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 19,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'إجمالي الوارد: ${totalReceived.toStringAsFixed(1)} كجم',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 19,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'إجمالي المنصرف: ${totalDispatched.toStringAsFixed(1)} كجم',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 19,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'العمليات',
              style: TextStyle(
                color: Color.fromARGB(255, 192, 176, 33),
                fontSize: 26,
                fontWeight: FontWeight.bold,
                fontFamily: 'Amiri',
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return ListTile(
                  title: Text(
                    textDirection: TextDirection.rtl,
                    '${transaction['type']} - ${transaction['weight']} كجم',
                  ),
                  subtitle: Text(
                    textDirection: TextDirection.rtl,
                    '${transaction['date']} - ${transaction['reason']}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteTransaction(index),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
