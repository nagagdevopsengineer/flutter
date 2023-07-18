import 'dart:convert';

import 'package:get/get.dart';
import 'package:gpapp/Constants.dart';
import 'package:gpapp/Controllers/NetworkControllers/Models.dart';
import 'package:gpapp/Controllers/SignUpController.dart';
import 'package:gpapp/Screens/authScreens/loginscreen.dart';
import 'package:gpapp/Screens/authScreens/verify_email_screen.dart';
import 'package:gpapp/Screens/authScreens/verify_mobile_screen.dart';
import 'package:http/http.dart' as http;

class SignUPAPIController {
  var c = Get.put(SignUpController());

  sendOTPForSignUp({resend = false}) async {
    var resp = await http.post(
        Uri.parse(Constants().baseUrl + "signup-verifications"),
        headers: {'Content-type': 'application/json', 'Platform': "Mobile"},
        body: json.encode({
          "mobile": int.parse(c.mobile.value.text),
          "email": c.email.value.text
        }));

    if (resp.statusCode == 200) {
      if (resend == false) {
        Get.to(() => VerifyMobileOtp());
      }
      Get.snackbar("OTP Sent!", "", snackPosition: SnackPosition.BOTTOM);
      return true;
    } else if (resp.statusCode == 408) {
      var jsonResp = jsonDecode(resp.body);
      Get.snackbar("${jsonResp['error']['message']}", "",
          snackPosition: SnackPosition.BOTTOM);
    } else {
      Get.snackbar("Something went wrong!", "Please try again later.",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  verifyMobileOTP(int otp) async {
    var resp = await http.post(
        Uri.parse(Constants().baseUrl + "validateMobileOTP"),
        headers: {'Content-type': 'application/json', 'Platform': "Mobile"},
        body: json.encode({"mobile": c.mobile.value.text, "otp": otp}));

    if (resp.statusCode == 200) {
      if (resp.body == true || resp.body == "true") {
        Get.to(() => VerifyEmailOtp());
        return true;
      }
      Get.snackbar(
        "Wrong OTP!",
        "",
        snackPosition: SnackPosition.BOTTOM,
      );
      c.mobileOTP.value.clear();
      c.mobileOTPNumber.value = "";
      return false;
    }
    return false;
  }

  verifyEmailOTP(int otp) async {
    var resp = await http.post(
        Uri.parse(Constants().baseUrl + "validateEmailOTP"),
        headers: {'Content-type': 'application/json', 'Platform': "Mobile"},
        body: json.encode({"email": c.email.value.text, "otp": otp}));

    if (resp.statusCode == 200) {
      if (resp.body == true || resp.body == "true") {
        return true;
      }
      Get.snackbar(
        "Wrong OTP!",
        "",
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
    return false;
  }

  SignUpMember() async {
    var dataToBePassed = SignUpModel(
        email: c.email.value.text,
        dob: c.pickedDob.value,
        image: Constants().DEFAULT_PROFILE_IMAGE,
        address: c.address.value.text,
        pincode: int.parse(c.pincode.value.text),
        remarks: "",
        firstname: c.firstName.value.text,
        lastname: c.lastName.value.text,
        memberid: 0,
        isActivated: false,
        isDeleted: false,
        isVerified: false,
        isveg: true,
        startDate: DateTime.now().toString(),
        endDate: DateTime.now().add(Duration(days: 10)).toString(),
        userId: "0",
        createdById: "",
        updatedById: "",
        mobile: int.parse(c.mobile.value.text),
        updatedAt: DateTime.now().toString(),
        createdAt: DateTime.now().toString(),
        uuid: "",
        anniversarydate: DateTime.now().toString(),
        tempurl: "",
        membertypeid: 1,
        otp: 0,
        playerid: "",
        rewardspoints: 0,
        districtsId: c.districtId.value);

    var resp = await http.post(Uri.parse(Constants().baseUrl + 'members'),
        headers: {'Content-type': 'application/json', 'Platform': "Mobile"},
        body: json.encode(dataToBePassed.toJson()));

    if (resp.statusCode == 200) {
      Get.offAll(() => LoginScreen());
      Get.snackbar("User has been registered successfully.", "",
          snackPosition: SnackPosition.BOTTOM);
    } else if (resp.statusCode == 408) {
      var jsonResp = jsonDecode(resp.body);
      Get.snackbar("${jsonResp['error']['message']}", "",
          snackPosition: SnackPosition.BOTTOM);
    } else {
      Get.snackbar("Something went wrong!", "Please try again later.",
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
