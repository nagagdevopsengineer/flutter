import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpapp/Controllers/NetworkControllers/ManualCalls.dart';
import 'package:gpapp/Controllers/NetworkControllers/Models.dart';
import 'package:gpapp/Controllers/NetworkControllers/SignUpAPIController.dart';
import 'package:gpapp/Controllers/SignUpController.dart';
import 'package:gpapp/Widgets/CommonWidgets.dart';
import 'package:gpapp/Widgets/button.dart';
import 'package:gpapp/utils/colors.dart';

import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyEmailOtp extends StatefulWidget {
  const VerifyEmailOtp({Key? key}) : super(key: key);
  @override
  State<VerifyEmailOtp> createState() => _VerifyEmailOtpState();
}

class _VerifyEmailOtpState extends State<VerifyEmailOtp> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  var c = Get.put(SignUpController());
  var api = SignUPAPIController();
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
    c.emailOTPNumber.value = "";
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController otpController = TextEditingController();
    return Scaffold(
      key: _key,
      appBar: AppBarWidget(_key,
          isBack: true,
          title: 'Verify Email',
          isDrawer: false,
          titleColor: ColorPallete.blue),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'OTP has been sent to your email',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: const Color(0xff242424),
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    '${c.email.value.text}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: const Color(0xff7D8E8C),
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
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
                          onCompleted: (v) {},
                          onChanged: (value) {
                            c.emailOTPNumber.value = value;
                          },
                          beforeTextPaste: (text) {
                            return false;
                          },
                        )),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Button(
                title: 'Sign UP',
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
                        if (c.emailOTPNumber.value.length > 3 ||
                            c.emailOTPNumber.value != "") {
                          var isVerified = await api.verifyEmailOTP(
                              int.parse(c.emailOTPNumber.value));

                          if (isVerified) {
                            await api.SignUpMember();
                          }
                          otp.clear();
                          c.emailOTPNumber.value = '';
                          c.emailOTP.value.clear();
                        } else {
                          Get.snackbar("Please Enter OTP!", "",
                              snackPosition: SnackPosition.BOTTOM);
                        }
                        setState(() {
                          isButtonEnabled = true;
                        });
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
              Flexible(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
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
                            api.sendOTPForSignUp(resend: true);
                          },
                          loadingWidget: Center(
                            child: CircularProgressIndicator(
                              color: ColorPallete.primary,
                            ),
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
