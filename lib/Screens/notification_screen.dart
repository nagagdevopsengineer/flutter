import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpapp/Controllers/CommonController.dart';
import 'package:gpapp/Controllers/NetworkControllers/ManualCalls.dart';
import 'package:gpapp/Controllers/NetworkControllers/Models.dart';
import 'package:gpapp/Controllers/NetworkControllers/notificationApi.dart';
import 'package:gpapp/Controllers/PreferenceController.dart';
import 'package:gpapp/Screens/notificationDetails.dart';
import 'package:gpapp/Widgets/CommonWidgets.dart';
import 'package:gpapp/models/notifications.dart';
import 'package:gpapp/utils/colors.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatefulWidget {
  NotificationsScreen({Key? key}) : super(key: key);
  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  CommonController _commonControl = Get.find();
  ManualAPICall api = ManualAPICall();
  Member? user;
  List<Notifications?> notificationscount = [];
  var isLoading = true;
  GetStorage ds = GetStorage();
  int limit = 10;
  int offset = 0;
  ScrollController scrollController = ScrollController();
  var isMoreDataAvailable = true.obs;
  NotificationApi notificationApi = NotificationApi();
  bool hasMore = true;
  List<Notifications?> notifications = [];
  var c = Get.put(PreferenceController());

  Future getNotificationHelper({bool forceApi = false}) async {
    var noti = ds.read("notificationsList");
    var userId;
    if (ds.read('user') != null) {
      user = await Member.fromJson(jsonDecode(jsonEncode(ds.read('user'))));
      userId = user!.id;
      print("$userId This is We want");
      print("This is We want");
    } else {
      userId = c.user.value.id;
    }

    if (noti != null && !forceApi) {
      for (var i in noti) {
        Notifications noti = Notifications.fromJson(jsonDecode(jsonEncode(i)));
        notifications.add(noti);
      }
      setState(() {
        isLoading = false;
        hasMore = false;
      });
    } else if (noti == null) {
      setState(() {
        isLoading = false;
        hasMore = false;
      });
    }
    var noti2 = await notificationApi.getNotifications(
        int.parse(userId.toString()), limit, offset);
    var noti3 = noti2['notificationList'];
    if (noti3.length > 0) {
      notifications = noti3;
    } else if (noti3.length == 0) {
      isMoreDataAvailable.value = false;
      setState(() {
        isLoading = false;
        hasMore = false;
      });
    }

    if (notifications.length < limit) {
      hasMore = false;
    }

    print(notifications);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    //getNotificationReadStatus();
    getNotificationHelper(forceApi: true);
    _commonControl.getNotificationReadStatus(forceapi: true);
    user = Member.fromJson(json.decode(json.encode(ds.read("user"))));
    super.initState();
  }

  paginateNotifications() {
    if (scrollController.position.maxScrollExtent ==
        scrollController.position.pixels) {
      log("Reached Inside the if condition");
      offset += limit;
      if (isMoreDataAvailable.value == true) {
        setState(() {
          hasMore = true;
        });
        getNotificationHelper(forceApi: true);
      } else if (isMoreDataAvailable.value == false) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  dispose() {
    scrollController.dispose();
    super.dispose();
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
        title: " Notifications",
        isBack: true,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(color: ColorPallete.primary),
            )
          : notifications.isEmpty
              ? Center(
                  child: Text('No New Notification Available'),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    await getNotificationHelper();
                  },
                  child: NotificationListener<ScrollEndNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      log('scrollInfo.metrics.pixels ${scrollInfo.metrics.pixels}');
                      log('scrollInfo.metrics.maxScrollExtent ${scrollInfo.metrics.maxScrollExtent}');
                      paginateNotifications();
                      return true;
                    },
                    child: ListView.builder(
                        controller: scrollController,
                        itemCount: notifications.length + 1,
                        itemBuilder: ((context, index) {
                          if (index < notifications.length) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: GestureDetector(
                                onTap: () async {
                                  await notificationApi.updateNotifications(
                                    notifications[index]!.id,
                                    notifications[index]!.isRead = true,
                                    notifications[index]!.memberId,
                                    notifications[index]!.notificationType,
                                    notifications[index]!.notificationContent,
                                    notifications[index]!.notificationType,
                                    notifications[index]!.playerId,
                                    notifications[index]!.createdAt,
                                  );
                                  setState(() {
                                    print(notifications[index]!
                                        .createdAt
                                        .toString());
                                    print("You have called Notification API");
                                  });

                                  Get.to(
                                    () => NotificationDetails(
                                      title: notifications[index]?.clientName ??
                                          "",
                                      description: notifications[index]
                                              ?.notificationContent ??
                                          "",
                                      date:
                                          "${DateTime(notifications[index]!.createdAt.year, notifications[index]!.createdAt.month, notifications[index]!.createdAt.day) == DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day) ? "Today" : DateTime(notifications[index]!.createdAt.year, notifications[index]!.createdAt.month, notifications[index]!.createdAt.day) == DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 1) ? "Yesterday" : DateFormat("dd/MM/yyyy").format(notifications[index]!.createdAt)} at ${DateFormat("hh:m a").format(notifications[index]!.createdAt)}",
                                    ),
                                  );
                                  // !
                                  //     .then((value) => setState(() {
                                  //           commonController
                                  //               .isNotificationAvailable
                                  //               .value = false;
                                  //           //notificationscount = [];
                                  //           //getNotificationReadStatus();
                                  //           print("Mai aa gaya waapis");
                                  //         }));
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  elevation: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 16,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        notifications[index]!.isRead == false
                                            ? Icon(
                                                Icons.circle,
                                                size: 10,
                                                color: Color(0xffCF4949),
                                              )
                                            : SizedBox(),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Flexible(
                                                  child: RichText(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    strutStyle: StrutStyle(
                                                        fontSize: 12.0),
                                                    text: TextSpan(
                                                      text: notifications[index]
                                                              ?.notificationType ??
                                                          "",
                                                      style: GoogleFonts.inter(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                // Spacer(),
                                                // notifications[index]!.isRead ==
                                                //         false
                                                //     ? Icon(
                                                //         Icons.circle,
                                                //         size: 10,
                                                //         color: Color(0xffCF4949),
                                                //       )
                                                //     : SizedBox(),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            RichText(
                                              overflow: TextOverflow.values[2],
                                              softWrap: true,
                                              text: TextSpan(
                                                text: notifications[index]
                                                        ?.notificationContent ??
                                                    "",
                                                style: GoogleFonts.inter(
                                                  color: Colors.grey,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                            // Text(
                                            //   notifications[index]
                                            //           ?.notificationContent!.length > 90 ?
                                            //           Text(
                                            //   notifications[index]
                                            //           ?.notificationContent ??
                                            //       "",
                                            //   style: GoogleFonts.inter(
                                            //     color: Colors.grey,
                                            //     fontSize: 15,
                                            //     fontWeight: FontWeight.w400,
                                            //   ),
                                            // ) :
                                            // //  ViewMoreText(
                                            // //               textColor: Color(
                                            // //                 0xff7D8E8C,
                                            // //               ),
                                            // //               text:
                                            // //                   "Description: ${queries[index].details!}",
                                            // //               maxLength: 82,
                                            // //             )
                                            //

                                            //   style: GoogleFonts.inter(
                                            //     color: Colors.grey,
                                            //     fontSize: 15,
                                            //     fontWeight: FontWeight.w400,
                                            //   ),
                                            // ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            notifications[index]?.createdAt !=
                                                    null
                                                ? Text(
                                                    "${DateTime(notifications[index]!.createdAt.year, notifications[index]!.createdAt.month, notifications[index]!.createdAt.day) == DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day) ? "Today" : DateTime(notifications[index]!.createdAt.year, notifications[index]!.createdAt.month, notifications[index]!.createdAt.day) == DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 1) ? "Yesterday" : DateFormat("dd/MM/yyyy").format(notifications[index]!.createdAt)} at ${DateFormat("hh:m a").format(notifications[index]!.createdAt)}",
                                                    style: GoogleFonts.inter(
                                                      color: Colors.grey,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  )
                                                : Text(
                                                    "${DateFormat("dd/MM/yyyy").format(notifications[index]!.createdAt)} at ${DateFormat("hh:m a").format(notifications[index]!.createdAt)}"),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 32),
                              child: Center(
                                child: hasMore
                                    ? CircularProgressIndicator(
                                        color: ColorPallete.primary,
                                      )
                                    : Container(),
                              ),
                            );
                          }
                        })),
                  ),
                ),
    );
  }
}
