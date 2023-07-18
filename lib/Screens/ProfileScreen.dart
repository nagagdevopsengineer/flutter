import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpapp/ColorPallete.dart';
import 'package:gpapp/Controllers/NetworkControllers/ManualCalls.dart';
import 'package:gpapp/Controllers/PreferenceController.dart';
import 'package:gpapp/Screens/authScreens/loginscreen.dart';
import 'package:gpapp/Screens/contactUs.dart';
import 'package:gpapp/Widgets/CommonWidgets.dart';
import 'package:gpapp/Widgets/PreferencesWidget.dart';
import 'package:gpapp/Widgets/button.dart';
import 'package:gpapp/Widgets/profileCard.dart';
import 'package:intl/intl.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../Controllers/CommonController.dart';
import '../Controllers/NetworkControllers/notificationApi.dart';
import '../models/notifications.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  DateTime selectedDate = DateTime(2000, 12, 09);

  final ScrollController _scrollController = ScrollController();
  GetStorage ds = GetStorage();
  var api = ManualAPICall();
  var c = Get.put(PreferenceController());
  var d = Get.put(CommonController());
  var isVeg = true;
  var user;
  CommonController _commonControl = Get.put(CommonController());

  updatePlayerId() async {
    if (d.userIdOneSignal != "" && user.playerId != d.userIdOneSignal.value) {
      await ManualAPICall()
          .updatePlayerID(user: user, playerId: d.userIdOneSignal.value);

      user = await ManualAPICall().getMemeberDetails(userId: ds.read('userId'));
    }
    var _externalUserId = user.memberid;
    OneSignal.shared.setExternalUserId(_externalUserId!).then((results) {
      // if (results == null) return;
      print("$results ExternalUserId");
    });
  }

  bool _isDeleteAccount = false;

  void _delete(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            elevation: 2,
            actions: [
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                alignment: Alignment.center,
                //height: 170,
                height: MediaQuery.of(context).size.height * 0.23,
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Are you sure to delete your account?',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        letterSpacing: 0.1,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Image.asset(
                      "assets/images/deleteAccount.png",
                      height: 44,
                      width: 28,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: 120,
                          height: 40,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: ColorPallete.blue)),
                          child: Button(
                              fontColor: ColorPallete.blue,
                              borderWidth: 2,
                              borderRadius: 30,
                              title: 'Yes',
                              horizontalPadding: 40,
                              fontSize: 13,
                              color: Colors.white,
                              verticalPadding: 10,
                              onPressed: () async {
                                Get.showOverlay(
                                    loadingWidget: Center(
                                      child: CircularProgressIndicator(
                                          color: ColorPallete.primary),
                                    ),
                                    asyncFunction: () async {
                                      var isDeleted = await ManualAPICall()
                                          .deleteAccount(
                                              user: c.user.value,
                                              isDelete: true);
                                      if (isDeleted) {
                                        setState(() {
                                          _isDeleteAccount = true;
                                        });
                                        GetStorage().write("isLogin", false);
                                        GetStorage().erase();
                                        Get.offAll(() => LoginScreen());
                                        Get.snackbar(
                                            "Your Account has been deleted successfully.",
                                            "",
                                            snackPosition:
                                                SnackPosition.BOTTOM);
                                      }
                                    });
                              }),
                        ),
                        Container(
                          width: 125,
                          height: 40,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: ColorPallete.blue)),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                primary: ColorPallete.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                side: BorderSide(
                                  width: 2,
                                  color: ColorPallete.blue,
                                ),
                              ),
                              onPressed: () {
                                // Close the dialog
                                Navigator.of(context).pop();
                              },
                              child: Center(
                                  child: Text(
                                'No',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ))),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 18,
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    c.getUser(forceAPI: false);
    c.isVeg.value = c.user.value.isVeg ?? true;
    _isDeleteAccount = c.user.value.isDeleted ?? false;
    c.getUser(forceAPI: true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (c.user.value.isDeleted!) {
        ds.erase();
        Get.offAll(() => LoginScreen());
        Get.snackbar("Your account has been deleted.", "",
            snackPosition: SnackPosition.BOTTOM);
      }
    });
    _commonControl.getNotificationReadStatus(forceapi: true);
    // c.updateContinuosly();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        key: _key,
        backgroundColor: ColorPallete.backgroud,
        appBar: AppBarWidgetProfileScreen(
          _key,
          title: "Profile",
          isBack: c.user.value.isVerified! ? true : false,
          isDrawer: c.user.value.isVerified! ? true : false,
        ),
        drawer: c.user.value.isVerified!
            ? drawerWidget(
                c.user.value,
                key: _key,
                context: context,
              )
            : null,
        body: SingleChildScrollView(
          child: Column(
            children: [
              ListView(
                shrinkWrap: true,
                controller: _scrollController,
                children: [
                  // Card
                  ProfileCard(
                    user: c.user.value,
                    context: context,
                  ),
                  const SizedBox(height: 10),
                  // Content
                  Obx(() => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        child: GestureDetector(
                          onTap: () {
                            c.isExpanded.value = !c.isExpanded.value;
                          },
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13)),
                            child: Container(
                              margin: c.isExpanded.value
                                  ? const EdgeInsets.symmetric(
                                      vertical: 30, horizontal: 25)
                                  : const EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 25),
                              height: c.isExpanded.value ? 180 : 25,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      c.isExpanded.value
                                          ? const Text(
                                              "Preferences: ",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: ColorPallete.grey),
                                            )
                                          : Container(),
                                      c.isExpanded.value
                                          ? GestureDetector(
                                              onTap: () async {
                                                !c.isLoadingPreferences.value ||
                                                        c.childTags
                                                            .isNotEmpty ||
                                                        c.masterTags.isNotEmpty
                                                    ? c.selectedPreferencesTag
                                                            .isNotEmpty
                                                        ? selectPreferences(
                                                            isEditable: c
                                                                .selectedPreferencesTag
                                                                .isEmpty,
                                                            user: c.user.value,
                                                            childTags: c
                                                                .childTags
                                                                .value,
                                                            masterTags: c
                                                                .masterTags
                                                                .value)
                                                        : VegetarianDialog(
                                                            user: c.user.value)
                                                    : null;
                                              },
                                              child: Obx(() {
                                                return c.isLoadingPreferences
                                                            .value ||
                                                        c.childTags.isEmpty ||
                                                        c.masterTags.isEmpty
                                                    ? Center(
                                                        child: SizedBox(
                                                          height: 15,
                                                          width: 15,
                                                          child:
                                                              CircularProgressIndicator(
                                                            color: ColorPallete
                                                                .primary,
                                                          ),
                                                        ),
                                                      )
                                                    : Row(
                                                        children: [
                                                          c.selectedPreferencesTag
                                                                  .isNotEmpty
                                                              ? Image.asset(
                                                                  c.user.value
                                                                          .isVeg!
                                                                      ? "assets/images/vegIcon.png"
                                                                      : "assets/images/nonVegIcon.png",
                                                                  height: 18,
                                                                  width: 18,
                                                                )
                                                              : Container(),
                                                          SizedBox(
                                                            width: 4,
                                                          ),
                                                          Text(
                                                            c.selectedPreferencesTag
                                                                    .isEmpty
                                                                ? "+ Add"
                                                                : "View",
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              color:
                                                                  ColorPallete
                                                                      .blue,
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                              }),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      c.isExpanded.value
                                          ? const Text(
                                              "Email ID: ",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: ColorPallete.grey),
                                            )
                                          : Container(),
                                      c.isExpanded.value
                                          ? Text(
                                              c.user.value != null
                                                  ? "${c.user.value.email}"
                                                  : "guest@gourmetplanet.com",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: ColorPallete.grey),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      c.isExpanded.value
                                          ? const Text(
                                              "Phone Number: ",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: ColorPallete.grey),
                                            )
                                          : Container(),
                                      c.isExpanded.value
                                          ? Text(
                                              c.user.value != null
                                                  ? "${c.user.value.mobile}"
                                                  : "99xxxxxxx1",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: ColorPallete.grey),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      c.isExpanded.value
                                          ? const Text(
                                              "DOB: ",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: ColorPallete.grey),
                                            )
                                          : Container(),
                                      c.isExpanded.value
                                          ? GestureDetector(
                                              onTap: () {
                                                showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.parse(
                                                        c.user.value.dob!),
                                                    firstDate:
                                                        DateTime(1995, 1, 1),
                                                    lastDate:
                                                        DateTime(2032, 1, 1));
                                              },
                                              child: Text(
                                                "${DateFormat("dd/MM/yyyy").format(DateTime.parse(c.user.value.dob!).toLocal())}",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: ColorPallete.grey),
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      c.isExpanded.value
                                          ? const Text(
                                              "Address: ",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: ColorPallete.grey),
                                            )
                                          : Container(),
                                      c.isExpanded.value
                                          ? Container(
                                              width: Get.width * 0.4,
                                              child: Text(
                                                c.user.value != null
                                                    ? "${c.user.value.address}"
                                                    : "H. No. 234/B, Street No. 07, Karol Bagh, New Delhi - 110015", //dfjklads, India, Bharat, Hindustan, Hind, Himalaya, Rajasthan, YoYo",
                                                textAlign: TextAlign.end,
                                                maxLines: 5,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: ColorPallete.grey),
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        c.isExpanded.value =
                                            !c.isExpanded.value;
                                      });
                                      _scrollController.animateTo(
                                          _scrollController
                                              .position.maxScrollExtent,
                                          duration:
                                              const Duration(milliseconds: 300),
                                          curve: Curves.easeInOut);
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        !c.isExpanded.value
                                            ? const Text("View More",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: ColorPallete.blue,
                                                    fontWeight:
                                                        FontWeight.w500))
                                            : const Text("Hide",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: ColorPallete.blue,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                        !c.isExpanded.value
                                            ? const Icon(
                                                Icons.arrow_drop_down,
                                                color: ColorPallete.blue,
                                              )
                                            : const Icon(
                                                Icons.arrow_drop_up,
                                                color: ColorPallete.blue,
                                              ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )),

                  const SizedBox(height: 20),
                  !c.isExpanded.value
                      ? Column(
                          children: [
                            //const SizedBox(height: 60),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Container(
                                padding: EdgeInsets.only(top: 30),
                                decoration: !_isDeleteAccount ||
                                        !c.user.value.isDeleted!
                                    ? BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 3,
                                            blurRadius: 5,
                                            offset: Offset(0,
                                                4), // changes position of shadow
                                          ),
                                        ],
                                        color: ColorPallete.white)
                                    : BoxDecoration(),
                                child: _isDeleteAccount
                                    ? Column(
                                        children: [
                                          Text(
                                            'Your account has been deleted',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13,
                                              letterSpacing: 1.25,
                                              color: Color(0xffC71616),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 40,
                                          ),
                                        ],
                                      )
                                    : Column(
                                        children: [
                                          Text(
                                            'If you wish to delete your account',
                                            style: GoogleFonts.inter(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 50),
                                            child: GestureDetector(
                                              onTap: () {},
                                              child: Container(
                                                clipBehavior: Clip.hardEdge,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    elevation: 0,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20,
                                                            vertical: 13),
                                                    primary: Colors.white,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                    ),
                                                    side: BorderSide(
                                                      width: 2,
                                                      color: Color(0xffC71616),
                                                    ),
                                                  ),
                                                  onPressed: _isDeleteAccount ==
                                                          false
                                                      ? () => _delete(context)
                                                      : null,
                                                  child: Center(
                                                    child: Text(
                                                      'Request Deletion',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: GoogleFonts.inter(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 13,
                                                        letterSpacing: 1.25,
                                                        color:
                                                            Color(0xffC71616),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 30,
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ],
                        )
                      : Container(),
                  // c.user.value.isVerified == false
                  //     ? Container(
                  //         padding: EdgeInsets.symmetric(horizontal: 20),
                  //         child: Column(
                  //           children: [
                  //             SizedBox(
                  //               height: 30,
                  //             ),
                  //             Container(
                  //               padding: EdgeInsets.symmetric(horizontal: 50),
                  //               child: GestureDetector(
                  //                 onTap: () {},
                  //                 child: Container(
                  //                   clipBehavior: Clip.hardEdge,
                  //                   decoration: BoxDecoration(
                  //                     borderRadius: BorderRadius.circular(30),
                  //                   ),
                  //                   child: ElevatedButton(
                  //                     style: ElevatedButton.styleFrom(
                  //                       elevation: 0,
                  //                       padding: EdgeInsets.symmetric(
                  //                           horizontal: 20, vertical: 13),
                  //                       primary: Colors.white,
                  //                       shape: RoundedRectangleBorder(
                  //                         borderRadius:
                  //                             BorderRadius.circular(30),
                  //                       ),
                  //                       side: BorderSide(
                  //                         width: 2,
                  //                         color: ColorPallete.blue,
                  //                       ),
                  //                     ),
                  //                     onPressed: () {},
                  //                     //onPressed: () => _verify(context),
                  //                     child: Center(
                  //                       child: Text(
                  //                         'Contact Us',
                  //                         textAlign: TextAlign.center,
                  //                         style: GoogleFonts.inter(
                  //                           fontWeight: FontWeight.w500,
                  //                           fontSize: 13,
                  //                           letterSpacing: 1.25,
                  //                           color: ColorPallete.blue,
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ),
                  //             ),
                  //             SizedBox(
                  //               height: 30,
                  //             ),
                  //           ],
                  //         ),
                  //       )
                  //     : Container(),
                ],
              ),
            ],
          ),
        ),
        floatingActionButton: c.user.value.isVerified == false
            ? FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: () {
                  //Navigator.pop(context);
                  Get.to(() => const ContactUs(
                        forceAPI: false,
                      ));
                },
                child: Icon(Icons.message, color: Colors.amber[400]),
              )
            : null,
      ),
    );
  }
}
