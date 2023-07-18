import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpapp/Controllers/CommonController.dart';

class OtpTextfield extends StatelessWidget {
  final bool first;
  final bool last;
  final TextEditingController? textEditingController;
  const OtpTextfield(
      {Key? key,
      required this.first,
      required this.last,
      this.textEditingController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      child: AspectRatio(
        aspectRatio: 0.7,
        child: TextField(
          autofocus: true,
          controller: textEditingController,
          onChanged: (value) {
            if (value.length == 1 && last == false) {
              FocusScope.of(context).nextFocus();
            } else if (value.length == 0 && first == false) {
              FocusScope.of(context).previousFocus();
            }
          },
          showCursor: false,
          readOnly: false,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            color: Color(0xff1F1F39),
            fontSize: 16,
          ),
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            filled: true,
            counterText: "",
            hintText: "X",
            fillColor: const Color(0xffF1F1F1),
            border: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0xff7F7F7F),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}

var c = Get.put(LoginController());

Widget OtpFieldOld() {
  return OtpTextField(
    keyboardType: TextInputType.number,
    numberOfFields: 4,
    borderColor: Color(0xff7F7F7F),
    fillColor: Color(0xffF1F1F1),
    filled: true,
    focusedBorderColor: Color(0xff7F7F7F),
    enabledBorderColor: Color(0xff7F7F7F),
    showFieldAsBox: true,
    borderWidth: 1.2,
    borderRadius: BorderRadius.circular(10),
    fieldWidth: 55,
    margin: EdgeInsets.only(right: 6),
    decoration: InputDecoration(
      hintText: "X",
      hintStyle: TextStyle(
        color: Color(0xff7F7F7F),
      ),
    ),
    onCodeChanged: (String code) {
      c.otpNumber.value += code;
    },
    onSubmit: (String verificationCode) {},
  );
}
