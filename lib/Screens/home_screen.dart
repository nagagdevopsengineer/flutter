import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpapp/Controllers/CommonController.dart';
import 'package:gpapp/Controllers/NetworkControllers/APIController.dart';
import 'package:gpapp/Controllers/NetworkControllers/ManualCalls.dart';
import 'package:gpapp/Controllers/NetworkControllers/Models.dart';
import 'package:gpapp/Controllers/NetworkControllers/notificationApi.dart';
import 'package:gpapp/Screens/EventsScreen.dart';
import 'package:gpapp/Screens/ProfileScreen.dart';
import 'package:gpapp/Screens/RestaurantsScreen.dart';
import 'package:gpapp/Screens/authScreens/loginscreen.dart';
import 'package:gpapp/Widgets/CommonWidgets.dart';
import 'package:gpapp/models/notifications.dart';
import 'package:gpapp/utils/colors.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  var api = ManualAPICall();
  var user;
  GetStorage ds = GetStorage();
  var apiController = APIController();
  var restaurants = [];
  var events = [];
  var c = Get.put(CommonController());
  var isLoading = true;
  var isLoadingEvents = true;
  var rewards;
  var newVersionOfApp;
  var currentVersion;
  var packageInfo;
  NotificationApi notificationApi = NotificationApi();
  List<Notifications?> notifications = [];
  var noti2;
  int limit = 10;
  int offset = 0;
  CommonController commonControl = CommonController();

  getVersion() async {
    packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      currentVersion = packageInfo.version;
    });
  }

  getCurrentVersion() async {
    newVersionOfApp = await api.checkVersion();
    await getVersion();
    var isUpdate = isVersionGreaterThan(newVersionOfApp, currentVersion);
    print(isUpdate);
    print(currentVersion);
    if (isUpdate) {
      await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return WillPopScope(
              child: Platform.isAndroid
                  ? AlertDialog(
                      title: Text("Update Available"),
                      content: Text(
                          'You can now update this app from $currentVersion to $newVersionOfApp'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              launchUrl(
                                  Uri.parse(
                                      "https://play.google.com/store/apps/details?id=com.gourmetplanet.gpapplication"),
                                  mode: LaunchMode.externalApplication);
                            },
                            child: Text("Update")),
                      ],
                    )
                  : CupertinoAlertDialog(
                      title: Text("Update Available"),
                      content: Text(
                          'You can now update this app from $currentVersion to $newVersionOfApp'),
                      actions: [
                        CupertinoDialogAction(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Later")),
                        CupertinoDialogAction(
                            onPressed: () {
                              launchUrl(
                                  Uri.parse(
                                      "https://apps.apple.com/in/app/gourmet-planet/id1638079441"),
                                  mode: LaunchMode.externalApplication);
                            },
                            child: Text("Update")),
                      ],
                    ),
              onWillPop: () => Future.value(true));
        },
      );
    }
  }

  getUser({forceAPI = false}) async {
    if (ds.read('user') != null && !forceAPI) {
      user = Member.fromJson(jsonDecode(jsonEncode(ds.read('user'))));
    } else {
      var userId = await ds.read("userId");
      user = await api.getMemeberDetails(userId: "${userId}");
    }
    if (mounted) {
      setState(() {
        isLoading = false;
        rewards = user != null ? user.rewardspoints : null;
      });
    }
  }

  getRestaurants({forceAPI = false}) async {
    if (ds.read('restaurants') != null && !forceAPI) {
      var e = json.decode(json.encode(ds.read("restaurants")));
      for (var i in e) {
        restaurants.add(Restaurant.fromJson(i));
      }
    } else {
      restaurants = await api.getRestaurants();
    }
    restaurants.sort((a, b) => a.name.toUpperCase().compareTo(b.name.toUpperCase()));
    if (mounted) {
      setState(() {});
    }
  }

  getEvents({forceAPI = false}) async {
    if (ds.read('events') != null && !forceAPI) {
      var e = json.decode(json.encode(ds.read("events")));
      for (var i in e) {
        var event = Event.fromJson(i);
        if (DateTime.parse(event.endDate!).compareTo(DateTime.now()) > 0) {
          events.add(event);
        }
      }
    } else {
      events = await api.getEvents();
    }
    events.sort(
      (a, b) => DateTime.parse(a.startDate).compareTo(
        DateTime.parse(b.startDate),
      ),
    );

    if (mounted) {
      setState(() {
        isLoadingEvents = false;
      });
    }

    await updateInterestOfEvents();
  }

  updateInterestOfEvents() async {
    for (var event in events) {
      if (c.eventsinterestedIn.contains(event.id.toString()) == false) {
        var seatsCount =
            await ManualAPICall().eventInterestCount(user: user, event: event);
        if (seatsCount > 0) {
          c.eventsinterestedIn.add(event.id.toString());
        }
      }
    }
    ds.write("eventsinterestedIn", c.eventsinterestedIn);
    if (mounted) {
      setState(() {
        isLoadingEvents = false;
      });
    }
  }

  loadData() async {
    getUser();
    getEvents();
    getRestaurants();
  }

  updateContinuosly() async {
    Timer.periodic(Duration(seconds: 10), (timer) async {
      events = await api.getEvents();
      events.sort(
        (a, b) => DateTime.parse(a.startDate).compareTo(
          DateTime.parse(b.startDate),
        ),
      );
      restaurants = await api.getRestaurants();
      restaurants.sort((a, b) => a.name.toUpperCase().compareTo(b.name.toUpperCase()));
      if (mounted) {
        setState(() {});
      }
    });
  }

  loadDataFromAPI() async {
    events = await api.getEvents();
    events.sort(
      (a, b) => DateTime.parse(a.startDate).compareTo(
        DateTime.parse(b.startDate),
      ),
    );
    restaurants = await api.getRestaurants();
    restaurants.sort((a, b) => a.name.toUpperCase().compareTo(b.name.toUpperCase()));
    var userId = await ds.read("userId");
    await getUser(forceAPI: true);
    if (!user.isVerified!) {
      Get.offAll(() => ProfileScreen());
    }
    if (user.isDeleted!) {
      ds.erase();
      Get.offAll(() => LoginScreen());
      Get.snackbar("Your account has been deleted.", "",
          snackPosition: SnackPosition.BOTTOM);
    }
    // user = await api.getMemeberDetails(userId: "${userId}");
    if (mounted) {
      setState(() {});
    }
  }

  logAppTime() async {
    await ManualAPICall()
        .logAppOpenAPI(time: DateTime.now().toString(), user: user);
  }

  updatePlayerId() async {
    if (c.userIdOneSignal != "" && user.playerId != c.userIdOneSignal.value) {
      await ManualAPICall()
          .updatePlayerID(user: user, playerId: c.userIdOneSignal.value);
      //log(user.playerId);
      user = await ManualAPICall().getMemeberDetails(userId: ds.read('userId'));
    }
    var _externalUserId = user.memberid;
    OneSignal.shared.setExternalUserId(_externalUserId!).then((results) {
      // if (results == null) return;
      print("$results ExternalUserId");
    });
  }

  ScrollController restScrollController = ScrollController();
  ScrollController eventScrollController = ScrollController();
  bool simpleBehavior = false;

  bool isVersionGreaterThan(String newVersion, String currentVersion) {
    List<String> currentV = currentVersion.split(".");
    List<String> newV = newVersion.split(".");
    bool a = false;
    for (var i = 0; i <= 2; i++) {
      a = int.parse(newV[i]) > int.parse(currentV[i]);
      if (int.parse(newV[i]) != int.parse(currentV[i])) break;
    }
    return a;
  }

  @override
  void initState() {
    loadData();
    updateInterestOfEvents();
    logAppTime();
    updatePlayerId();
    loadDataFromAPI();
    getCurrentVersion();
    c.getNotificationReadStatus(forceapi: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: drawerWidget(
        user,
        context: context,
        key: _key,
      ),
      appBar: AppBarWidgetHomeScreen(
        _key,
        title: "Home",
        isBack: false,
        rewards: rewards ?? "0",
      ),
      backgroundColor: mobileBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          color: ColorPallete.primary,
          backgroundColor: ColorPallete.backgroud,
          onRefresh: () async {
            updateInterestOfEvents();
            loadDataFromAPI();
            setState(() {});
          },
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () async {
                      Get.to(() => ProfileScreen());
                    },
                    child: profileCard2(user: user),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      'Restaurants',
                      style: GoogleFonts.inter(
                          fontSize: 19, color: Color.fromARGB(255, 50, 54, 54)),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                      height: constraints.maxHeight * .28,
                      child: restaurants.isEmpty
                          ? Center(
                              child: CircularProgressIndicator(
                                  color: ColorPallete.primary),
                            )
                          : SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  for (var index = 0;
                                      index < restaurants.length;
                                      index++)
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(() => RestaurantsScreen(
                                              index: index,
                                            ));
                                      },
                                      child: restaurants[index]
                                              .discounts
                                              .isEmpty
                                          ? Container()
                                          : Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.23,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.9,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(23),
                                                image: DecorationImage(
                                                  image:
                                                      CachedNetworkImageProvider(
                                                    "${restaurants[index].imahge}",
                                                  ),
                                                  // image: NetworkImage(
                                                  //     "${restaurants[index].imahge ?? "https://bouchonbendigo.com.au/wp-content/uploads/2022/03/istockphoto-1316145932-170667a.jpg"}"),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              child: Stack(
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: Container(
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: Colors.white,
                                                        gradient: LinearGradient(
                                                            colors: [
                                                              Color.fromARGB(
                                                                  255,
                                                                  45,
                                                                  45,
                                                                  45),
                                                              Colors.transparent
                                                            ],
                                                            begin: Alignment
                                                                .bottomCenter,
                                                            end: Alignment
                                                                .topCenter),
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        20),
                                                                bottomRight:
                                                                    Radius
                                                                        .circular(
                                                                            20)),
                                                      ),
                                                      height: 65,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.9,
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: restaurants[index]
                                                                .discounts !=
                                                            null
                                                        ? offerContainer2(
                                                            name: restaurants[
                                                                    index]
                                                                .name,
                                                            offer: restaurants[
                                                                    index]
                                                                .discounts[0]
                                                                .name,
                                                            endDate: restaurants[
                                                                    index]
                                                                .discounts[0]
                                                                .discountEndDate)
                                                        : offerContainer2(
                                                            offer: "0% off",
                                                            endDate:
                                                                DateTime.now()
                                                                    .toString(),
                                                          ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                    )
                                ],
                              ),
                            )),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      'Events',
                      style: GoogleFonts.inter(
                          fontSize: 19,
                          color: const Color.fromARGB(255, 50, 54, 54)),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  isLoadingEvents
                      ? Center(
                          child: CircularProgressIndicator(
                              color: ColorPallete.primary),
                        )
                      : events.isEmpty
                          ? SizedBox(
                              width: Get.width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image(
                                    image: AssetImage(
                                        'assets/images/noeventavailable.png'),
                                    height: 179,
                                    width: 246,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    'No Events Available!',
                                    style: GoogleFonts.inter(
                                      color: ColorPallete.blue,
                                      fontSize: 19,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'There are no events available at the moment.',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.inter(
                                      color: ColorPallete.grey,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 50,
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              //controller: value.scrollController,
                              itemCount: events.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Get.to(() => EventsScreen(
                                          index: index,
                                        ));
                                  },
                                  child: Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      child: eventCard(event: events[index])),
                                );
                              },
                            ),
                  // for (var i = 0; i < events.length; i++)
                  //   GestureDetector(
                  //     onTap: () {
                  //       Get.to(() => EventsScreen());
                  //     },
                  //     child: Container(
                  //         margin: EdgeInsets.only(bottom: 10),
                  //         child: eventCard(event: events[i])),
                  //   ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
