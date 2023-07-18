import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gpapp/ColorPallete.dart';
import 'package:gpapp/Constants.dart';
import 'package:gpapp/Controllers/CommonController.dart';
import 'package:gpapp/Screens/Decider.dart';
import 'package:gpapp/Screens/authScreens/otpScreen.dart';
import 'package:openapi/openapi.dart';
import 'package:http/http.dart' as http;

class APIController extends GetxController {
  var opeapi = Openapi(basePathOverride: '${Constants().baseUrl}');
  var c = Get.put(LoginController());
  GetStorage ds = GetStorage();

  generateOTPAPICall(mobileNumber) async {
    try {
      // var response =
      //     await controller.jhiUserControllerGenerateotp(login: Login(((b) {
      //   b.login = mobileNumber;
      //   b.otp = 0;
      //   b.password = "pass";
      // })));

      var response = await http.post(
          Uri.parse(Constants().baseUrl + 'generateotp'),
          body: jsonEncode({"login": mobileNumber}),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json"
          });

      if (response.statusCode == 200) {
        ds.write("mobile", mobileNumber);
        Get.to(() => otpScreen());
        Get.snackbar("OTP Sent!", "", snackPosition: SnackPosition.BOTTOM);
      } else if (response.statusCode == 404) {
        Get.snackbar("Mobile not registered!", "",
            snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar("We are having trouble while fetching the data", "",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("We are having trouble while fetching the data", "",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  generateOTP({required String mobileNumber}) async {
    if (c.mobileNumber.value.text.isNotEmpty) {
      Get.showOverlay(
          loadingWidget: Center(
            child: CircularProgressIndicator(
              color: ColorPallete.primary,
            ),
          ),
          asyncFunction: () async {
            await generateOTPAPICall(mobileNumber);
          });
    } else {
      Get.snackbar("Please enter mobile number", "",
          animationDuration: Duration(seconds: 1),
          backgroundColor: Colors.black87,
          colorText: Colors.white,
          snackStyle: SnackStyle.FLOATING,
          borderRadius: 5,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future authenticateOTPCall({required int otp}) async {
    ds.write("isLogin", false);
    var c = Get.put(LoginController());
    // var controller = opeapi.getJhiUserControllerApi();
    try {
      var response = await http.post(
          Uri.parse(Constants().baseUrl + "authenticateotp"),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json"
          },
          body: jsonEncode(
              {"login": ds.read("mobile"), "otp": otp, "password": "pass"}));

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        var id = jsonResponse[0]['id'];
        await ds.write("userId", id);
        await ds.write("isLogin", true);
        Get.offAll(() => Decider());
      } else {
        Get.snackbar("Wrong OTP!", "", snackPosition: SnackPosition.BOTTOM);
        c.otpController.value.clear();
      }
    } catch (e) {
      Get.snackbar("Could not connect to Gourmet Planet!", "",
          backgroundColor: Colors.red, snackPosition: SnackPosition.BOTTOM);
      c.otpController.value.clear();
    }
    // ds.write("userId", "327a57f5-db85-4d46-ac6d-3645813160c5");
  }

  authenticateOTP() async {
    if (c.otpNumber.value != "" && c.otpNumber.value.length > 3) {
      await authenticateOTPCall(otp: int.parse(c.otpNumber.value));
    } else if (c.otpNumber.value.length < 4) {
      Get.snackbar("Please Enter OTP", "", snackPosition: SnackPosition.BOTTOM);
    } else {}
  }
}
