import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpapp/Controllers/CommonController.dart';
import 'package:gpapp/Controllers/NetworkControllers/APIController.dart';
import 'package:gpapp/Controllers/NetworkControllers/ManualCalls.dart';
import 'package:gpapp/Controllers/NetworkControllers/Models.dart';
import 'package:gpapp/Widgets/button.dart';
import 'package:gpapp/utils/colors.dart';

import 'package:pin_code_fields/pin_code_fields.dart';

class otpScreen extends StatefulWidget {
  const otpScreen({Key? key}) : super(key: key);
  @override
  State<otpScreen> createState() => _otpScreenState();
}

class _otpScreenState extends State<otpScreen> {
  var c = Get.put(LoginController());
  var api = Get.put(APIController());
  final formKey = GlobalKey<FormState>();
  late String otpVal;
  var user;
  GetStorage ds = GetStorage();
  var ap = ManualAPICall();
  var isLoading = false;
  var isButtonEnabled = true;
  TextEditingController otp = TextEditingController();

  getUser() async {
    if (ds.read('user') != null) {
      user = Member.fromJson(jsonDecode(jsonEncode(ds.read('user'))));
    } else {
      var userId = await ds.read("userId");
      user = await ap.getMemeberDetails(userId: "${userId}");
    }
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    c.otpNumber.value = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController otpController = TextEditingController();
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.17),
          width: double.infinity,
          child: Column(
            children: [
              Flexible(
                child: Container(),
                flex: 1,
              ),
              Image.asset('assets/images/logo.png', height: 50),
              const Flexible(
                child: SizedBox(
                  height: 80,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '  ENTER',
                    textAlign: TextAlign.start,
                    style: GoogleFonts.inter(
                      color: const Color(0xff242424),
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    ' OTP',
                    textAlign: TextAlign.start,
                    style: GoogleFonts.inter(
                      color: const Color(0xff242424),
                      fontSize: 19,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: formKey,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: PinCodeTextField(
                          appContext: context,
                          pastedTextStyle: TextStyle(
                            color: Color(0xff7F7F7F),
                            fontWeight: FontWeight.bold,
                          ),
                          length: 4,
                          blinkWhenObscuring: true,
                          animationType: AnimationType.fade,

                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(8),
                            fieldHeight: 50,
                            fieldWidth: 50,
                            activeFillColor: Colors.white,
                            selectedColor: Color(0xff7F7F7F),
                            inactiveColor: Color(0xff7F7F7F),
                            borderWidth: 1,
                            inactiveFillColor: Colors.white,
                            selectedFillColor: Colors.white,
                            activeColor: Color(0xff7F7F7F),
                          ),
                          cursorColor: Color(0xff7F7F7F),
                          animationDuration: const Duration(milliseconds: 300),
                          enableActiveFill: true,
                          // errorAnimationController: errorController,
                          controller: otp,
                          hintCharacter: 'X',
                          keyboardType: TextInputType.number,
                          onCompleted: (v) {
                            // Helpers.hideKeyboard(context);
                            // onPressed!();
                          },
                          // onTap: () {
                          //   // print("Pressed");
                          // },
                          onChanged: (value) {
                            c.otpNumber.value = value;
                            // print(c.otpNumber);
                            // setState(() {
                            //   currentText = value;
                            // });
                          },
                          beforeTextPaste: (text) {
                            //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                            //but you can show anything you want here, like your pop up saying wrong paste format or etc
                            return false;
                          },
                        )),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Button(
                title: 'Login',
                color: isButtonEnabled ? primaryColor : ColorPallete.grey,
                horizontalPadding: MediaQuery.of(context).size.width * 0.24,
                verticalPadding: 14,
                borderRadius: 50,
                fontSize: 13,
                onPressed: () {
                  setState(() {
                    isButtonEnabled = false;
                  });
                  Get.showOverlay(
                      asyncFunction: () async {
                        await api.authenticateOTP();
                        otp.clear();
                        c.otpNumber.value = '';
                        c.otpController.value.clear();
                        getUser();

                        setState(
                          () {
                            isButtonEnabled = true;
                          },
                        );
                      },
                      loadingWidget: Center(
                        child: CircularProgressIndicator(
                            color: ColorPallete.primary),
                      ));
                },
              ),
              const SizedBox(
                height: 5,
              ),
              // Text(
              //   'OTP Sent!',
              //   style: GoogleFonts.inter(
              //     fontWeight: FontWeight.w400,
              //     color: const Color(0xff6D817E),
              //     fontSize: 13,
              //   ),
              // ),
              Flexible(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.12,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Didn’t Receive OTP?',
                    style: GoogleFonts.lato(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.showOverlay(
                          asyncFunction: () async {
                            await api.generateOTP(
                                mobileNumber: c.mobileNumber.value.text);
                          },
                          loadingWidget: Center(
                            child: CircularProgressIndicator(
                                color: ColorPallete.primary),
                          ));
                    },
                    child: Text(
                      'Resend',
                      style: GoogleFonts.lato(
                        decoration: TextDecoration.underline,
                        fontSize: 13,
                        color: const Color(0xff003087),
                      ),
                    ),
                  ),
                ],
              ),
              Flexible(
                child: Container(),
                flex: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
