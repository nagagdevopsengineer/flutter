import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gpapp/ColorPallete.dart';
import 'package:gpapp/Widgets/CommonWidgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Picks extends StatefulWidget {
  const Picks({Key? key, required this.url}) : super(key: key);

  final url;

  @override
  State<Picks> createState() => _PicksState();
}

class _PicksState extends State<Picks> {
  var isLoading = true;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  late WebViewController _webViewController;
  double webProgress = 0;

  @override
  void initState() {
    print(widget.url);
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
    // else if (Platform.isIOS) WebView.platform = IOSWebView();
  }

  GetStorage ds = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: ColorPallete.backgroud,
      appBar: AppBarWidget(_key,
          title: "Sonny's Picks", isBack: true, isDrawer: false),
      // drawer: drawerWidget(user, context: context, key: _key),
      body: widget.url != null
          ? Container(
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
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
                      initialUrl: '${widget.url}',
                      javascriptMode: JavascriptMode.unrestricted,
                      onProgress: (progress) => setState(() {
                        webProgress = progress / 100;
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
            )
          : Container(
              height: Get.height,
              width: Get.width,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Coming Soon",
                      style: TextStyle(
                          fontSize: 25,
                          color: ColorPallete.blue,
                          fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 60,
                  )
                ],
              ),
            ),
    );
  }
}
