import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpapp/Controllers/NetworkControllers/ManualCalls.dart';
import 'package:gpapp/Controllers/NetworkControllers/SignUpAPIController.dart';
import 'package:gpapp/Controllers/SignUpController.dart';
import 'package:gpapp/Screens/WebviewScreens/PrivacyPolicy.dart';
import 'package:gpapp/Screens/authScreens/loginscreen.dart';
import 'package:gpapp/Widgets/CommonWidgets.dart';
import 'package:gpapp/Widgets/button.dart';
import 'package:gpapp/Widgets/text_field_input.dart';
import 'package:gpapp/utils/colors.dart';
import 'package:intl/intl.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  var c = Get.put(SignUpController());
  String? selectedState;
  String? selectedDistrict;
  var states = [];
  var districts = [];
  DateTime? pickedDate;
  var isButtonEnabled = true;

  getStates() async {
    states = await ManualAPICall().getStates();
    setState(() {});
  }

  getDistrict(int stateId) async {
    districts = await ManualAPICall().getDistrict(stateId);
    setState(() {});
  }

  // bool isAdult(String birthDateString) {
  //   String datePattern = "dd-MM-yyyy";
  //   DateTime birthDate = DateFormat(datePattern).parse(birthDateString);
  //   DateTime today = DateTime.now();
  //   int yearDiff = today.year - birthDate.year;
  //   int monthDiff = today.month - birthDate.month;
  //   int dayDiff = today.day - birthDate.day;
  //   return yearDiff > 18 || yearDiff == 18 && monthDiff >= 0 && dayDiff >= 0;
  // }

  bool isAdult2(String birthDateString) {
    String datePattern = "dd-MM-yyyy";
    // Current time - at this moment
    DateTime today = DateTime.now();
    // Parsed date to check
    DateTime birthDate = DateFormat(datePattern).parse(birthDateString);
    // Date to check but moved 18 years ahead
    DateTime adultDate = DateTime(
      birthDate.year + 18,
      birthDate.month,
      birthDate.day,
    );

    return adultDate.isBefore(today);
  }

  @override
  void initState() {
    getStates();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: mobileBackgroundColor,
      appBar: AppBarWidget(_key,
          isBack: true,
          title: 'Sign Up',
          isDrawer: false,
          titleColor: ColorPallete.blue),
      body: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        scrollDirection: Axis.vertical,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.17),
            width: double.infinity,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  TextFieldInput(
                    textEditingController: c.firstName.value,
                    isNumber: false,
                    hintText: 'First Name',
                    onTap: () {},
                    textInputType: TextInputType.name,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFieldInput(
                    textEditingController: c.lastName.value,
                    onTap: () {},
                    isNumber: false,
                    hintText: 'Last Name',
                    textInputType: TextInputType.name,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    child: TextFieldInput(
                      readOnly: true,
                      onTap: () async {
                        var initialDate = await DateTime(
                            DateTime.now().year - 18,
                            DateTime.now().month,
                            DateTime.now().day);
                        pickedDate = await showDatePicker(
                            context: context,
                            initialDate: initialDate,
                            firstDate: DateTime(1950),
                            lastDate: initialDate);
                        if (pickedDate != null) {
                          //pickedDate output format => 2021-03-10 00:00:00.000
                          String formattedDate =
                              DateFormat('dd/MM/yyyy').format(pickedDate!);
//formatted date output using intl package =>  2021-03-16
                          setState(() {
                            c.dob.value.text =
                                formattedDate; //set output date to TextField value.
                            c.pickedDob.value = pickedDate.toString();
                          });
                        } else {}
                      },
                      textEditingController: c.dob.value,
                      isNumber: false,
                      hintText: 'DOB (DD/MM/YYYY)',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_month),
                        onPressed: () async {
                          var initialDate = await DateTime(
                              DateTime.now().year - 18,
                              DateTime.now().month,
                              DateTime.now().day);
                          pickedDate = await showDatePicker(
                              context: context,
                              initialDate: initialDate,
                              firstDate: DateTime(1950),
                              lastDate: initialDate);
                          if (pickedDate != null) {
                            //pickedDate output format => 2021-03-10 00:00:00.000
                            String formattedDate =
                                DateFormat('dd/MM/yyyy').format(pickedDate!);
//formatted date output using intl package =>  2021-03-16
                            setState(() {
                              c.dob.value.text =
                                  formattedDate; //set output date to TextField value.
                              c.pickedDob.value = pickedDate.toString();
                            });
                          } else {}
                        },
                      ),
                      textInputType: TextInputType.name,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFieldInput(
                    textEditingController: c.mobile.value,
                    hintText: 'XXXXXXXXXX',
                    onTap: () {},
                    textInputType: TextInputType.number,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFieldInput(
                    textEditingController: c.email.value,
                    isNumber: false,
                    hintText: 'Email',
                    onTap: () {},
                    textInputType: TextInputType.emailAddress,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 0),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border:
                          Border.all(color: Colors.grey.shade500, width: 1.5),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: DropdownButton<String>(
                            value: selectedState,
                            underline: Container(),
                            icon: Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(
                                    Icons.keyboard_arrow_down_outlined,
                                    color: ColorPallete.grey,
                                  ),
                                ],
                              ),
                            ),
                            hint: Text("Select State"),
                            items: states
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e.id.toString(),
                                    child: Text("${e.name}"),
                                  ),
                                )
                                .toList(),
                            onChanged: (String? value) {
                              setState(() {
                                selectedState = value!;
                              });
                              Get.showOverlay(
                                  asyncFunction: () async {
                                    selectedDistrict = null;
                                    await getDistrict(
                                        int.parse(selectedState!));
                                    setState(() {});
                                  },
                                  loadingWidget: Center(
                                    child: CircularProgressIndicator(
                                        color: ColorPallete.primary),
                                  ));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 0),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border:
                          Border.all(color: Colors.grey.shade500, width: 1.5),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: DropdownButton<String>(
                            value: selectedDistrict,
                            underline: Container(),
                            icon: Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(
                                    Icons.keyboard_arrow_down_outlined,
                                    color: ColorPallete.grey,
                                  ),
                                ],
                              ),
                            ),
                            hint: Text("Select City/Town"),
                            items: districts
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e.id.toString(),
                                    child: Text("${e.name}"),
                                  ),
                                )
                                .toList(),
                            onChanged: (String? value) {
                              setState(() {
                                selectedDistrict = value;
                                c.districtId.value = int.parse(value!);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFieldInput(
                    textEditingController: c.address.value,
                    isNumber: false,
                    onTap: () {},
                    hintText: 'Address',
                    textInputType: TextInputType.streetAddress,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFieldInput(
                    textEditingController: c.pincode.value,
                    isNumber: false,
                    maxLength: 6,
                    onTap: () {},
                    hintText: 'Pincode',
                    textInputType: TextInputType.number,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Button(
                      title: 'Next',
                      color: isButtonEnabled ? primaryColor : ColorPallete.grey,
                      horizontalPadding:
                          MediaQuery.of(context).size.width * 0.22,
                      verticalPadding: 14,
                      borderRadius: 50,
                      fontSize: 13,
                      onPressed: () async {
                        Get.showOverlay(
                            asyncFunction: () async {
                              if (c.firstName.value.text.isEmpty ||
                                  c.lastName.value.text.isEmpty ||
                                  c.mobile.value.text.isEmpty ||
                                  c.email.value.text.isEmpty ||
                                  c.dob.value.text.isEmpty ||
                                  c.address.value.text.isEmpty ||
                                  c.pincode.value.text.isEmpty ||
                                  selectedState == null) {
                                Get.snackbar("All Fields are mandatory", "",
                                    snackPosition: SnackPosition.BOTTOM);
                              } else if (!RegExp(r'^[A-Za-z\s]+$')
                                  .hasMatch(c.firstName.value.text.trim())) {
                                Get.snackbar(
                                    "Please Enter Valid First Name", "",
                                    snackPosition: SnackPosition.BOTTOM);
                              } else if (!RegExp(r'^[A-Za-z\s]+$')
                                  .hasMatch(c.lastName.value.text.trim())) {
                                Get.snackbar("Please Enter Valid Last Name", "",
                                    snackPosition: SnackPosition.BOTTOM);
                              } else if (c.mobile.value.text.trim().length <
                                  10) {
                                Get.snackbar(
                                    "Please Enter Valid Mobile Number", "",
                                    snackPosition: SnackPosition.BOTTOM);
                              } else if (!RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(c.email.value.text.trim())) {
                                Get.snackbar("Please Enter@ Valid Email", "",
                                    snackPosition: SnackPosition.BOTTOM);
                              } else if (!RegExp(r"^[0-9]*$")
                                      .hasMatch(c.pincode.value.text.trim()) &&
                                  c.pincode.value.text.length != 6) {
                                Get.snackbar("Please Enter Valid Pincode", "",
                                    snackPosition: SnackPosition.BOTTOM);
                              } else {
                                SignUPAPIController().sendOTPForSignUp();
                              }
                            },
                            loadingWidget: Center(
                              child: CircularProgressIndicator(
                                  color: ColorPallete.primary),
                            ));
                      }),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          "Already have an account?  ",
                          style: GoogleFonts.lato(
                            fontSize: 13,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          Get.offAll(() => LoginScreen());
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            'Login ',
                            style: GoogleFonts.lato(
                              decoration: TextDecoration.underline,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xff276EF1),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
