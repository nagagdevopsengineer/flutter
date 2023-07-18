import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpapp/ColorPallete.dart';
import 'package:gpapp/Controllers/CommonController.dart';
import 'package:gpapp/Controllers/NetworkControllers/ManualCalls.dart';
import 'package:gpapp/Controllers/NetworkControllers/Models.dart';
import 'package:gpapp/Controllers/NetworkControllers/notificationApi.dart';
import 'package:gpapp/Screens/contactMessage.dart';
import 'package:gpapp/Widgets/CommonWidgets.dart';
import 'package:gpapp/Widgets/view_more_text.dart';
import 'package:gpapp/models/notifications.dart';
import 'package:intl/intl.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key, required this.forceAPI}) : super(key: key);

  final bool forceAPI;

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  TextEditingController SubjectController = TextEditingController();
  TextEditingController Body = TextEditingController();
  var api = ManualAPICall();
  GetStorage ds = GetStorage();
  var user;
  var focusNode = FocusNode();

  List<ContactUsQueryModel> queries = [];
  var isLoading = true;
  var isError = false;
    CommonController _commonControl =Get.find();

  getQuery({forceAPI = false}) async {
    var allQueries = ds.read('queries');
    if (allQueries != null && !forceAPI) {
      for (var query in allQueries) {
        queries
            .add(ContactUsQueryModel.fromJson(jsonDecode(jsonEncode(query))));
      }
    } else {
      try {
        queries = await ManualAPICall().ContactUsQueryAPI(user: user);
      } catch (e) {
        Get.snackbar("We are facing some error while fetching your Queries",
            "Please try again later.",
            snackPosition: SnackPosition.BOTTOM);
        setState(() {
          isError = true;
        });
      }
    }

    queries.sort(((a, b) => b.createdat!.compareTo(a.createdat!)));

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    user = Member.fromJson(json.decode(json.encode(ds.read("user"))));
    _commonControl.getNotificationReadStatus(forceapi: true);
    // getQuery(forceAPI: false);
    getQuery(forceAPI: true);
    super.initState();
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
        title: "Contact Us",
        isBack: true,
        isDrawer: user.isVerified == false ? false : true,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(color: ColorPallete.primary),
            )
          : isError
              ? Container(
                  height: Get.height,
                  width: Get.width,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text("Please try again later",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 25,
                                color: ColorPallete.blue,
                                fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("There was an error while fetching your Queries",
                          style: TextStyle(
                              fontSize: 15,
                              color: ColorPallete.blue,
                              fontWeight: FontWeight.normal)),
                      SizedBox(
                        height: 60,
                      ),
                    ],
                  ),
                )
              : queries.isEmpty
                  ? Container(
                      height: Get.height,
                      width: Get.width,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("No Queries",
                              style: TextStyle(
                                  fontSize: 25,
                                  color: ColorPallete.blue,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 60,
                          )
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: RefreshIndicator(
                            onRefresh: () async {
                              await getQuery(forceAPI: true);
                            },
                            child: SizedBox(
                              height: Get.height,
                              child: ListView.builder(
                                  itemCount: queries.length,
                                  keyboardDismissBehavior:
                                      ScrollViewKeyboardDismissBehavior.onDrag,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    print("${queries[index].subject}");
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 3),
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        elevation: 5,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 16),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Status: ",
                                                        style:
                                                            GoogleFonts.inter(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        queries[index].reply ==
                                                                null
                                                            ? "Pending"
                                                            : "Completed",
                                                        style:
                                                            GoogleFonts.inter(
                                                          color: queries[index]
                                                                      .reply ==
                                                                  null
                                                              ? Color(
                                                                  0xffC71616)
                                                              : Colors
                                                                  .green[800],
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Spacer(),
                                                  Icon(
                                                    Icons.circle,
                                                    size: 10,
                                                    color:
                                                        queries[index].reply ==
                                                                null
                                                            ? Color(0xffC71616)
                                                            : Colors.green[800],
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "Subject: ${queries[index].subject!}",
                                                style: GoogleFonts.inter(
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              queries[index].details!.length <
                                                      90
                                                  ? Text(
                                                      "Description: ${queries[index].details}",
                                                      style: GoogleFonts.inter(
                                                        color: Colors.grey,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    )
                                                  : ViewMoreText(
                                                      textColor: Color(
                                                        0xff7D8E8C,
                                                      ),
                                                      text:
                                                          "Description: ${queries[index].details!}",
                                                      maxLength: 82,
                                                    ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              queries[index].reply != null
                                                  ? queries[index]
                                                              .reply!
                                                              .length <
                                                          90
                                                      ? Text(
                                                          "Reply: ${queries[index].reply}",
                                                          style:
                                                              GoogleFonts.inter(
                                                            color: Colors.black,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        )
                                                      : ViewMoreText(
                                                          textColor:
                                                              Colors.black,
                                                          text:
                                                              "Reply: ${queries[index].reply!}",
                                                          maxLength: 82,
                                                        )
                                                  : Container(),
                                              queries[index].reply != null
                                                  ? SizedBox(
                                                      height: 10,
                                                    )
                                                  : Container(),
                                              queries[index].createdat != null
                                                  ? Text(
                                                      "${DateTime(queries[index].createdat!.year, queries[index].createdat!.month, queries[index].createdat!.day).toLocal() == DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day) ? "Today" : DateTime(queries[index].createdat!.year, queries[index].createdat!.month, queries[index].createdat!.day) == DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 1).toLocal() ? "Yesterday" : DateFormat("dd/MM/yyyy").format(queries[index].createdat!.toLocal())} at ${DateFormat("hh:mm a").format(queries[index].createdat!.toLocal())}",
                                                      style: GoogleFonts.inter(
                                                        color: Colors.grey,
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    )
                                                  : Text(""),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        ),
                      ],
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.off(ContactUsMessage());
        },
        backgroundColor: ColorPallete.blue,
        child: Icon(Icons.add),
      ),
      //floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }
}
