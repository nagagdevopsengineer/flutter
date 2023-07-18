import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  var firstName = TextEditingController().obs;
  var lastName = TextEditingController().obs;
  var email = TextEditingController().obs;
  var mobile = TextEditingController().obs;
  var pincode = TextEditingController().obs;
  var address = TextEditingController().obs;
  var state = TextEditingController().obs;
  var city = TextEditingController().obs;
  var dob = TextEditingController().obs;
  var pickedDob = ''.obs;
  var districtId = 0.obs;

  var mobileOTP = TextEditingController().obs;
  var emailOTP = TextEditingController().obs;

  var mobileOTPNumber = "".obs;
  var emailOTPNumber = "".obs;
}
