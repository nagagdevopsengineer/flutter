import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gpapp/ColorPallete.dart';
import 'package:gpapp/Controllers/NetworkControllers/notificationApi.dart';
import 'package:gpapp/Widgets/CommonWidgets.dart';
import 'package:gpapp/models/notifications.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);
  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  var isLoading = true;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  late WebViewController _webViewController;
  double webProgress = 0;

  @override
  void initState() {
    
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
    // else if (Platform.isIOS) WebView.platform = IOSWebView();
  }

  GetStorage ds = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: ColorPallete.backgroud,
      appBar: AppBarWidget(
        _key,
        title: "Privacy Policy",
        isBack: true,
        isDrawer: false,
        
      ),
      // drawer: drawerWidget(user, context: context, key: _key),
      body: Container(
        margin: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 20,
        ),
        color: ColorPallete.backgroud,
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
                initialUrl:
                    'https://gplife.s3.amazonaws.com/privacy-policy-gp.html',
                javascriptMode: JavascriptMode.unrestricted,
                onProgress: (progress) => setState(() {
                  this.webProgress = progress / 100;
                }),
                onWebViewCreated: (WebViewController controller) {
                  _webViewController = controller;
                },
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
