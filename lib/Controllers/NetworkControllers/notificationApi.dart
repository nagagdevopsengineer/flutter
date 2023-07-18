import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gpapp/Constants.dart';
import 'package:gpapp/models/notifications.dart';
import 'package:http/http.dart' as http;

class NotificationApi {
  GetStorage ds = GetStorage();
  var totalNotifications;
  Future getNotifications(int memberId, int limit, int offset) async {
    List<Notifications?> notificationList = [];
    var jsonObj = {
      "notificationList": List<Notifications?>,
      "totalNotifications": 0
    };
    try {
      http.Response response = await http.get(
        Uri.parse(Constants().baseUrl +
            "notifications?filter[where][memberid]=$memberId&filter[limit]=$limit&filter[offset]=$offset"),
      );
      totalNotifications = response.headers['x-total-count'];
      print("$totalNotifications jod kar ke itna hua");
      ds.write("totalNotifications", totalNotifications);
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        for (var i in data) {
          Notifications notifications = Notifications.fromJson(i);
          notificationList.add(notifications);
        }
        //ds.write("notificationsList", notificationList);
        jsonObj = {
          "notificationList": notificationList,
          "totalNotifications": totalNotifications
        };
      }
    } catch (e) {
      if (e is SocketException) {
        print("No Internet Connection");
      } else
        print("Unhandled exception: ${e.toString()}");
    }
    return jsonObj;
  }

  Future updateNotifications(
    int? notificationId,
    bool isRead,
    String? memberid,
    String? membername,
    String? notificationtype,
    String? notificationcontent,
    String? playerid,
    DateTime createdat,
  ) async {
    print("You are inside updateNotifications");
    try {
      http.Response response = await http.put(
        Uri.parse(Constants().baseUrl + "notifications/$notificationId"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          "id": notificationId,
          "isRead": isRead,
          "memberid": int.parse(memberid!),
          "membername": membername.toString(),
          "notificationtype": notificationtype.toString(),
          "notificationcontent": notificationcontent.toString(),
          "playerid": playerid.toString(),
          "createdat": createdat.toString(),
        }),
      );
      print("Response is: ${response.body.toString()}");
      log(isRead.toString());
      if (response.statusCode == 200) {
        print("Notification Read");
      }
    } catch (e) {
      if (e is SocketException) {
        // Get.snackbar("No Internet Connection", "Connect to the Internet",
        //     snackPosition: SnackPosition.BOTTOM);
        print("No Internet Connection");
      } else
        print("Unhandled exception: ${e.toString()}");
    }
  }
}
