import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gpapp/Controllers/NetworkControllers/ManualCalls.dart';
import 'package:gpapp/Controllers/NetworkControllers/Models.dart';
import 'package:gpapp/Screens/ProfileScreen.dart';
import 'package:gpapp/Screens/home_screen.dart';
import 'package:gpapp/Screens/authScreens/loginscreen.dart';
import 'package:gpapp/utils/colors.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'notification_screen.dart';

class Decider extends StatefulWidget {
  const Decider({Key? key}) : super(key: key);

  @override
  State<Decider> createState() => _DeciderState();
}

class _DeciderState extends State<Decider> {
  GetStorage ds = GetStorage();
  bool isLogin = false;
  var user;
  var ap = ManualAPICall();
  var isLoading = false;

  getUser() async {
    if (ds.read('user') != null) {
      user = await Member.fromJson(jsonDecode(jsonEncode(ds.read('user'))));
    } else {
      var userId = await ds.read("userId");
      user = await ap.getMemeberDetails(userId: "${userId}");
    }
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  takeToScreen() async {
    isLogin = await ds.read("isLogin") ?? false;
    print("$isLogin isLogin");
    if (isLogin == true) {
      await getUser();
      Get.offAll(() => user.isVerified ? HomeScreen() : ProfileScreen());
      //Get.offAll(() => HomeScreen());
    } else {
      ds.erase();
      Get.offAll(() => LoginScreen());
    }
  }

  String _debugLabelString = "";

  Future<void> initPlatformState() async {
    isLogin = await ds.read("isLogin") ?? false;
    if (!mounted || isLogin == false) return;
    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      print('NOTIFICATION OPENED HANDLER CALLED WITH: ${result}');
      var notify = result.notification.additionalData;
      if (notify!["nfscreen"] == "10") {
        Get.to(NotificationsScreen());
      }
      this.setState(() {
        _debugLabelString =
            "Opened notification: \n${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
      });
    });

    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      print('FOREGROUND HANDLER CALLED WITH: ${event}');

      /// Display Notification, send null to not display
      event.complete(null);

      this.setState(() {
        _debugLabelString =
            "Notification received in foreground notification: \n${event.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
      });
    });

    OneSignal.shared
        .setInAppMessageClickedHandler((OSInAppMessageAction action) {
      this.setState(() {
        _debugLabelString =
            "In App Message Clicked: \n${action.jsonRepresentation().replaceAll("\\n", "\n")}";
      });
    });
  }

  @override
  void initState() {
    // (() async {
    //   await getUser();
    //    takeToScreen();
    //   log("Hello ");
    //   log(user.toString());

    // })();
    takeToScreen();
    initPlatformState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPallete.backgroud,
      body: Center(
        child: CircularProgressIndicator(color: ColorPallete.primary),
      ),
    );
  }
}
