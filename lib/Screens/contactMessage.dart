import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gpapp/ColorPallete.dart';
import 'package:gpapp/Controllers/CommonController.dart';
import 'package:gpapp/Controllers/NetworkControllers/ManualCalls.dart';
import 'package:gpapp/Controllers/NetworkControllers/Models.dart';
import 'package:gpapp/Controllers/NetworkControllers/notificationApi.dart';
import 'package:gpapp/Screens/contactUs.dart';
import 'package:gpapp/Widgets/CommonWidgets.dart';
import 'package:gpapp/models/notifications.dart';

class ContactUsMessage extends StatefulWidget {
  const ContactUsMessage({Key? key}) : super(key: key);
  @override
  State<ContactUsMessage> createState() => _ContactUsMessageState();
}

class _ContactUsMessageState extends State<ContactUsMessage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  TextEditingController SubjectController = TextEditingController();
  TextEditingController Body = TextEditingController();
  var api = ManualAPICall();
  GetStorage ds = GetStorage();
  var user;
  var focusNode = FocusNode();
  CommonController _commonControl = CommonController();

  sendMessage() {
    Get.showOverlay(
        asyncFunction: () async {
          if (SubjectController.text.isEmpty || Body.text.isEmpty) {
            Get.snackbar(
              "Please fill all the fields",
              "",
              snackPosition: SnackPosition.BOTTOM,
            );
            return;
          }
          var res = await api.contactUsAPI(
            subject: SubjectController.text,
            body: Body.text,
            memberid: user.id,
          );
          print("$res yahi hai bc");
          if (res) {
            Get.snackbar("Query Submitted!", "We will get back to you soon.",
                snackPosition: SnackPosition.BOTTOM);
            SubjectController.clear();
            Body.clear();
            setState(() {});
            Get.off(ContactUs(
              forceAPI: true,
            ));
          }
        },
        loadingWidget: Center(
          child: CircularProgressIndicator(color: ColorPallete.primary),
        ));
  }

  @override
  void initState() {
    user = Member.fromJson(json.decode(json.encode(ds.read("user"))));
_commonControl.getNotificationReadStatus(forceapi: true);
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
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextField(
                    controller: SubjectController,
                    textInputAction: TextInputAction.next,
                    maxLength: 256,
                    decoration: InputDecoration(
                      counterText: "",
                      filled: true,
                      hintText: "Type Subject",
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.grey)),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  )),
              const SizedBox(height: 10),
              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextField(
                    controller: Body,
                    maxLines: 5,
                    textInputAction: TextInputAction.send,
                    onEditingComplete: (() {
                      sendMessage();
                    }),
                    decoration: InputDecoration(
                      filled: true,
                      hintText: "Message",
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.grey)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  )),
              const SizedBox(
                height: 30,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 100),
                child: roundedButton(
                    text: "Send",
                    onPressed: () async {
                      sendMessage();
                    },
                    color: ColorPallete.blue,
                    textColor: Colors.white,
                    isIcon: false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
