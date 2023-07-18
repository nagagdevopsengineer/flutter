import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gpapp/Constants.dart';
import 'package:gpapp/Controllers/NetworkControllers/Models.dart';
import 'package:gpapp/Controllers/PreferenceController.dart';
import 'package:gpapp/Controllers/SignUpController.dart';
import 'package:gpapp/Screens/authScreens/loginscreen.dart';
import 'package:gpapp/Screens/authScreens/verify_mobile_screen.dart';
import 'package:gpapp/models/RewardsModel.dart';
import 'package:gpapp/models/notifications.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

class ManualAPICall {
  GetStorage ds = GetStorage();

  // //GetStorage ds = GetStorage();
  // var totalNotifications;
  // Future getNotifications(int memberId, int limit, int offset) async {
  //   List<Notifications?> notificationList = [];
  //   var jsonObj = {
  //     "notificationList": List<Notifications?>,
  //     "totalNotifications": 0
  //   };
  //   try {
  //     http.Response response = await http.get(
  //       Uri.parse(Constants().baseUrl +
  //           "notifications?filter[where][memberid]=$memberId&filter[limit]=$limit&filter[offset]=$offset"),
  //     );
  //     totalNotifications = response.headers['x-total-count'];
  //     print("$totalNotifications jod kar ke itna hua");
  //     //ds.write("totalNotifications", totalNotifications);
  //     if (response.statusCode == 200) {
  //       List<dynamic> data = jsonDecode(response.body);
  //       for (var i in data) {
  //         Notifications notifications = Notifications.fromJson(i);
  //         notificationList.add(notifications);
  //       }
  //       //ds.write("notificationsList", notificationList);
  //       jsonObj = {
  //         "notificationList": notificationList,
  //         "totalNotifications": totalNotifications
  //       };
  //     }
  //   } catch (e) {
  //     if (e is SocketException) {
  //       print("No Internet Connection");
  //     } else
  //       print("Unhandled exception: ${e.toString()}");
  //   }
  //   return jsonObj;
  // }

  // Future updateNotifications(
  //   int? notificationId,
  //   bool isRead,
  //   String? memberid,
  //   String? membername,
  //   String? notificationtype,
  //   String? notificationcontent,
  //   String? playerid,
  //   DateTime createdat,
  // ) async {
  //   print("You are inside updateNotifications");
  //   try {
  //     http.Response response = await http.put(
  //       Uri.parse(Constants().baseUrl + "notifications/$notificationId"),
  //       headers: {
  //         'Content-Type': 'application/json',
  //       },
  //       body: jsonEncode(<String, dynamic>{
  //         "id": notificationId,
  //         "isRead": isRead,
  //         "memberid": int.parse(memberid!),
  //         "membername": membername.toString(),
  //         "notificationtype": notificationtype.toString(),
  //         "notificationcontent": notificationcontent.toString(),
  //         "playerid": playerid.toString(),
  //         "createdat": createdat.toString(),
  //       }),
  //     );
  //     print("Response is: ${response.body.toString()}");
  //     log(isRead.toString());
  //     if (response.statusCode == 200) {
  //       print("Notification Read");
  //     }
  //   } catch (e) {
  //     if (e is SocketException) {
  //       // Get.snackbar("No Internet Connection", "Connect to the Internet",
  //       //     snackPosition: SnackPosition.BOTTOM);
  //       print("No Internet Connection");
  //     } else
  //       print("Unhandled exception: ${e.toString()}");
  //   }
  // }

  // getNotificationDetails() async {
  //   // var url = "${Constants().baseURL}/notifications/$id";
  //   var response =
  //       await http.get(Uri.parse(Constants().baseUrl + "/notifications"));
  //   var allNotifications = [];
  //   if (response.statusCode == 200) {
  //     var jsonResponse = json.decode(response.body);

  //     for (var notification in jsonResponse) {
  //       allNotifications.add(NotificationModel.fromJson(notification));
  //     }
  //   }
  //   return allNotifications;
  // }

  getMemeberDetails({userId}) async {
    // try {
    var response = await http.get(Uri.parse(
        Constants().baseUrl + "members?filter[where][userId]=$userId"));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);

      Member memberData = Member.fromJson(jsonResponse[0]);
      print("$memberData memberData");

      ds.write("user", memberData);
      return memberData;
    } else {
      if (ds.read("user") != null) {
        return Member.fromJson(json.decode(json.encode(ds.read("user"))));
      }
      return null;
    }
    // } catch (e) {
    //   return null;
    // }
  }

  getRestaurants() async {
    var restaurants = [];
    // try {
    var response = await http.get(Uri.parse(Constants().baseUrl +
        "restaurantswdiscounts?&filter[where][isDeleted]=false"));

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      for (var rest in jsonResponse) {
        Restaurant restauratnData = Restaurant.fromJson(rest);
        restaurants.add(restauratnData);
      }
      ds.write("restaurants", restaurants);
      return restaurants;
    } else {
      if (ds.read("restaurants") != null) {
        var rest = json.decode(json.encode(ds.read("restaurants")));
        for (var i in rest) {
          restaurants.add(Restaurant.fromJson(i));
        }
        return restaurants;
      }
      return restaurants;
    }
  }

  getRestaurantsGroup() async {
    var restaurantsGroup = [];
    try {
      var response = await http.get(Uri.parse(Constants().baseUrl +
          "restaurants-groups?filter[where][isDeleted]=false"));

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);

        for (var rest in jsonResponse) {
          Hotel restauratnData = Hotel.fromJson(rest);
          restaurantsGroup.add(restauratnData);
        }

        ds.write("hotels", restaurantsGroup);
        return restaurantsGroup;
      } else {
        if (ds.read("restaurants") != null) {
          var hot = json.decode(json.encode(ds.read("hotels")));
          for (var i in hot) {
            restaurantsGroup.add(Hotel.fromJson(i));
          }
          return restaurantsGroup;
        }
        return restaurantsGroup;
      }
    } catch (e) {
      print(e);
      if (ds.read("hotels") != null) {
        var hot = json.decode(json.encode(ds.read("hotels")));
        for (var i in hot) {
          restaurantsGroup.add(Hotel.fromJson(i));
        }
        return restaurantsGroup;
      }
      return restaurantsGroup;
    }
  }

  getEvents() async {
    var events = [];
    try {
      var response = await http.get(Uri.parse(Constants().baseUrl +
          "events?filter[where][endDate][[gte]=${DateTime.now()}&filter[where][isDeleted]=false"));
      log(response.request!.url.toString());

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        for (var event in jsonResponse) {
          Event eventData = Event.fromJson(event);
          // If event is not expired
          if (DateTime.parse(eventData.endDate!).compareTo(DateTime.now()) >
              0) {
            if (events.contains(eventData) == false) {
              events.add(eventData);
            }
          }
        }

        ds.write("events", events);
        return events;
      } else {
        if (ds.read("events") != null) {
          var e = json.decode(json.encode(ds.read("events")));
          for (var i in e) {
            events.add(Event.fromJson(i));
          }
          return events;
        }
        return events;
      }
    } catch (e) {
      if (ds.read("events") != null) {
        var e = json.decode(json.encode(ds.read("events")));
        for (var i in e) {
          events.add(Event.fromJson(i));
        }
        return events;
      }
      return events;
    }
  }

  getMasterTags({isVeg}) async {
    var masterTags = [];
    try {
      var res = await http.get(Uri.parse(
          Constants().baseUrl + "mastertags?filter[where][isveg]=$isVeg"));
      if (res.statusCode == 200) {
        var jsonResponse = json.decode(res.body);
        for (var i in jsonResponse) {
          var tag = MasterTag.fromJson(i);
          masterTags.add(tag);
        }
        ds.write("masterTags", masterTags);
        return masterTags;
      }
    } catch (e) {
      print(e);
      if (ds.read("masterTags") != null) {
        var e = json.decode(json.encode(ds.read("masterTags")));
        for (var i in e) {
          masterTags.add(MasterTag.fromJson(i));
        }
      }
      return masterTags;
    }
  }

  getChildTags() async {
    var childTags = [];
    try {
      if (true) {
        var res = await http.get(Uri.parse(Constants().baseUrl + "childtags"));
        if (res.statusCode == 200) {
          var jsonResponse = json.decode(res.body);

          for (var i in jsonResponse) {
            childTags.add(ChildTag.fromJson(i));
          }
          ds.write("childTags", childTags);
          return childTags;
        }
      }
      var e = json.decode(json.encode(ds.read("childTags")));
      for (var i in e) {
        childTags.add(ChildTag.fromJson(i));
      }
      return childTags;
    } catch (e) {
      print(e);
      if (ds.read("childTags") != null) {
        var e = json.decode(json.encode(ds.read("childTags")));
        for (var i in e) {
          childTags.add(ChildTag.fromJson(i));
        }
      }
      return childTags;
    }
  }

  eventInterestExists({user, event}) async {
    try {
      var resp = await http.get(
        Uri.parse(Constants().baseUrl +
            "evenregistrations?filter[where][userId]=${user.userId}&filter[where][eventsId]=${event.id}"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
      );

      if (resp.statusCode == 200) {
        var jsonResponse = json.decode(resp.body);
        if (jsonResponse.length > 0) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  eventInterestCount({user, event}) async {
    var seats = 0;
    try {
      var resp = await http.get(
        Uri.parse(Constants().baseUrl +
            "evenregistrations?filter[where][userId]=${user.userId}&filter[where][eventsId]=${event.id}"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
      );
      if (resp.statusCode == 200) {
        var jsonResponse = json.decode(resp.body);

        if (jsonResponse.length > 0) {
          seats = int.parse(jsonResponse.last['seats']);
          return seats;
        }
        seats = 0;
        return seats;
      }
      return seats;
    } catch (e) {
      return seats;
    }
  }

  eventInterestId({user, event}) async {
    var id = 0;
    // try {
    var resp = await http.get(
      Uri.parse(Constants().baseUrl +
          "evenregistrations?filter[where][userId]=${user.userId}&filter[where][eventsId]=${event.id}"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
    );

    if (resp.statusCode == 200) {
      var jsonResponse = json.decode(resp.body);
      // if (jsonResponse.length > 0) {
      id = jsonResponse.last['id'];
      return id;
      // }
      // id = 0;
      // return id;
    }
    return id;
    // } catch (e) {
    //   return id;
    // }
  }

  eventRegistrationUpdate({seats, user, event}) async {
    try {
      var id = await eventInterestId(user: user, event: event);
      var resp = await http.put(
          Uri.parse(Constants().baseUrl + "evenregistrations/$id"),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json"
          },
          body: jsonEncode({
            "seats": seats,
            "userId": user.userId,
            "eventsId": event.id,
            "remarks": "",
            "createdById": user.userId,
            "updatedById": user.userId,
            "description": "",
            "isActive": true,
            "isDeleted": true,
            "extratString": ""
          }));

      if (resp.statusCode == 204) {
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  eventRegistration({seats, user, event}) async {
    try {
      var resp = await http.post(
          Uri.parse(Constants().baseUrl + "evenregistrations"),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json"
          },
          body: jsonEncode({
            "seats": seats,
            "userId": user.userId,
            "eventsId": event.id,
            "remarks": "",
            "createdById": user.userId,
            "updatedById": user.userId,
            "description": "",
            "isActive": true,
            "isDeleted": true,
            "extratString": ""
          }));

      if (resp.statusCode == 200) {
        return true;
      } else {
        return await eventRegistrationUpdate(
            seats: seats, user: user, event: event);
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  contactUsAPI({subject, body, memberid}) async {
    try {
      var res = await http.post(Uri.parse(Constants().baseUrl + "contactuses"),
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "subject": subject,
            "details": body,
            "membersid": memberid,
            "reply": "null"
          }));

      if (res.statusCode == 200) {
        return true;
      }
      print(res.statusCode);
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  postMasterTags(childtagId, Id) async {
    var resp = await http.post(Uri.parse(Constants().baseUrl + "membertags"),
        headers: {
          'Content-type': 'application/json',
        },
        body: jsonEncode({
          "childtagsid": childtagId,
          "memberid": Id,
          "description": "string",
          "iddeleted": false,
        }));

    if (resp.statusCode == 200) {
      return true;
    }
    return resp;
  }

  deleteMasterTags(childtagId, memberId) async {
    var ids =
        await getSelectedChildTagId(childTagId: childtagId, memberId: memberId);

    for (var id in ids) {
      var resp =
          await http.put(Uri.parse(Constants().baseUrl + "membertags/$id"),
              headers: {
                'Content-type': 'application/json',
              },
              body: jsonEncode({
                "childtagsid": childtagId,
                "memberid": memberId,
                "description": "string",
                "iddeleted": true,
              }));

      if (resp.statusCode == 200) {
        return true;
      }
    }
  }

  getSelectedChildTagId({childTagId, memberId}) async {
    var resp = await http.get(Uri.parse(Constants().baseUrl +
        "membertags?filter[where][memberid]=$memberId&filter[where][iddeleted]=false&filter[where][childtagsid]=$childTagId"));

    var ids = [];

    if (resp.statusCode == 200) {
      var json = jsonDecode(resp.body);
      for (var tag in json) {
        ids.add(tag['id']);
      }
    }
    return ids;
  }

  Future<void> getSelectedMasterTags(id) async {
    var resp = await http.get(
        Uri.parse(Constants().baseUrl +
            "membertags?filter[where][memberid]=$id&filter[where][iddeleted]=false"),
        headers: {
          'Content-type': 'application/json',
        });
    var c = Get.find<PreferenceController>();
    log(resp.statusCode.toString());
    if (resp.statusCode == 200) {
      var jsonResponse = json.decode(resp.body);
      for (var i = 0; i < jsonResponse.length; i++) {
        log(i.toString());
        var tag = int.parse(jsonResponse[i]['childtagsid']);
        if (c.selectedPreferencesTag.contains(tag) == false) {
          c.selectedPreferencesTag.add(tag);
        }
      }
    }
  }

  logAppOpenAPI({time, user}) async {
    //     var packageInfo = await PackageInfo.fromPlatform();
    try {
      var resp = await http.post(
        Uri.parse(Constants().baseUrl + "app-open-logs"),
        headers: {'Content-type': 'application/json'},
        body: jsonEncode(
          {
            "appopentime": DateTime.now().toString(),
            "userid": user.userId,
            "memberid": user.id,
            // "platform": Platform.isAndroid ? "Android" : "IOS",
            // "version": packageInfo.version,
          },
        ),
      );
      if (resp.statusCode == 200) {
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  updatePlayerID({required Member? user, playerId}) async {
    print("User OTP: ${user!.otp}");
    var dataToBePassed = {
      "id": user.id,
      "email": user.email,
      "dob": user.dob,
      "image": user.image,
      "address": user.address,
      "pincode": int.parse(user.pincode.toString()),
      "remarks": user.remarks,
      "firstname": user.firstname,
      "lastname": user.lastname,
      "memberid": int.parse(user.memberid.toString()),
      "isVerified": user.isVerified,
      "isActivated": user.isActivated,
      "isDeleted": user.isDeleted,
      "startDate": user.startDate,
      "endDate": user.endDate,
      "createdAt": user.createdAt,
      "userId": user.userId,
      "createdById": user.createdById,
      "updatedById": user.updatedById,
      "mobile": int.parse(user.mobile.toString()),
      "updatedAt": user.updatedAt,
      "uuid": user.uuid,
      "membertypeid": int.parse(user.membertypeid.toString()),
      "anniversarydate": user.anniversarydate,
      "tempurl": user.tempurl,
      "otp": user.otp == null || user.otp == 'null'
          ? 1234
          : int.parse(user.otp.toString()),
      "playerid": playerId,
      "isveg": user.isVeg,
      "districtsId": int.parse(user.districtsId.toString())
    };

    if (user != null) {
      var resp = await http.put(
          Uri.parse(Constants().baseUrl + 'members/${user.id}'),
          headers: {'Content-type': 'application/json'},
          body: json.encode(dataToBePassed));

      if (resp.statusCode == 204 || resp.statusCode == 200) {
        print("Updated Player Id");
        return true;
      }
    }
  }

  deleteAccount({required Member? user, isDelete}) async {
    print("User OTP: ${user!.otp}");
    var dataToBePassed = {
      "id": user.id,
      "email": user.email,
      "dob": user.dob,
      "image": user.image,
      "address": user.address,
      "pincode": int.parse(user.pincode.toString()),
      "remarks": user.remarks,
      "firstname": user.firstname,
      "lastname": user.lastname,
      "memberid": int.parse(user.memberid.toString()),
      "isVerified": user.isVerified,
      "isActivated": user.isActivated,
      "isDeleted": isDelete,
      "startDate": user.startDate,
      "endDate": user.endDate,
      "createdAt": user.createdAt,
      "userId": user.userId,
      "createdById": user.createdById,
      "updatedById": user.updatedById,
      "mobile": int.parse(user.mobile.toString()),
      "updatedAt": user.updatedAt,
      "uuid": user.uuid,
      "membertypeid": int.parse(user.membertypeid.toString()),
      "anniversarydate": user.anniversarydate,
      "tempurl": user.tempurl,
      "otp": user.otp == null || user.otp == 'null'
          ? 1234
          : int.parse(user.otp.toString()),
      "playerid": user.playerId.toString(),
      "isveg": user.isVeg,
      "districtsId": int.parse(user.districtsId.toString())
    };

    if (user != null) {
      var resp = await http.put(
          Uri.parse(Constants().baseUrl + 'members/${user.id}'),
          headers: {'Content-type': 'application/json'},
          body: json.encode(dataToBePassed));

      if (resp.statusCode == 204 || resp.statusCode == 200) {
        print("Account Deleted Successfully");
        ds.write("isLogin", false);
        ds.erase();
        return true;
      }
    }
  }

  updateIsVeg({required Member user, isVeg}) async {
    var dataToBePassed = {
      "id": user.id,
      "email": user.email,
      "dob": user.dob,
      "image": user.image,
      "address": user.address,
      "pincode": int.parse(user.pincode.toString()),
      "remarks": user.remarks,
      "firstname": user.firstname,
      "lastname": user.lastname,
      "memberid": int.parse(user.memberid.toString()),
      "isVerified": user.isVerified,
      "isActivated": user.isActivated,
      "isDeleted": user.isDeleted,
      "startDate": user.startDate,
      "endDate": user.endDate,
      "createdAt": user.createdAt,
      "userId": user.userId,
      "createdById": user.createdById,
      "updatedById": user.updatedById,
      "mobile": int.parse(user.mobile.toString()),
      "updatedAt": user.updatedAt,
      "uuid": user.uuid,
      "membertypeid": int.parse(user.membertypeid.toString()),
      "anniversarydate": user.anniversarydate,
      "tempurl": user.tempurl,
      "otp": user.otp == null || user.otp == 'null'
          ? 1234
          : int.parse(user.otp.toString()),
      "playerid": user.playerId.toString(),
      "isveg": isVeg,
      "districtsId": int.parse(user.districtsId.toString()),
    };

    if (user != null) {
      var resp = await http.put(
          Uri.parse(Constants().baseUrl + 'members/${user.id}'),
          headers: {'Content-type': 'application/json'},
          body: json.encode(dataToBePassed));

      if (resp.statusCode == 204 || resp.statusCode == 200) {
        print("Updated Veg Status");
        return true;
      }
    }
  }

  updateProfilePic({required Member? user, imageUrl}) async {
    print("User OTP: ${user!.otp}");
    var dataToBePassed = {
      "id": user.id,
      "email": user.email,
      "dob": user.dob,
      "image": imageUrl,
      "address": user.address,
      "pincode": int.parse(user.pincode.toString()),
      "remarks": user.remarks.toString(),
      "firstname": user.firstname,
      "lastname": user.lastname,
      "memberid": int.parse(user.memberid.toString()),
      "isVerified": user.isVerified,
      "isActivated": user.isActivated,
      "isDeleted": user.isDeleted,
      "startDate": user.startDate,
      "endDate": user.endDate,
      "createdAt": user.createdAt,
      "userId": user.userId,
      "createdById": user.createdById,
      "updatedById": user.updatedById,
      "mobile": int.parse(user.mobile.toString()),
      "updatedAt": user.updatedAt,
      "uuid": user.uuid,
      "membertypeid": int.parse(user.membertypeid.toString()),
      "anniversarydate": user.anniversarydate,
      "tempurl": user.tempurl,
      "otp": user.otp == null || user.otp == 'null'
          ? 1234
          : int.parse(user.otp.toString()),
      "playerid": user.playerId.toString(),
      "isveg": user.isVeg,
      "districtsId": int.parse(user.districtsId.toString())
    };

    if (user != null) {
      var resp = await http.put(
          Uri.parse(Constants().baseUrl + 'members/${user.id}'),
          headers: {'Content-type': 'application/json'},
          body: json.encode(dataToBePassed));

      print(resp.body);

      if (resp.statusCode == 204 || resp.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    }
  }

  getStates() async {
    var states = [];
    var resp =
        await http.get(Uri.parse(Constants().baseUrl + "states"), headers: {
      'Content-type': 'application/json',
    });

    if (resp.statusCode == 200) {
      var jsonResponse = json.decode(resp.body);
      for (var state in jsonResponse) {
        var s = States.fromJson(state);
        states.add(s);
      }
    }
    return states;
  }

  getDistrict(int stateId) async {
    var districts = [];
    var resp = await http.get(
        Uri.parse(Constants().baseUrl + "states/$stateId/districts"),
        headers: {
          'Content-type': 'application/json',
        });

    if (resp.statusCode == 200) {
      var jsonResponse = json.decode(resp.body);
      for (var dist in jsonResponse) {
        var d = District.fromJson(dist);
        districts.add(d);
      }
    }
    return districts;
  }

  SignUpMember() async {
    var c = Get.put(SignUpController());
    var dataToBePassed = {
      "email": c.email.value.text,
      "dob": c.pickedDob.value,
      "image":
          "https://www.pngitem.com/pimgs/m/80-800297_users-icon-yellow-real-id-star-hd-png.png",
      "address": c.address.value.text,
      "pincode": int.parse(c.pincode.value.text),
      "remarks": "",
      "firstname": c.firstName.value.text,
      "lastname": c.lastName.value.text,
      "memberid": 0,
      "isVerified": false,
      "isActivated": false,
      "isDeleted": false,
      "startDate": DateTime.now().toString(),
      "endDate": DateTime.now().add(Duration(days: 10)).toString(),
      "createdAt": DateTime.now().toString(),
      "userId": "0",
      "createdById": "",
      "updatedById": "",
      "mobile": int.parse(c.mobile.value.text),
      "updatedAt": DateTime.now().toString(),
      "uuid": "",
      "anniversarydate": DateTime.now().toString(),
      "tempurl": "",
      "membertypeid": 1,
      "otp": 0,
      "playerid": "",
      "isveg": true,
      "districtsId": c.districtId.value
    };

    var resp = await http.post(Uri.parse(Constants().baseUrl + 'members'),
        headers: {'Content-type': 'application/json', 'Platform': "Mobile"},
        body: json.encode(dataToBePassed));

    if (resp.statusCode == 200) {
      Get.offAll(() => LoginScreen());
      Get.snackbar(
          "User has been registered successfully.", "Verify your Mobile/Email",
          snackPosition: SnackPosition.BOTTOM);
      Get.to(() => VerifyMobileOtp());
    } else if (resp.statusCode == 408) {
      var jsonResp = jsonDecode(resp.body);
      Get.snackbar("${jsonResp['error']['message']}", "",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  String uint8ListTob64(Uint8List uint8list) {
    String base64String = base64Encode(uint8list);
    String header = "data:image/png;base64,";
    return header + base64String;
  }

  Future<String> uploadProfilePicture(File file) async {
    var resp = await http.MultipartRequest(
      'POST',
      Uri.parse(Constants().baseUrl + 'upload'),
    );
    var headers = {
      "Content-type": "multipart/form-data",
    };
    resp.files.add(
      await http.MultipartFile.fromPath(
        'image',
        file.path,
        filename: DateTime.now().millisecondsSinceEpoch.toString() +
            file.path.split("/").last,
      ),
    );
    resp.headers.addAll(headers);

    var res = await resp.send();
    var response = await http.Response.fromStream(res);

    if (res.statusCode == 200) {
      var json = await jsonDecode(response.body);

      return json[0]["Location"];
    } else {
      return "Error";
    }
  }

  checkIOSVersion() async {
    var res = await http.get(Uri.parse(
        "https://itunes.apple.com/IN/lookup?bundleId=com.gourmetplanet.gpapplication"));

    if (res.statusCode == 200) {
      var body = jsonDecode(res.body);
      var version = body['results'][0]['version'];

      return version;
    }
    return "0";
  }

  ContactUsQueryAPI({required Member user}) async {
    List<ContactUsQueryModel> listOfQueries = [];

    var res = await http.get(
      Uri.parse(Constants().baseUrl +
          "contactuses?filter[where][membersid]=${user.id}&filter[order]=id DESC"),
      headers: {'Content-type': 'application/json'},
    );

    List queriesForDB = [];
    print(res.statusCode);

    if (res.statusCode == 200) {
      var jsonBody = json.decode(res.body);
      for (var q in jsonBody) {
        var query = ContactUsQueryModel.fromJson(q);
        listOfQueries.add(query);
        queriesForDB.add(query.toJson());
      }
      ds.write("queries", queriesForDB);
    } else {
      Get.snackbar("We are facing some error while fetching your Queries",
          "Please try again later.");
    }
    return listOfQueries;
  }

  getRewards({userId}) async {
    List<RewardsModel?> rewards = [];
    try {
      var resp = await http.get(
        Uri.parse(Constants().baseUrl + "myrewardpoints/$userId"),
        headers: {'Content-type': 'application/json'},
      );
      if (resp.statusCode == 200) {
        var json = jsonDecode(resp.body);
        for (var r in json) {
          rewards.add(RewardsModel.fromJson(r));
        }
        ds.write("rewards", jsonEncode(rewards));
      }
    } catch (e) {
      var r = ds.read('rewards');
      if (r != null) {
        for (var reward in jsonDecode(r)) {
          rewards.add(RewardsModel.fromJson(reward));
        }
      }
    }
    return rewards;
  }

  checkVersion() async {
    var res = await http.get(
      Uri.parse(Constants().baseUrl + "appversions"),
      headers: {'Content-type': 'application/json'},
    );

    var currentVersion;

    if (res.statusCode == 200) {
      var json = jsonDecode(res.body);

      for (var v in json) {
        if (Platform.isAndroid) {
          if (v['os'] == "Android") {
            currentVersion = v['version'];
          }
        } else if (Platform.isIOS) {
          if (v['os'] == "iOS") {
            currentVersion = v['version'];
          }
        }
      }
    }
    print("version $currentVersion");
    return currentVersion;
  }
}
