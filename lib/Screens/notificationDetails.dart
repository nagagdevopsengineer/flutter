import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpapp/Controllers/CommonController.dart';
import 'package:gpapp/Controllers/NetworkControllers/ManualCalls.dart';
import 'package:gpapp/Widgets/CommonWidgets.dart';
import 'package:gpapp/models/notifications.dart';
import 'package:gpapp/utils/colors.dart';
import '../Controllers/NetworkControllers/Models.dart';
import '../Controllers/NetworkControllers/notificationApi.dart';

class NotificationDetails extends StatefulWidget {
  String title;
  String description;
  String date;
  NotificationDetails(
      {super.key,
      required this.title,
      required this.description,
      required this.date});

  @override
  State<NotificationDetails> createState() => _NotificationDetailsState();
}

class _NotificationDetailsState extends State<NotificationDetails> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  ManualAPICall api = ManualAPICall();
  Member? user;
  GetStorage ds = GetStorage();
  NotificationApi notificationApi = NotificationApi();
  List<Notifications?> notifications = [];
  var noti2;
  CommonController _commonControl = Get.put(CommonController());

  @override
  void initState() {
    _commonControl.getNotificationReadStatus(forceapi: true);
    user = Member.fromJson(json.decode(json.encode(ds.read("user"))));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: ColorPallete.backgroud,
      drawer: drawerWidget(
        user,
        context: context,
        key: _key,
      ),
      appBar: AppBarWidget(
        _key,
        title: " Detailed Notification",
        isBack: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Container(
            decoration: BoxDecoration(
              color: ColorPallete.white,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          widget.title,
                          softWrap: true,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.description,
                    style: GoogleFonts.inter(
                      color: Colors.grey,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.date,
                    style: GoogleFonts.inter(
                      color: Colors.grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
