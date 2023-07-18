import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gpapp/ColorPallete.dart';
import 'package:gpapp/Controllers/CommonController.dart';
import 'package:gpapp/Controllers/NetworkControllers/ManualCalls.dart';
import 'package:gpapp/Controllers/NetworkControllers/Models.dart';
import 'package:gpapp/Widgets/CommonWidgets.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../Controllers/NetworkControllers/notificationApi.dart';
import '../models/notifications.dart';

class RestaurantsScreen extends StatefulWidget {
  RestaurantsScreen({Key? key, this.index = 0}) : super(key: key);
  var index;
  @override
  State<RestaurantsScreen> createState() => _RestaurantsScreenState();
}

class _RestaurantsScreenState extends State<RestaurantsScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  var restaurants = [];
  GetStorage ds = GetStorage();
  var api = ManualAPICall();
  var controller = ItemScrollController();
  NotificationApi notificationApi = NotificationApi();
  bool isNotificationAvailable = false;
  List<Notifications?> notifications = [];
  var noti2;
  int limit = 10;
  int offset = 0;
  CommonController _commonControl = Get.find();
  getRestaurants({forceAPI = false}) async {
    if (ds.read('restaurants') != null || !forceAPI) {
      var e = json.decode(json.encode(ds.read("restaurants")));
      for (var i in e) {
        var rest = Restaurant.fromJson(i);
        if (restaurants.contains(rest) == false) {
          restaurants.add(Restaurant.fromJson(i));
        }
      }
    } else {
      restaurants = await api.getRestaurants();
    }
    restaurants.sort((a, b) => a.name.toUpperCase().compareTo(b.name.toUpperCase()));
    setState(() {});
  }

  var user;
  getUser() async {
    user = Member.fromJson(json.decode(json.encode(ds.read('user'))));
    setState(() {});
  }

  updateContinuosly() async {
    Timer.periodic(Duration(seconds: 10), (timer) async {
      restaurants = await api.getRestaurants();
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    getRestaurants();
    getUser();
    // updateContinuosly();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.scrollTo(
          index: widget.index, duration: Duration(milliseconds: 1));
    });
    _commonControl.getNotificationReadStatus(forceapi: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: ColorPallete.backgroud,
      appBar: AppBarWidget(
        _key,
        title: "Restaurants",
        isBack: true,
      ),
      drawer: drawerWidget(
        user,
        key: _key,
        context: context,
      ),
      body: restaurants.isEmpty
          ? Center(
              child: CircularProgressIndicator(color: ColorPallete.primary),
            )
          : RefreshIndicator(
              color: ColorPallete.primary,
              backgroundColor: ColorPallete.backgroud,
              onRefresh: () async {
                await getRestaurants(forceAPI: true);
              },
              child: ListView(
                // controller: controller,
                scrollDirection: Axis.vertical,
                children: [
                  // Restaurant Card
                  SizedBox(
                    height: Get.height * 0.8,
                    child: ScrollablePositionedList.builder(
                      itemScrollController: controller,
                      shrinkWrap: true,
                      itemCount: restaurants.length,
                      itemBuilder: (context, index) {
                        if (!restaurants[index].discounts.isEmpty) {
                          return restaurantCard(
                              restaurantData: restaurants[index]);
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
