import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController? textEditingController;
  final String hintText;
  final bool isPass;
  final TextInputType textInputType;
  final IconButton? suffixIcon;
  final maxLength;
  final bool readOnly;
  var onTap;
  bool isNumber;
  final IconButton? trailingIconButton;
  final TextCapitalization? textCapitalization;
  final TextInputAction? textInputAction;


  TextFieldInput(
      {Key? key,
      this.textEditingController,
      required this.hintText,
      this.isPass = false,
      required this.textInputType,
      this.suffixIcon,
      this.maxLength = null,
      this.trailingIconButton = null,
      this.readOnly = false,
      this.onTap,
      this.isNumber = true, this.textCapitalization, this.textInputAction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: const BorderSide(
        color: Color(0xff7F7F7F),
        width: 1,
      ),
      borderRadius: BorderRadius.circular(10),
    );
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xff7F7F7F),
          width: 1,
        ),
      ),
      child: IntrinsicHeight(
        child: isNumber
            ? Row(
                children: [
                  Text(
                    '  +91',
                    style: GoogleFonts.inter(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const VerticalDivider(
                    width: 5,
                    indent: 8,
                    endIndent: 8,
                    thickness: 1,
                    color: Color(0xffD9D9D9),
                  ),
                  // const SizedBox(
                  //   width: ,
                  // ),
                  Flexible(
                    child: TextFormField(
                     
                      controller: textEditingController,
                      maxLength: 10,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Can\'t be empty';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: hintText,
                        counterText: "",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(10),
                      ),
                      keyboardType: textInputType,
                      obscureText: isPass,
                      // maxLength: maxLength,
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  // const SizedBox(
                  //   width: 8,
                  // ),
                  Flexible(
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Can\'t be empty';
                        }
                        return null;
                      },
                      controller: textEditingController,
                      maxLength: this.maxLength,
                      onTap: () {
                        onTap.call();
                      },
                      readOnly: readOnly,
                      decoration: InputDecoration(
                        suffixIcon: suffixIcon,
                        hintText: hintText,
                        counterText: "",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(15),
                      ),
                      keyboardType: textInputType,
                      obscureText: isPass,
                      // maxLength: maxLength,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
