import 'package:flutter/material.dart';

class Constants {

  // final String baseUrl =
  //     "http://ec2-18-223-69-14.us-east-2.compute.amazonaws.com:3003/";
  //testing server
  // final String baseUrl =
  //     "http://ec2-18-223-69-14.us-east-2.compute.amazonaws.com:3003/";
=======
  //final String baseUrl = 'https://api.gplife.co/';
  final String baseUrl =
      "http://ec2-18-223-69-14.us-east-2.compute.amazonaws.com:3003/";
  final String APP_PACKAGE_NAME = "";
  final Image DEFAULT_PROFILE_IMAGES = Image.asset(
    'assets/images/logo.png',
    height: 50,
    width: 50,
  );
  final String DEFAULT_PROFILE_IMAGE =
      "https://gplife.s3.amazonaws.com/profile.png";
  final String APP_STORE_URL =
      "https://apps.apple.com/app/gourmet-planet/id1638079441";
  final String PLAY_STORE_URL =
      "https://play.google.com/store/apps/details?id=com.gourmetplanet.gpapplication";
}
