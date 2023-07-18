import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpapp/Controllers/CommonController.dart';
import 'package:gpapp/Controllers/NetworkControllers/APIController.dart';
import 'package:gpapp/Screens/WebviewScreens/PrivacyPolicy.dart';
import 'package:gpapp/Screens/authScreens/signUpScreen.dart';
import 'package:gpapp/Widgets/button.dart';
import 'package:gpapp/Widgets/text_field_input.dart';
import 'package:gpapp/utils/colors.dart';
import 'package:new_version/new_version.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var c = Get.put(LoginController());
  var api = Get.put(APIController());
  final Uri uri =
      Uri.parse('https://gplife.s3.amazonaws.com/privacy-policy-gp.html');
  Future<void> _launchUrlPrivacyPolicy(uri) async {
    if (!await launchUrl(uri)) {
      throw 'Could not launch $uri';
    }
  }
  var isButtonEnabled = true;
  VersionStatus? status;
  var packageInfo;
  var version;

  @override
  void initState() {
    getVersion();
    super.initState();
  }

  getVersion() async {
    packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Container(
            height: MediaQuery.of(context).size.height,
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
                      ' Mobile Number',
                      textAlign: TextAlign.start,
                      style: GoogleFonts.inter(
                        color: const Color(0xff242424),
                        fontSize: 19,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFieldInput(
                      textEditingController: c.mobileNumber.value,
                      hintText: 'XXXXXXXXXX',
                      textInputType: TextInputType.number,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Button(
                      title: 'Send OTP',
                      color: isButtonEnabled ? primaryColor : Colors.grey,
                      horizontalPadding:
                          MediaQuery.of(context).size.width * 0.24,
                      verticalPadding: 14,
                      borderRadius: 50,
                      fontSize: 13,
                      onPressed: () {
                        setState(() {
                          isButtonEnabled = false;
                        });
                        Get.showOverlay(
                            asyncFunction: () async {
                              await api.generateOTP(
                                  mobileNumber: c.mobileNumber.value.text);
                              setState(() {
                                isButtonEnabled = true;
                              });
                            },
                            loadingWidget: Center(
                              child: CircularProgressIndicator(
                                color: ColorPallete.primary,
                              ),
                            ));
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Get.to(() => SignUp()),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: "Don’t have an account?  "),
                        TextSpan(
                          text: 'Sign up',
                          style: GoogleFonts.lato(
                            decoration: TextDecoration.underline,
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff276EF1),
                          ),
                        ),
                      ],
                    ),
                    style: GoogleFonts.lato(
                      fontSize: 17,
                    ),
                  ),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Container(
                //       padding: const EdgeInsets.symmetric(vertical: 8),
                //       child: GestureDetector(
                //         onTap: () async {
                //           //Get.to(() => SignUpOtpScreen());
                //         },
                //         child: Text(
                //           "",
                //         ),
                //       ),
                //     ),
                //     GestureDetector(
                //       onTap: () async {
                //         //Get.to(() => SignUpOtpScreen());
                //         Get.to(() => SignUp());
                //       },
                //       child: Container(
                //         padding: const EdgeInsets.symmetric(vertical: 8),
                //         child: Text(
                //           'Sign up ',
                //         ),
                //       ),
                //     ),
                //   ],
                // ),

                Flexible(
                  child: Container(),
                  flex: 2,
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            "Disclaimer and",
                            style: GoogleFonts.lato(
                              fontSize: 13,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            Get.to(() => PrivacyPolicy());
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              ' Privacy Policy ',
                              style: GoogleFonts.lato(
                                fontSize: 13,
                                color: const Color(0xff276EF1),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    version != null
                        ? Text('Version ' + version)
                        : Text('Version'),
                  ],
                ),
                SizedBox(
                  height: 80,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
