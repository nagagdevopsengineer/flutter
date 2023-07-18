import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gpapp/Controllers/NetworkControllers/ManualCalls.dart';
import 'package:gpapp/Controllers/NetworkControllers/Models.dart';
import 'package:gpapp/Controllers/NetworkControllers/notificationApi.dart';
import 'package:gpapp/Controllers/PreferenceController.dart';
import 'package:gpapp/Screens/authScreens/loginscreen.dart';
import 'package:gpapp/Screens/home_screen.dart';
import 'package:gpapp/Screens/authScreens/otpScreen.dart';
import 'package:gpapp/models/notifications.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:path_provider/path_provider.dart';

class CommonController extends GetxController {
  var interestCount = 0.obs;
  var isIntrested = false.obs;
  var newInterestCount = 0.obs;
  var buttonText = "Show Interest".obs;
  var isAvail = false.obs;
  var ds = GetStorage();
  var isEditClicked = false.obs;
  var availableCamera;
  XFile? imageFile = null;
  var selectedRadio = 0.obs;
  var eventsinterestedIn = [].obs;
  var selectedPreferencesTag = [].obs;
  var currentPageIndex = 0.obs;
  late int memberId;
  var c = Get.put(PreferenceController());
  NotificationApi notificationApi = NotificationApi();
  int offset = 0;
  var notifCount;
  var noti3;
  int limit = 10;
  RxBool isNotificationAvailable = false.obs;
  List<Notifications?> notificationscount = [];

  Future getNotificationReadStatus({forceapi = true}) async {
    Member user;
    var userId;
    if (ds.read('user') != null) {
      user = await Member.fromJson(jsonDecode(jsonEncode(ds.read('user'))));
      userId = user.id;
      print(userId);
      print("mil gayi userID");
    } else {
      userId = c.user.value.id;
    }
    notifCount = await notificationApi.getNotifications(
        int.parse(userId.toString()), limit, 0);
    var number = int.parse(notifCount['totalNotifications']);
    print("number $number");
    try {
      noti3 = await notificationApi.getNotifications(
          int.parse(userId.toString()), number, offset);
      print("Mai pahuch gaya");
      print("Bhai $noti3");

      notificationscount = (noti3['notificationList']);
      //print("Bhai $notificationscount");
      List allIsRead = notificationscount.map((e) => e!.isRead).toList();
      //print(allIsRead);
      print(notificationscount.map((element) => element!.isRead));
      notificationscount.map((element) => element!.isRead).forEach((element) {
        if (element == false) {
          print(" setting what we need");
          isNotificationAvailable.value = true;
          return;
        }
      });
      if (allIsRead.every((element) => element == true)) {
        isNotificationAvailable.value = false;
      }
      print(isNotificationAvailable.value);
      //print("Bhai Yahi Chaiye");
      notificationscount = [];
    } catch (e) {
      print("Error $e");
    }
    return isNotificationAvailable.value;
  }

  //For Pagination

  setSelectedRadio(value) {
    selectedRadio.value = value;
  }

  // updateCheck() async {
  //   final newVersion = NewVersion(
  //       iOSAppStoreCountry: 'in',
  //       iOSId: 'com.gourmetplanet.gpapplication',
  //       androidId: 'com.gourmetplanet.gpapplication');

  //   var status = await newVersion.getVersionStatus();
  //   if (status != null) {
  //     newVersion.showUpdateDialog(
  //       context: Get.context!,
  //       versionStatus: status,
  //       allowDismissal: true,
  //       dialogTitle: "Update Available",
  //       dialogText: 'Please update the app to Continue',
  //       updateButtonText: 'Update',
  //     );
  //   }
  // }

  Rx<dynamic> user = Rx<dynamic>(null);

  Rx<TextEditingController> memberController = TextEditingController().obs;

  var isLoadingPreferences = true.obs;

  var preferenceText = "+ Add".obs;
  Color preferenceColor = Color(0xffC71616);
  var isLoading = true.obs;
  var isVeg = true.obs;

  var userIdOneSignal = "".obs;
  var api = ManualAPICall();

  getUser({forceAPI = false}) async {
    if (ds.read('user') != null && !forceAPI) {
      user.value = Member.fromJson(jsonDecode(jsonEncode(ds.read('user'))));
    } else {
      var userId = await ds.read("userId");
      user = await api.getMemeberDetails(userId: "${userId}");
    }
    isLoading.value = false;
  }

  @override
  void onInit() {
    // isVegSelected.value = ds.read('isVegSelected') ?? false;
    OneSignal.shared.setLogLevel(OSLogLevel.debug, OSLogLevel.none);
    OneSignal.shared.setAppId("1e762717-9354-4a94-b35a-1451b1e15c8d");
    if (Platform.isIOS) {
      var isSubscribedToNotifications =
          ds.read('isSubscribedToNotifications') ?? false;
      if (isSubscribedToNotifications) {
        OneSignal.shared
            .promptUserForPushNotificationPermission()
            .then((accepted) {
          ds.write('isSubscribedToNotifications', accepted);
        });
      }
      OneSignal.shared.getDeviceState().then((deviceState) {
        userIdOneSignal.value = deviceState!.userId!;
      });
    }
    // Check for update and show dialog to update the app if available

    //updateCheck();
    super.onInit();
  }
}

class LoginController extends GetxController {
  Rx<String> otpNumber = "".obs;
  GetStorage ds = GetStorage();
  var c = CommonController();
  Rx<TextEditingController> mobileNumber = TextEditingController().obs;
  Rx<TextEditingController> otpController = TextEditingController().obs;

  /// this will delete cache
  Future<void> _deleteCacheDir() async {
    final cacheDir = await getTemporaryDirectory();

    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
  }

  /// this will delete app's storage
  Future<void> _deleteAppDir() async {
    final appDir = await getApplicationSupportDirectory();

    if (appDir.existsSync()) {
      appDir.deleteSync(recursive: true);
    }
  }

  Logout() {
    ds.write("isLogin", false);
    mobileNumber.value.clear();
    otpNumber.value = "";
    c.memberController.value.clear();
    ds.erase();
    // _deleteAppDir();
    _deleteCacheDir();
  }

  sendMobileNumber() {
    if (mobileNumber.value.text != "" && mobileNumber.value.text.length == 10) {
      Get.snackbar("OTP Sent!", "", snackPosition: SnackPosition.BOTTOM);
      Get.to(() => otpScreen());
    } else {
      Get.snackbar("Please Enter Valid Mobile Number", "",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  sendOtp() {
    if (otpNumber.value != "" && otpNumber.value.length > 3) {
      Get.to(() => HomeScreen());
    } else if (otpNumber.value.length < 4) {
      Get.snackbar("Please Enter OTP", "", snackPosition: SnackPosition.BOTTOM);
    }
  }
}

class PaginationController extends GetxController {
  ScrollController scrollController = ScrollController();
  var isMoreDataAvailable = true.obs;
  var page = 1;

  void paginateTask() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        page++;
        getMoreTask(page);
      }
    });
  }

  void getMoreTask(var page) {}
}
