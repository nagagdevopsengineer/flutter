import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpapp/ColorPallete.dart';
import 'package:gpapp/Constants.dart';
import 'package:gpapp/Controllers/NetworkControllers/ManualCalls.dart';
import 'package:gpapp/Controllers/NetworkControllers/Models.dart';
import 'package:gpapp/Screens/EventsScreen.dart';
import 'package:gpapp/Screens/ProfileScreen.dart';
import 'package:gpapp/Screens/RestaurantsScreen.dart';
import 'package:gpapp/Screens/WebviewScreens/MenuScreen.dart';
import 'package:gpapp/Screens/WebviewScreens/PicksScreen.dart';
import 'package:gpapp/Screens/WebviewScreens/aboutUs.dart';
import 'package:gpapp/Screens/contactUs.dart';
import 'package:gpapp/Screens/home_screen.dart';
import 'package:gpapp/Screens/authScreens/loginscreen.dart';
import 'package:gpapp/Screens/reward_screen.dart';
import 'package:gpapp/Widgets/view_more_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../Controllers/CommonController.dart';
import 'package:url_launcher/url_launcher.dart' as URLLauncher;
import '../Screens/notification_screen.dart';

masterTagsQuestions(masterTags) {
  for (var i = 0; i < masterTags.length; i++) {
    var mastertag = masterTags[i];
    return mastertag;
  }
}

PreferredSizeWidget AppBarWidget(key,
    {title, isBack, isDrawer = true, titleColor = Colors.black}) {
  CommonController commonControl = Get.find();
  return PreferredSize(
    preferredSize:
        isBack ? const Size.fromHeight(110) : const Size.fromHeight(80),
    child: Column(
      children: [
        AppBar(
          iconTheme: const IconThemeData(color: ColorPallete.blue, size: 35),
          backgroundColor: ColorPallete.backgroud,
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              isDrawer
                  ? GestureDetector(
                      onTap: () {
                        key.currentState.openDrawer();
                      },
                      child: Obx(
                        () => Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(left: 6.0),
                              child: Image.asset(
                                "assets/images/burger.png",
                                fit: BoxFit.contain,
                                height: 30,
                                width: 30,
                              ),
                            ),
                            commonControl.isNotificationAvailable.value
                                ? Positioned(
                                    left: 5,
                                    child: Container(
                                      height: 10,
                                      width: 10,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.only(left: 6.0),
                    ),
              Image.asset(
                "assets/images/logo.png",
                fit: BoxFit.contain,
                height: 150,
                width: 150,
              ),
              const SizedBox(
                width: 30,
                height: 10,
              )
            ],
          ),
        ),
        isBack
            ? pageTitleWidget(
                title: title,
                titleColor: titleColor,
              )
            : Container(),
      ],
    ),
  );
}

PreferredSizeWidget AppBarWidgetHomeScreen(
  key, {
  title,
  isBack,
  isDrawer = true,
  titleColor = Colors.black,
  rewards,
}) {
  CommonController commonControl = Get.find();
  return PreferredSize(
    preferredSize:
        isBack ? const Size.fromHeight(110) : const Size.fromHeight(80),
    child: Column(
      children: [
        AppBar(
          iconTheme: const IconThemeData(color: ColorPallete.blue, size: 35),
          backgroundColor: ColorPallete.backgroud,
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              isDrawer
                  ? GestureDetector(
                      onTap: () {
                        key.currentState.openDrawer();
                      },
                      child: Obx(
                        () => Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(left: 6.0),
                              child: Image.asset(
                                "assets/images/burger.png",
                                fit: BoxFit.contain,
                                height: 30,
                                width: 30,
                              ),
                            ),
                            commonControl.isNotificationAvailable.value
                                ? Positioned(
                                    left: 5,
                                    child: Container(
                                      height: 10,
                                      width: 10,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.only(left: 6.0),
                    ),
              Image.asset(
                "assets/images/logo.png",
                fit: BoxFit.contain,
                height: 150,
                width: 150,
              ),
              Stack(
                children: [
                  Positioned(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: GestureDetector(
                        onTap: () {
                          Get.to(RewardScreen());
                        },
                        child: Image.asset(
                          "assets/images/rewards.png",
                          fit: BoxFit.contain,
                          height: 35,
                          width: 35,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 2,
                    child: GestureDetector(
                      onTap: () {
                        Get.to(RewardScreen());
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        decoration: new BoxDecoration(
                          color: Color(0xff3A6BC5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 12,
                          minHeight: 12,
                        ),
                        child: Text(
                          NumberFormat.compact()
                              .format(double.parse(rewards).round()),
                          style: new TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        isBack
            ? pageTitleWidget(
                title: title,
                titleColor: titleColor,
              )
            : Container(),
      ],
    ),
  );
}

PreferredSizeWidget AppBarWidgetProfileScreen(key,
    {title, isBack, isDrawer = true, titleColor = Colors.black}) {
  CommonController commonControl = Get.find();
  return PreferredSize(
    preferredSize:
        isBack ? const Size.fromHeight(110) : const Size.fromHeight(80),
    child: Column(
      children: [
        AppBar(
          iconTheme: const IconThemeData(color: ColorPallete.blue, size: 35),
          backgroundColor: ColorPallete.backgroud,
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              isDrawer
                  ? GestureDetector(
                      onTap: () {
                        key.currentState.openDrawer();
                      },
                      child: Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 6.0),
                            child: Image.asset(
                              "assets/images/burger.png",
                              fit: BoxFit.contain,
                              height: 30,
                              width: 30,
                            ),
                          ),
                          commonControl.isNotificationAvailable.value
                              ? Positioned(
                                  left: 5,
                                  child: Container(
                                    height: 10,
                                    width: 10,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.only(left: 6.0),
                    ),
              Image.asset(
                "assets/images/logo.png",
                fit: BoxFit.contain,
                height: 150,
                width: 150,
              ),
              const SizedBox(
                width: 30,
                height: 10,
              )
            ],
          ),
        ),
        isBack
            ? pageTitleWidgetProfileScreen(title: title, titleColor: titleColor)
            : Container(),
      ],
    ),
  );
}

Widget offerContainer({offer}) {
  return Container(
    height: 60,
    width: Get.width * 0.8,
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: ColorPallete.primary, width: 3),
      borderRadius: BorderRadius.circular(30),
    ),
    child: Row(
      children: [
        const SizedBox(width: 20),
        Image.asset(
          "assets/images/offersIcon.png",
          height: 40,
          width: 40,
        ),
        const SizedBox(width: 10),
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Discount",
                style: TextStyle(fontSize: 10, color: ColorPallete.grey),
              ),
              Text(
                "$offer",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ]),
      ],
    ),
  );
}

Widget restaurantCard({restaurantData, context}) {
  return Container(
    margin: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(
                    right: 23, left: 23, top: 30, bottom: 20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${restaurantData.name}",
                        style: TextStyle(fontSize: 23),
                      ),

                      if (restaurantData.cuisines != null &&
                          restaurantData.cuisines.length < 40 &&
                          restaurantData.cuisines.length > 1)
                        Text(
                          restaurantData.cuisines,
                          style: GoogleFonts.inter(
                            color: Color(
                              0xff7D8E8C,
                            ),
                          ),
                        )
                      else if (restaurantData.cuisines != null &&
                          restaurantData.cuisines.length > 40)
                        ViewMoreText(
                            text: utf8.decode(
                              restaurantData.cuisines.runes.toList(),
                            ),
                            textColor: Color(
                              0xff7D8E8C,
                            ),
                            maxLength: 35)
                      // restaurantData.cuisines != null
                      //     ? ViewMoreText(
                      //         text: "${restaurantData.cuisines}",
                      //         maxLength: (restaurantData.cuisines.length * 0.4)
                      //             .round())
                      //     : Text(""),
                    ]),
              ),
              // Image
              Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: "${restaurantData.imahge}",
                    height: 200,
                    width: Get.width,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => SizedBox(
                        height: 200,
                        width: Get.width,
                        child: Center(child: CircularProgressIndicator())),
                    errorWidget: (context, url, error) => SizedBox(
                        height: 200,
                        width: Get.width,
                        child: Center(
                            child: Icon(
                          Icons.error,
                          color: ColorPallete.blue,
                        ))),
                  ),
                  // Image.network(
                  //   "${restaurantData.imahge}",
                  //   height: 200,
                  //   width: Get.width,
                  //   fit: BoxFit.cover,
                  // ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(
                    right: 23, left: 23, top: 30, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     // Text(
                        //     //   "Last Date",
                        //     //   style: TextStyle(
                        //     //       fontSize: 10, color: ColorPallete.grey),
                        //     // ),
                        //     // Text(
                        //     //   restaurantData.discounts[0].discountEndDate !=
                        //     //           null
                        //     //       ? "${DateFormat("dd-MM-yyyy").format(DateTime.parse(restaurantData.discounts[0].discountEndDate))}"
                        //     //       : "",
                        //     //   style: TextStyle(fontSize: 15),
                        //     // )
                        //   ],
                        // ),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => Menu(
                                  url: restaurantData!.menuurl,
                                ));
                          },
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/images/menuIcon.png",
                                height: 20,
                                width: 20,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Menu',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  letterSpacing: 1.25,
                                  color: ColorPallete.blue,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.arrow_forward_outlined,
                                color: ColorPallete.blue,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                        // Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                        //   Text(
                        //     "Last Date",
                        //     style: TextStyle(fontSize: 10, color: ColorPallete.grey),
                        //   ),
                        //   Text(
                        //     restaurantData.discounts[0].discountEndDate != null
                        //         ? "${DateFormat("dd-MM-yyyy").format(DateTime.parse(restaurantData.discounts[0].discountEndDate))}"
                        //         : "",
                        //     style: TextStyle(fontSize: 15),
                        //   )
                        // ]),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (restaurantData.remarks != null &&
                        restaurantData.remarks.length < 90 &&
                        restaurantData.remarks.length > 0)
                      Text(
                        utf8.decode(
                          restaurantData.remarks.runes.toList(),
                        ),
                        style: GoogleFonts.inter(
                          color: Color(
                            0xff7D8E8C,
                          ),
                        ),
                      )
                    else if (restaurantData.remarks != null &&
                        restaurantData.remarks.length > 90)
                      ViewMoreText(
                        textColor: Color(
                          0xff7D8E8C,
                        ),
                        text: utf8.decode(
                          restaurantData.remarks.runes.toList(),
                        ),
                        maxLength: 82,
                      )
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      padding: EdgeInsets.symmetric(
                          horizontal: restaurantData.phonenumber == null ||
                                  restaurantData.phonenumber == 0
                              ? 30
                              : 70,
                          vertical: 15),
                      primary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      side: BorderSide(
                        width: 2,
                        color: ColorPallete.blue,
                      ),
                    ),
                    onPressed: () {
                      Get.to(() => Picks(
                            url: restaurantData!.picksurl,
                          ));
                    },
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/images/chef.png",
                          height: 20,
                          width: 20,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Sonny’s Picks',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            letterSpacing: 1.25,
                            color: ColorPallete.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: restaurantData.phonenumber == null ||
                        restaurantData.phonenumber == 0
                    ? 20
                    : 0,
              ),
              restaurantData.phonenumber == null ||
                      restaurantData.phonenumber == 0
                  ? Container(
                      height: 50,
                      width: 50,
                      child: FloatingActionButton(
                        onPressed: () {
                          print("Calling ${restaurantData.name}");
                          print("Calling on ${restaurantData.phonenumber}");
                          restaurantData.phonenumber != null
                              ? URLLauncher.launchUrl(Uri.parse(
                                  "tel:${restaurantData.phonenumber}"))
                              : null;
                        },
                        backgroundColor: Colors.transparent,
                        mini: true,
                        shape: StadiumBorder(
                          side: BorderSide(color: ColorPallete.blue, width: 1),
                        ),
                        child: Image.asset(
                          "assets/images/CallIcon.png",
                          fit: BoxFit.contain,
                          height: 23,
                        ),
                        elevation: 0,
                      ),
                    )
                  : Container(),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    ),
  );
}

Widget eventCard({required Event event}) {
  var c = Get.put(CommonController());
  GetStorage ds = GetStorage();
  var user;
  try {
    user = Member.fromJson(json.decode(json.encode(ds.read("user"))));
  } catch (e) {
    print(e);
  }
  return Container(
    margin: const EdgeInsets.only(left: 15, right: 15),
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin:
                const EdgeInsets.only(right: 23, left: 23, top: 30, bottom: 20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                "${event.name}",
                style: TextStyle(fontSize: 23, color: ColorPallete.blue),
              ),
              if (event.location!.length != null && event.location!.length < 40)
                Text(
                  event.location!,
                  style: GoogleFonts.inter(
                    color: Color(
                      0xff7D8E8C,
                    ),
                  ),
                )
              else if (event.location!.length != null &&
                  event.location!.length > 40)
                ViewMoreText(
                  text: event.location!,
                  maxLength: 35,
                  textColor: Color(
                    0xff7D8E8C,
                  ),
                ),
            ]),
          ),
          Stack(
            children: [
              CachedNetworkImage(
                imageUrl: "${event.image}",
                height: 200,
                width: Get.width,
                fit: BoxFit.cover,
                placeholder: (context, url) => SizedBox(
                  height: 200,
                  width: Get.width,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => SizedBox(
                  height: 200,
                  width: Get.width,
                  child: Center(
                    child: Icon(
                      Icons.error,
                      color: ColorPallete.blue,
                    ),
                  ),
                ),
              ),
              // Image.network(
              //   "${event.image}",
              //   height: 200,
              //   width: Get.width,
              //   fit: BoxFit.cover,
              // ),
              Positioned(
                top: 125,
                child: offerContainer3(price: event.price),
              ),
              Positioned(
                top: 125,
                right: 0,
                child: MenuContainer(event: event),
              ),
            ],
          ),
          Container(
            margin:
                const EdgeInsets.only(right: 23, left: 23, top: 30, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "From",
                          style:
                              TextStyle(fontSize: 10, color: ColorPallete.grey),
                        ),
                        Text(
                          "${DateFormat("dd-MM-yyyy").format(DateTime.parse(event.startDate!).toLocal())}",
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Till",
                            style: TextStyle(
                                fontSize: 10, color: ColorPallete.grey),
                          ),
                          Text(
                            "${DateFormat("dd-MM-yyyy").format(DateTime.parse(event.endDate!).toLocal())}",
                            style: TextStyle(fontSize: 15),
                          )
                        ]),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "From",
                          style:
                              TextStyle(fontSize: 10, color: ColorPallete.grey),
                        ),
                        Text(
                          "${DateFormat("hh:mm a").format(DateTime.parse(event.startTime!).toLocal())}",
                          style: TextStyle(fontSize: 15),
                        )
                      ],
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Till",
                            style: TextStyle(
                                fontSize: 10, color: ColorPallete.grey),
                          ),
                          Text(
                            "${DateFormat("hh:mm a").format(DateTime.parse(event.endTime!).toLocal())}",
                            style: TextStyle(fontSize: 15),
                          ),
                        ]),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                // Details

                if (event.eventDescription!.length != null &&
                    event.eventDescription!.length < 90 &&
                    event.eventDescription!.length > 0)
                  Text(
                    utf8.decode(
                      event.eventDescription!.runes.toList(),
                    ),
                    //utf8.decode(event.eventDescription.bodybytes),
                  )
                else if (event.eventDescription!.length != null &&
                    event.eventDescription!.length > 90)
                  ViewMoreText(
                    text: utf8.decode(
                      event.eventDescription!.runes.toList(),
                    ),
                    textColor: Color(
                      0xff7D8E8C,
                    ),
                    maxLength: 82,
                  ),

                const SizedBox(
                  height: 30,
                ),
                // Button

                event.isregistrationstopped != null &&
                        event.isregistrationstopped == true
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          roundedButton(
                            minWidth: event.contactnumber == null ||
                                    event.contactnumber == "" ||
                                    event.contactnumber == "string"
                                ? 0.75
                                : 0.5,
                            onPressed: () {},
                            text: c.eventsinterestedIn
                                    .contains(event.id.toString())
                                ? "Interested"
                                : "Show Interest",
                            interested: c.eventsinterestedIn
                                    .contains(event.id.toString())
                                ? true
                                : false,
                            color: ColorPallete.grey,
                            textColor: ColorPallete.white,
                          ),
                          event.contactnumber == null ||
                                  event.contactnumber == "" ||
                                  event.contactnumber == "string"
                              ? Container()
                              : Container(
                                  height: 50,
                                  width: 50,
                                  child: FloatingActionButton(
                                    onPressed: () {},
                                    backgroundColor: Colors.transparent,
                                    mini: true,
                                    shape: StadiumBorder(
                                      side: BorderSide(
                                        color: event.isregistrationstopped!
                                            ? Colors.grey
                                            : ColorPallete.blue,
                                        width: 1,
                                      ),
                                    ),
                                    child: Image.asset(
                                      "assets/images/CallIcon.png",
                                      color: event.isregistrationstopped!
                                          ? Colors.grey
                                          : ColorPallete.blue,
                                      fit: BoxFit.contain,
                                      height: 23,
                                    ),
                                    elevation: 0,
                                  ),
                                ),
                        ],
                      )
                    : SizedBox(
                        width: Get.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Obx(
                              () => roundedButton(
                                  minWidth: event.contactnumber == null ||
                                          event.contactnumber == "" ||
                                          event.contactnumber == "string"
                                      ? 0.75
                                      : 0.5,
                                  text: c.eventsinterestedIn
                                          .contains(event.id.toString())
                                      ? "Interested"
                                      : "Show Interest",
                                  interested: c.eventsinterestedIn
                                          .contains(event.id.toString())
                                      ? true
                                      : false,
                                  onPressed: () async {
                                    c.memberController.value.text = "0";
                                    var seatsCount = await ManualAPICall()
                                        .eventInterestCount(
                                            user: user, event: event);
                                    if (seatsCount < 0) {
                                      c.memberController.value.text = "0";
                                    } else {
                                      c.memberController.value.text =
                                          seatsCount.toString();
                                    }
                                    if (seatsCount < 1) {
                                      c.eventsinterestedIn
                                          .remove(event.id.toString());
                                    }
                                    Get.defaultDialog(
                                      title: "No. of Seats",
                                      titleStyle: const TextStyle(fontSize: 15),
                                      content: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              if (int.parse(c.memberController
                                                      .value.text) >
                                                  0) {
                                                c.memberController.value
                                                    .text = (int.parse(c
                                                            .memberController
                                                            .value
                                                            .text) -
                                                        1)
                                                    .toString();
                                              }
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              padding: const EdgeInsets.only(
                                                  left: 15,
                                                  right: 15,
                                                  bottom: 4),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: ColorPallete.blue),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: const Text("-",
                                                  style:
                                                      TextStyle(fontSize: 30)),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          SizedBox(
                                              width: 120,
                                              height: 40,
                                              child: Obx(
                                                () => TextField(
                                                  textAlign: TextAlign.center,
                                                  controller:
                                                      c.memberController.value,
                                                  onChanged: (text) {
                                                    c.interestCount.value =
                                                        int.parse(c
                                                            .memberController
                                                            .value
                                                            .text);
                                                  },
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration: const InputDecoration(
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                              bottom: 1),
                                                      border: OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .blue))),
                                                ),
                                              )),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              c.memberController.value.text =
                                                  (int.parse(c.memberController
                                                              .value.text) +
                                                          1)
                                                      .toString();
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              padding: const EdgeInsets.only(
                                                  left: 15,
                                                  right: 15,
                                                  bottom: 4),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: ColorPallete.blue),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: const Text(
                                                "+",
                                                style: TextStyle(fontSize: 30),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      confirm: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 30, vertical: 10),
                                        child: roundedButton(
                                            text: "OK",
                                            onPressed: () {
                                              Get.showOverlay(
                                                  asyncFunction: () async {
                                                    var resp;
                                                    if (c.memberController.value
                                                                .text.length >
                                                            0 &&
                                                        seatsCount.toString() !=
                                                            c.memberController
                                                                .value.text) {
                                                      if (seatsCount > 0) {
                                                        resp = await ManualAPICall()
                                                            .eventRegistrationUpdate(
                                                                seats: int.parse(c
                                                                    .memberController
                                                                    .value
                                                                    .text),
                                                                event: event,
                                                                user: user);
                                                      } else {
                                                        resp = await ManualAPICall()
                                                            .eventRegistration(
                                                                seats: int.parse(c
                                                                    .memberController
                                                                    .value
                                                                    .text),
                                                                event: event,
                                                                user: user);
                                                      }
                                                      seatsCount =
                                                          await ManualAPICall()
                                                              .eventInterestCount(
                                                                  user: user,
                                                                  event: event);

                                                      if (seatsCount < 1) {
                                                        c.eventsinterestedIn
                                                            .remove(event.id
                                                                .toString());
                                                      }
                                                      if (resp) {
                                                        c.eventsinterestedIn
                                                            .add(event.id);
                                                        // c.memberController.value.text = "0";

                                                      }

                                                      if (c.eventsinterestedIn
                                                              .contains(event.id
                                                                  .toString()) ==
                                                          false) {
                                                        var seatsCount =
                                                            await ManualAPICall()
                                                                .eventInterestCount(
                                                                    user: user,
                                                                    event:
                                                                        event);
                                                        if (seatsCount > 0) {
                                                          c.eventsinterestedIn
                                                              .add(event.id
                                                                  .toString());
                                                        }
                                                      }
                                                    }
                                                    Get.back();
                                                  },
                                                  loadingWidget: Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                            color: ColorPallete
                                                                .primary),
                                                  ));
                                            },
                                            isIcon: false,
                                            color: ColorPallete.blue,
                                            textColor: ColorPallete.white),
                                      ),
                                    );
                                  },
                                  color: ColorPallete.blue,
                                  textColor: ColorPallete.white),
                            ),
                            event.contactnumber == null ||
                                    event.contactnumber == "" ||
                                    event.contactnumber == "string"
                                ? Container()
                                : Container(
                                    height: 50,
                                    width: 50,
                                    child: FloatingActionButton(
                                      onPressed: () {
                                        print("Calling Event ${event.name}");
                                        print(
                                            "Calling on ${event.contactnumber}");
                                        event.contactnumber != null
                                            ? URLLauncher.launchUrl(Uri.parse(
                                                "tel:${event.contactnumber}"))
                                            : null;
                                      },
                                      backgroundColor: Colors.transparent,
                                      mini: true,
                                      shape: StadiumBorder(
                                          side: BorderSide(
                                              color: ColorPallete.blue,
                                              width: 1)),
                                      child: Image.asset(
                                        "assets/images/CallIcon.png",
                                        fit: BoxFit.contain,
                                        height: 23,
                                      ),
                                      elevation: 0,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}

Widget roundedButton(
    {text,
    onPressed,
    color,
    textColor,
    isIcon = true,
    interested = false,
    minWidth = 0.5}) {
  var c = Get.put(CommonController());
  return Material(
    elevation: 5,
    borderRadius: BorderRadius.circular(30),
    color: color,
    child: MaterialButton(
      onPressed: () {
        onPressed.call();
      },
      minWidth: Get.width * minWidth,
      height: 45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isIcon
              ? interested
                  ? const Icon(
                      Icons.favorite,
                      color: Colors.white,
                    )
                  : Image.asset(
                      'assets/images/interestIcon.png',
                      height: 25,
                      width: 25,
                    )
              : Container(),
          isIcon
              ? const SizedBox(
                  width: 10,
                )
              : Container(),
          Text(
            text,
            style: TextStyle(color: textColor, fontSize: 14),
          ),
        ],
      ),
    ),
  );
}

Widget pageTitleWidget({title, titleColor = Colors.black}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () async {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back,
            size: 20,
            color: titleColor,
          ),
        ),
        Text(
          "$title",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: titleColor,
          ),
        ),
        SizedBox(
          width: Get.width * 0.1,
        ),
      ],
    ),
  );
}

Widget pageTitleWidgetProfileScreen({title, titleColor = Colors.black}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            onPressed: () {
              //  Get.back();
              Get.to(() => const HomeScreen());
            },
            icon: Icon(
              Icons.arrow_back,
              size: 20,
              color: titleColor,
            )),
        Text(
          "$title",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w400, color: titleColor),
        ),
        SizedBox(
          width: Get.width * 0.1,
        ),
      ],
    ),
  );
}

Widget offerContainer3({price}) {
  return Container(
    height: 60,
    width: Get.width * 0.42,
    decoration: BoxDecoration(
      color: ColorPallete.primary,
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
    ),
    child: Container(
      margin: EdgeInsets.only(right: 4, top: 4, bottom: 4),
      decoration: BoxDecoration(
        color: ColorPallete.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 20),
          const SizedBox(width: 10),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Cost (Per person)",
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: ColorPallete.grey,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 1.25,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "₹$price/-",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ]),
        ],
      ),
    ),
  );
}

Widget MenuContainer({event}) {
  return Container(
    height: 60,
    width: Get.width * 0.32,
    decoration: BoxDecoration(
      color: ColorPallete.primary,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        bottomLeft: Radius.circular(30),
      ),
    ),
    child: Container(
      margin: EdgeInsets.only(left: 4, top: 4, bottom: 4),
      decoration: BoxDecoration(
        color: ColorPallete.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          bottomLeft: Radius.circular(28),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 20),
          //const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              Get.to(() => Menu(
                    url: event!.menuurl,
                  ));
            },
            child: Row(
              children: [
                Image.asset(
                  "assets/images/menuIcon.png",
                  height: 15,
                  width: 25,
                ),
                const SizedBox(
                  width: 0,
                ),
                Text(
                  'Menu',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    letterSpacing: 1.25,
                    color: ColorPallete.blue,
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
                Icon(
                  Icons.arrow_forward_outlined,
                  color: ColorPallete.blue,
                  size: 18,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget offerContainer2({name, offer, endDate}) {
  return Container(
    height: 60,
    width: Get.width * 0.8,
    color: Colors.transparent,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            // Image.asset(
            //   "assets/images/offersIcon.png",
            //   height: 30,
            //   width: 30,
            //   color: Colors.white,
            // ),
            // const SizedBox(width: 10),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "$name",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ColorPallete.white),
                  ),
                  // Text(
                  //   "$offer",
                  //   style: TextStyle(
                  //       fontSize: 16,
                  //       color: Colors.white,
                  //       fontWeight: FontWeight.bold),
                  // ),
                ]),
          ],
        ),
      ],
    ),
  );
}

pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file;
  try {
    _file = await _imagePicker.pickImage(
      source: source,
      preferredCameraDevice: CameraDevice.front,
      imageQuality: source == ImageSource.camera ? 30 : 70,
      // maxHeight: 200,
      // maxWidth: 200,
    );
  } catch (e) {
    showDialog(
        context: Get.context!,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Allow Permission'),
            children: [
              SimpleDialogOption(
                child: Text("Open Settings to Allow Camera Permission"),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SimpleDialogOption(
                        child: TextButton(
                      child: Text("Open Settings"),
                      onPressed: () async {
                        Navigator.pop(Get.context!);
                        await openAppSettings();
                      },
                    )),
                  ],
                ),
              ),
            ],
          );
        });
    // }
  }
  if (_file != null) {
    return await _file.readAsBytes();
  }
}

// _selectImage(BuildContext context) {
//   return showDialog(
//       context: context,
//       builder: (context) {
//         return SimpleDialog(
//           title: const Text('Update Profile Pic'),
//           children: [
//             SimpleDialogOption(
//               padding: const EdgeInsets.all(20),
//               child: const Text('Take a photo'),
//               onPressed: () async {
//                 Navigator.of(context).pop();
//                 Uint8List file = await pickImage(
//                   ImageSource.camera,
//                 );
//               },
//             ),
//             SimpleDialogOption(
//               padding: const EdgeInsets.all(20),
//               child: const Text('Choose from Gallery'),
//               onPressed: () async {
//                 Navigator.of(context).pop();
//                 Uint8List file = await pickImage(
//                   ImageSource.gallery,
//                 );
//               },
//             ),
//           ],
//         );
//       });
// }

// Widget profileCard({context}) {
//   return Column(
//     children: [
//       Container(
//         margin: const EdgeInsets.only(left: 15, right: 15),
//         child: Card(
//           elevation: 8,
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//           child: SizedBox(
//             height: 110,
//             width: Get.width,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 SizedBox(
//                   width: Get.width * 0.7,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         "Umesh Kumar",
//                         style: TextStyle(
//                             fontSize: 20, fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(
//                         height: 5,
//                       ),
//                       const Text(
//                         "Member ID",
//                         style: TextStyle(fontSize: 13),
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       Row(
//                         children: [
//                           Image.asset(
//                             "assets/images/verifiedIcon.png",
//                             height: 12,
//                             width: 12,
//                           ),
//                           const SizedBox(
//                             width: 5,
//                           ),
//                           const Text(
//                             "Verified",
//                             style: TextStyle(
//                                 color: ColorPallete.green, fontSize: 12),
//                           )
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//                 Stack(
//                   children: [
//                     Align(
//                       alignment: Alignment.center,
//                       child: GestureDetector(
//                         onTap: () {
//                           _selectImage(context);
//                         },
//                         child: CircleAvatar(
//                           radius: 25,
//                           backgroundImage:
//                               Image.asset("assets/images/ProfilePic.png").image,
//                         ),
//                       ),
//                     ),
//                     const Positioned(
//                       bottom: 25,
//                       left: 30,
//                       child: CircleAvatar(
//                         backgroundColor: ColorPallete.primary,
//                         radius: 10,
//                         child: Icon(
//                           Icons.camera_alt,
//                           size: 12,
//                         ),
//                       ),
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     ],
//   );
// }

// newProfileCard({context, user}) {
//   return Container(
//     // height: Get.height * 0.7,
//     margin: const EdgeInsets.only(
//       left: 15,
//       right: 15,
//     ),
//     child: Stack(
//       children: [
//         Align(
//           alignment: Alignment.bottomCenter,
//           child: Container(
//             margin: const EdgeInsets.only(top: 60),
//             child: Card(
//               elevation: 8,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10)),
//               child: Container(
//                 padding: const EdgeInsets.only(left: 15, right: 15),
//                 width: Get.width,
//                 child: Padding(
//                   padding: const EdgeInsets.only(top: 80),
//                   child: Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 "${user.firstname ?? "Name"} ${user.lastname ?? ""}",
//                                 style: TextStyle(
//                                     fontSize: 20, fontWeight: FontWeight.bold),
//                               ),
//                               const SizedBox(
//                                 height: 5,
//                               ),
//                               SizedBox(
//                                 width: 150,
//                                 child: Text(
//                                   "${user.isVerified ? user.memberid ?? "Member ID" : "Not issued yet."}",
//                                   overflow: TextOverflow.ellipsis,
//                                   style: TextStyle(fontSize: 13),
//                                 ),
//                               ),
//                               const SizedBox(
//                                 height: 10,
//                               ),
//                               Row(
//                                 children: [
//                                   user.isVerified
//                                       ? Image.asset(
//                                           "assets/images/verifiedIcon.png",
//                                           height: 12,
//                                           width: 12,
//                                         )
//                                       : Image.asset(
//                                           "assets/images/notVerified.png",
//                                           height: 12,
//                                           width: 12,
//                                         ),
//                                   const SizedBox(
//                                     width: 5,
//                                   ),
//                                   user.isVerified
//                                       ? Text(
//                                           "Verified",
//                                           style: TextStyle(
//                                               color: ColorPallete.green,
//                                               fontSize: 12),
//                                         )
//                                       : Text(
//                                           "Verification Pending",
//                                           style: TextStyle(
//                                               color: Colors.red, fontSize: 12),
//                                         )
//                                 ],
//                               )
//                             ],
//                           ),
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: [
//                               Text(
//                                 "Validity",
//                                 style: TextStyle(
//                                     color: ColorPallete.grey, fontSize: 15),
//                               ),
//                               Text(
//                                 "${user.isVerified ? DateFormat("dd-MM-yyyy").format(DateTime.parse(user.endDate)) : "--/--/----"}",
//                                 style: TextStyle(
//                                     fontSize: 16, fontWeight: FontWeight.w600),
//                               ),
//                               SizedBox(
//                                 height: 24,
//                               )
//                             ],
//                           )
//                         ],
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       Column(
//                         children: [
//                           // QRCard(user: user),
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         Align(
//           alignment: Alignment.topCenter,
//           child: GestureDetector(
//             onTap: () {
//               _selectImage(context);
//             },
//             child: CircleAvatar(
//               radius: 60,
//               backgroundImage: Image.network(
//                       "${user.image ?? "https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1180&q=80"}")
//                   .image,
//             ),
//           ),
//         ),
//         // Align(
//         //   alignment: const Alignment(0.2, -0.7),
//         //   child: GestureDetector(
//         //     onTap: () {
//         //       _selectImage(context);
//         //     },
//         //     child: const CircleAvatar(
//         //       backgroundColor: ColorPallete.backgroud,
//         //       radius: 15,
//         //       child: Icon(
//         //         Icons.camera_alt,
//         //         size: 18,
//         //       ),
//         //     ),
//         //   ),
//         // ),
//       ],
//     ),
//   );
// }

Widget QRCard({required user, required String restaurantID}) {
  return Container(
    alignment: Alignment.center,
    // width: Get.width,
    padding: const EdgeInsets.symmetric(vertical: 20),
    child: Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text(
              "Authentication Code",
              style: TextStyle(
                  fontSize: 20,
                  color: ColorPallete.grey,
                  fontWeight: FontWeight.w500),
            ),
            Text("Show the code to GP Partner", style: TextStyle(fontSize: 13)),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        // QR Code
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1),
              borderRadius: BorderRadius.circular(10)),
          child: user.isVerified
              ? QrImage(
                  data:
                      "${user.tempurl}${user.userId}&restaurantId=${restaurantID}",
                  version: QrVersions.auto,
                  size: 180,
                )
              : Image.asset(
                  'assets/images/dummyqrcode.png',
                  fit: BoxFit.cover,
                  height: 180,
                  width: 180,
                ),
        ),
        // Note
        const SizedBox(
          height: 20,
        ),
        Text(
          user.isVerified
              ? "Verification Required!\nOTP will be sent to your registered mobile number."
              : "Approval Pending!",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: user.isVerified ? ColorPallete.blue : Colors.red),
        )
      ],
    ),
  );
}

Widget drawerWidget(user, {key, context}) {
  var currentPath = ModalRoute.of(context)?.settings.name;
  CommonController commonControl = Get.find();
  // var user = Member.fromJson(json.decode(json.encode(d)));
  var lc = LoginController();
  return Drawer(
    backgroundColor: ColorPallete.white,
    child: ListView(
      children: [
        DrawerHeader(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(Icons.arrow_back)),
              ListTile(
                title: Text(
                  user != null ? "${user.firstname} ${user.lastname}" : "Guest",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  user != null ? "${user.memberid}" : "Member ID",
                  style: TextStyle(color: ColorPallete.grey, fontSize: 13),
                ),
                trailing: CircleAvatar(
                  radius: 25,
                  backgroundColor: ColorPallete.primary,
                  foregroundColor: ColorPallete.primary,
                  backgroundImage: CachedNetworkImageProvider(user != null
                      ? user.image != null || user.image != ""
                          ? "${user.image}"
                          : "assets/images/ProfilePic.png"
                      : "assets/images/ProfilePic.png"),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: Get.height * 0.7,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Get.to(
                        () => NotificationsScreen(),
                      );
                    },
                    child: Container(
                      height: 30,
                      decoration: BoxDecoration(
                          color: Color(0xffFEF9EB),
                          borderRadius: BorderRadius.circular(10)),
                      margin: const EdgeInsets.only(right: 15, left: 15),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Stack(
                            children: [
                              Icon(
                                Icons.notifications,
                                size: 22,
                                color: currentPath == "/NotificationScreen"
                                    ? ColorPallete.blue
                                    : Colors.grey,
                              ),
                              commonControl.isNotificationAvailable.value
                                  ? Positioned(
                                      right: 2,
                                      child: Container(
                                        height: 8,
                                        width: 8,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                          SizedBox(
                            width: 35,
                          ),
                          Text(
                            "Notifications",
                            style: GoogleFonts.inter(
                                fontSize: 13,
                                color: currentPath == "/NotificationScreen"
                                    ? ColorPallete.blue
                                    : Color(0xff7D8E8C)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: ListTile(
                      title: Text(
                        "Home",
                        style: TextStyle(
                            color: currentPath == "/HomeScreen"
                                ? ColorPallete.blue
                                : Colors.black),
                      ),
                      leading: Icon(
                        Icons.home,
                        size: 25,
                        color: currentPath == "/HomeScreen"
                            ? ColorPallete.blue
                            : Colors.grey,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Get.to(() => const HomeScreen());
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: ListTile(
                      title: Text(
                        "Profile",
                        style: TextStyle(
                            color: currentPath == "/ProfileScreen"
                                ? ColorPallete.blue
                                : Colors.black),
                      ),
                      leading: Icon(
                        Icons.person,
                        color: currentPath == "/ProfileScreen"
                            ? ColorPallete.blue
                            : Colors.grey,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Get.to(() => const ProfileScreen());
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: ListTile(
                      title: Text(
                        "Events",
                        style: TextStyle(
                            color: currentPath == "/EventsScreen"
                                ? ColorPallete.blue
                                : Colors.black),
                      ),
                      leading: Image.asset("assets/images/EventsIconDrawer.png",
                          height: 20,
                          width: 20,
                          color: currentPath == "/EventsScreen"
                              ? ColorPallete.blue
                              : Colors.grey),
                      onTap: () {
                        Navigator.pop(context);
                        Get.to(() => EventsScreen());
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: ListTile(
                      title: Text(
                        "Restaurants",
                        style: TextStyle(
                            color: currentPath == "/RestaurantsScreen"
                                ? ColorPallete.blue
                                : Colors.black),
                      ),
                      leading: Image.asset(
                          "assets/images/VectorRestaurantIconDrawer.png",
                          height: 20,
                          width: 20,
                          color: currentPath == "/RestaurantsScreen"
                              ? ColorPallete.blue
                              : Colors.grey),
                      onTap: () {
                        Navigator.pop(context);
                        Get.to(() => RestaurantsScreen());
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: ListTile(
                      title: Text(
                        "Contact Us",
                        style: TextStyle(
                            color: currentPath == "/ContactUs"
                                ? ColorPallete.blue
                                : Colors.black),
                      ),
                      leading: Icon(
                        Icons.message,
                        size: 25,
                        color: currentPath == "/ContactUs"
                            ? ColorPallete.blue
                            : Colors.grey,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Get.to(() => const ContactUs(
                              forceAPI: false,
                            ));
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: ListTile(
                      title: Text(
                        "About Us",
                        style: TextStyle(
                          color: currentPath == "/AboutUs"
                              ? ColorPallete.blue
                              : Colors.black,
                        ),
                      ),
                      leading: Icon(
                        Icons.info_outline,
                        size: 25,
                        color: currentPath == "/AboutUs"
                            ? ColorPallete.blue
                            : Colors.grey,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Get.to(() => const AboutUs());
                      },
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(left: 25),
                child: ListTile(
                  title: const Text(
                    "Logout",
                    style: TextStyle(color: Colors.red),
                  ),
                  leading: const Icon(
                    Icons.logout,
                    color: Colors.red,
                  ),
                  onTap: () async {
                    await lc.Logout();
                    Get.offAll(() => const LoginScreen());
                  },
                ),
              )
            ],
          ),
        ),
      ],
    ),
  );
}

Widget profileCard2({user}) {
  return Container(
    margin: const EdgeInsets.only(left: 15, right: 15),
    child: Card(
      elevation: 8,
      // color: ColorPallete.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        margin: const EdgeInsets.only(
          right: 10,
          left: 10,
        ),
        height: 110,
        width: Get.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: Get.width * 0.55,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user != null
                        ? "${user.firstname ?? "Name"} ${user.lastname ?? ""}"
                        : "",
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "${user != null ? user.memberid : "Member ID"}",
                    style: TextStyle(fontSize: 13),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      user != null
                          ? Image.asset(
                              user.isVerified
                                  ? "assets/images/verifiedIcon.png"
                                  : "assets/images/notVerified.png",
                              height: 12,
                              width: 12,
                            )
                          : Container(),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        user != null
                            ? user.isVerified
                                ? "Verified"
                                : user.image ==
                                        Constants().DEFAULT_PROFILE_IMAGE
                                    ? "Not Verified"
                                    : "Verification Pending"
                            : "Verified",
                        style: TextStyle(
                            color: user != null
                                ? user.isVerified
                                    ? ColorPallete.green
                                    : Colors.red
                                : ColorPallete.green,
                            fontSize: 10),
                      )
                    ],
                  )
                ],
              ),
            ),
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: ColorPallete.primary,
                  foregroundColor: ColorPallete.primary,
                  backgroundImage: CachedNetworkImageProvider(
                      "${user != null ? user.image : ""}"),
                ),
                const SizedBox(width: 5),
                Image.asset(
                  "assets/images/qrcode.png",
                  height: 20,
                  width: 20,
                ),
                const SizedBox(width: 5),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 10,
                ),
              ],
            )
          ],
        ),
      ),
    ),
  );
}

Widget choiceChipCustom(String text, bool isSelected, int i, ChildTag childTag,
    {isEditable = false}) {
  var c = Get.put(CommonController());
  return Chip(
    label: Text(text),
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    side: BorderSide(
      color: !isSelected ? ColorPallete.grey : Color(0xff003087),
    ),
    deleteIcon: Icon(
      Icons.check_circle,
      color: !isSelected ? ColorPallete.grey : Color(0xff003087),
      size: 20,
    ),
    labelPadding: const EdgeInsets.only(left: 10, right: 10),
    onDeleted: () {
      if (isEditable) {
        if (c.selectedPreferencesTag.contains(childTag.id) == false) {
          c.selectedPreferencesTag.add(childTag.id);
        } else {
          c.selectedPreferencesTag.remove(childTag.id);
          c.selectedPreferencesTag.remove(childTag.id.toString());
        }
      }
    },
  );
}

Widget CustomChip({text, type, isSelected, onDeleted}) {
  var c = Get.put(CommonController());
  return Chip(
    label: Text(text),
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    side: BorderSide(
      color: !isSelected ? ColorPallete.grey : Color(0xff003087),
    ),
    deleteIcon: Icon(
      Icons.check_circle,
      color: !isSelected ? ColorPallete.grey : Color(0xff003087),
      size: 20,
    ),
    labelPadding: const EdgeInsets.only(left: 10, right: 10),
    onDeleted: () {
      onDeleted.call();
    },
  );
}

enum FoodType {
  Vegetarian,
  NonVegetarian,
}

var select;
List gender = ["Male", "Female", "Other"];
