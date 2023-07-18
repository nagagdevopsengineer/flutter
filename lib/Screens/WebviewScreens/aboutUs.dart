import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gpapp/ColorPallete.dart';
import 'package:gpapp/Controllers/CommonController.dart';
import 'package:gpapp/Controllers/NetworkControllers/Models.dart';
import 'package:gpapp/Controllers/NetworkControllers/notificationApi.dart';
import 'package:gpapp/Widgets/CommonWidgets.dart';
import 'package:gpapp/models/notifications.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);
  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  var isLoading = true;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  CommonController _commonControl = Get.put(CommonController());
  GetStorage ds = GetStorage();
  late WebViewController _webViewController;
  double webProgress = 0;
  var user;

  getUser() async {
    user = Member.fromJson(json.decode(json.encode(ds.read('user'))));
    setState(() {});
  }

  @override
  void initState() {
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
    _commonControl.getNotificationReadStatus(forceapi: true);
    // else if (Platform.isIOS) WebView.platform = IOSWebView();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: ColorPallete.backgroud,
      appBar: AppBarWidget(
        _key,
        title: "About us",
        isBack: true,
      ),
      drawer: drawerWidget(
        user,
        context: context,
        key: _key,
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        color: Colors.white,
        child: Column(
          children: [
            webProgress < 1
                ? SizedBox(
                    height: 5,
                    child: LinearProgressIndicator(
                      value: webProgress,
                      color: ColorPallete.primary,
                      backgroundColor: Color(0xffFFEFC6),
                    ),
                  )
                : SizedBox(),
            Expanded(
              child: WebView(
                backgroundColor: ColorPallete.backgroud,
                initialUrl: 'https://gplife.s3.amazonaws.com/about.html',
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController controller) {
                  _webViewController = controller;
                },
                onProgress: (progress) => setState(() {
                  this.webProgress = progress / 100;
                }),
                onPageFinished: (url) {
                  setState(() {
                    isLoading = false;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:gpapp/ColorPallete.dart';
// import 'package:gpapp/Widgets/CommonWidgets.dart';

// class AboutUs extends StatefulWidget {
//   const AboutUs({Key? key}) : super(key: key);

//   @override
//   State<AboutUs> createState() => _AboutUsState();
// }

// class _AboutUsState extends State<AboutUs> {
//   final GlobalKey<ScaffoldState> _key = GlobalKey();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _key,
//       backgroundColor: ColorPallete.backgroud,
//       appBar: AppBarWidget(_key, title: "About us", isBack: true),
//       drawer: drawerWidget(context: context),
//       body: Container(
//         margin: const EdgeInsets.all(20),
//         color: Colors.white,
//       ),
//     );
//   }
// }
