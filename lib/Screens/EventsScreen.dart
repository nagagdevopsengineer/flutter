import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpapp/ColorPallete.dart';
import 'package:gpapp/Controllers/CommonController.dart';
import 'package:gpapp/Controllers/NetworkControllers/ManualCalls.dart';
import 'package:gpapp/Controllers/NetworkControllers/Models.dart';
import 'package:gpapp/Controllers/NetworkControllers/notificationApi.dart';
import 'package:gpapp/Screens/home_screen.dart';
import 'package:gpapp/Widgets/CommonWidgets.dart';
import 'package:gpapp/Widgets/button.dart';
import 'package:gpapp/models/notifications.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class EventsScreen extends StatefulWidget {
  EventsScreen({Key? key, this.index = 0}) : super(key: key);
  var index;
  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final PageController _pageController = PageController();
  int activePage = 0;

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  GetStorage ds = GetStorage();
  var events = [];
  var isLoading = true;
  var api = ManualAPICall();
  var c = Get.put(CommonController());
  var controller = ItemScrollController();
  CommonController _commonControl = CommonController();

  getEvents() async {
    if (ds.read('events') != null) {
      var e = json.decode(json.encode(ds.read("events")));
      for (var i in e) {
        var e = Event.fromJson(i);
        if (DateTime.parse(e.endDate!).compareTo(DateTime.now()) > 0) {
          if (events.contains(e) == false) {
            events.add(e);
          }
        }
      }
    } else {
      var e = await api.getEvents();

      e.bodyBytes;
      for (var i in e.bodyBytes) {
        var e = Event.fromJson(i);
        if (DateTime.parse(e.endDate!).compareTo(DateTime.now()) > 0) {
          if (events.contains(e) == false) {
            events.add(e);
          }
        }
      }
    }

    events.sort(
      (a, b) => DateTime.parse(a.startDate).compareTo(
        DateTime.parse(b.startDate),
      ),
    );
    setState(() {
      isLoading = false;
    });
    await updateInterestOfEvent();
  }

  updateInterestOfEvent() async {
    for (var event in events) {
      if (c.eventsinterestedIn.contains(event.id.toString()) == false) {
        var seatsCount =
            await ManualAPICall().eventInterestCount(user: user, event: event);
        if (seatsCount > 0) {
          c.eventsinterestedIn.add(event.id.toString());
        }
      }
      setState(() {});
    }
    ds.write("eventsinterestedIn", c.eventsinterestedIn);
    setState(() {});
  }

  var user;
  getUser() async {
    user = Member.fromJson(json.decode(json.encode(ds.read('user'))));
    setState(() {});
  }

  updateContinuosly() async {
    Timer.periodic(Duration(seconds: 10), (timer) async {
      events = await api.getEvents();
      events.sort(
        (a, b) => DateTime.parse(a.startDate).compareTo(
          DateTime.parse(b.startDate),
        ),
      );
      // user = await api.getMemeberDetails();
      setState(() {});
    });
  }

  @override
  void initState() {
    getEvents();
    getUser();
   _commonControl.getNotificationReadStatus(forceapi: true);
    // updateContinuosly();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var count = 0;
      for (var event in events) {
        count++;
      }
      controller.scrollTo(
          index: widget.index, duration: Duration(milliseconds: 1));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: ColorPallete.backgroud,
      appBar: AppBarWidget(
        _key,
        title: 'Events',
        isBack: true,
      ),
      drawer: drawerWidget(
        user,
        key: _key,
        context: context,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(color: ColorPallete.primary),
            )
          : events.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage('assets/images/noeventavailable.png'),
                      height: 240,
                      width: 298,
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      'No Events Available!',
                      style: GoogleFonts.inter(
                        color: ColorPallete.blue,
                        fontSize: 23,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'There are no events available at the moment.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: ColorPallete.grey,
                        fontSize: 19,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Button(
                      title: 'Go to Homepage',
                      color: ColorPallete.blue,
                      horizontalPadding:
                          MediaQuery.of(context).size.width * 0.15,
                      verticalPadding: 14,
                      borderRadius: 50,
                      fontSize: 13,
                      onPressed: () {
                        Get.to(HomeScreen());
                      },
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                )
              : Column(
                  children: [
                    SizedBox(
                      height: Get.height * 0.78,
                      child: ScrollablePositionedList.builder(
                          itemScrollController: controller,
                          itemCount: events.length,
                          itemBuilder: (context, pagePosition) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: eventCard(event: events[pagePosition]),
                            );
                          }),
                    ),
                  ],
                ),
    );
  }
}
