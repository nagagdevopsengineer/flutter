// import 'dart:html';

// import 'package:flutter/material.dart';
// import 'package:package_info_plus/package_info_plus.dart';
// import 'package:url_launcher/url_launcher.dart';

// const APP_STORE_URL =
//     'https://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftwareUpdate?id=YOUR-APP-ID&mt=8';
// const PLAY_STORE_URL =
//     'https://play.google.com/store/apps/details?id=YOUR-APP-ID';

// versionCheck(context) async {
//   String appUpdateURL = Platform.fromPlatform() ? APP_STORE_URL : PLAY_STORE_URL;

//   //Get Current installed version of app
//   final PackageInfo info = await PackageInfo.fromPlatform();
//   double currentVersion = double.parse(info.version.trim().replaceAll(".", ""));

//   //Get Latest version info from firebase config
//   // final RemoteConfig remoteConfig = await RemoteConfig.instance;
//   // remoteConfig.getString('force_update_current_version');
//   // double newVersion = double.parse(remoteConfig
//   //     .getString('force_update_current_version')
//   //     .trim()
//   //     .replaceAll(".", ""));

//   //Show Dialog to force user to update
//   if (newVersion > currentVersion) {
//     await showDialog<String>(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return new AlertDialog(
//           title: new Text("New Update Available"),
//           content: new Text("Please update now."),
//           actions: <Widget>[
//             FlatButton(
//               child: Text("Update Now"),
//               onPressed: () => _launchURL(appUpdateURL),
//             )
//           ],
//         );
//       },
//     );
//   }
// }

// _launchURL(String url) async {
//   if (await canLaunch(url)) {
//     await launch(url);
//   } else {
//     throw 'Could not launch $url';
//   }
// } 
