import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Newnotes extends StatefulWidget {
  const Newnotes({super.key});

  @override
  State<Newnotes> createState() => _NewnotesState();
}

class _NewnotesState extends State<Newnotes> {
  List<String> notesList = [];
  String selectedDateTime = 'وقت التذكير';
  String newNote = '';

  @override
  void initState() {
    super.initState();
    _loadNotes();
    _requestFCMToken();
  }

  // طلب الحصول على FCM Token
  Future<void> _requestFCMToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print("FCM Token: $token");
  }

  Future<void> _loadNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      notesList = prefs.getStringList('notesList') ?? [];
    });
  }

  Future<void> _saveNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('notesList', notesList);
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          ).toIso8601String();
        });
      }
    }
  }

  String formatDateTimeTo12Hour(DateTime dateTime) {
    String hour = dateTime.hour > 12
        ? (dateTime.hour - 12).toString()
        : dateTime.hour.toString();
    String minute = dateTime.minute.toString().padLeft(2, '0');
    String amPm = dateTime.hour >= 12 ? 'م' : 'ص';

    return '$hour:$minute $amPm';
  }

  Future<void> _saveAndSendNotification() async {
    if (newNote.isNotEmpty && selectedDateTime != 'وقت التذكير') {
      DateTime dateTime = DateTime.parse(selectedDateTime);

      if (dateTime.isBefore(DateTime.now())) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('يرجى اختيار تاريخ ووقت في المستقبل.'),
            duration: Duration(seconds: 3),
          ),
        );
        return;
      }

      String formattedTime = formatDateTimeTo12Hour(dateTime);
      String fullNote = "$newNote - $formattedTime";

      notesList.add(fullNote);
      await _saveNotes();

      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
          channelKey: 'task_channel',
          title: 'متنساش يا أبو على 💛',
          body: '$fullNote',
          notificationLayout: NotificationLayout.Default,
          displayOnBackground: true,
          displayOnForeground: true,
          locked: false,
        ),
        schedule: NotificationCalendar(
          year: dateTime.year,
          month: dateTime.month,
          day: dateTime.day,
          hour: dateTime.hour,
          minute: dateTime.minute,
          second: 0,
          preciseAlarm: true,
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('تم حفظ المهمة وسيتم إشعارك في الميعاد المحدد إن شاء الله'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(height: 20),
              _buildNoteInput(),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoteInput() {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.yellow,
        border: Border.all(width: 0.2, color: Colors.green),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: TextFormField(
          onChanged: (value) {
            setState(() {
              newNote = value;
            });
          },
          maxLines: null,
          style: const TextStyle(color: Colors.black, fontSize: 18),
          textDirection: TextDirection.rtl,
          decoration: const InputDecoration(
              hintText: 'أخبرني مهمتك الجديدة لأذكرك بها...',
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.black, fontSize: 18),
              hintTextDirection: TextDirection.rtl),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: _saveAndSendNotification,
            child: _buildButton('حفظ'),
          ),
          GestureDetector(
            onTap: () => _selectDateTime(context),
            child: _buildDateTimeButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String text) {
    return Container(
      height: 60,
      width: 90,
      decoration: BoxDecoration(
        color: Colors.lightGreenAccent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(width: .2, color: Colors.black),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimeButton() {
    return Container(
      width: 200,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.lightGreenAccent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(width: .2, color: Colors.black),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              selectedDateTime,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textDirection: TextDirection.rtl,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          const SizedBox(width: 10),
          const Icon(CupertinoIcons.calendar, color: Colors.black),
        ],
      ),
    );
  }
}
