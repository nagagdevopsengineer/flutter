import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpapp/utils/colors.dart';

class PrefernceButton extends StatelessWidget {
  final Color color;
  final String title;
  final double? horizontalPadding;
  final double? verticalPadding;
  final double borderRadius;
  final double fontSize;
  final double borderWidth;
  final Color borderColor;
  final double elevation;
  final Function onPressed;
  int? sizedBoxHeight = 0;
  Icon? editIcon;
  Color? fontColor = Colors.white;

  PrefernceButton({
    required this.title,
    required this.color,
    required this.verticalPadding,
    Key? key,
    this.borderRadius = 7,
    this.fontSize = 20,
    this.horizontalPadding,
    this.borderWidth = 0,
    this.borderColor = Colors.transparent,
    this.elevation = 2,
    required this.onPressed,
    this.fontColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: elevation,
              padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding ?? 0,
                  vertical: verticalPadding ?? 0),
              primary: color,
              side: BorderSide(
                width: borderWidth,
                color: borderColor,
              ),
            ),
            onPressed: () {
              onPressed.call();
            },
            child: Row(
              children: [
                Text(
                  title,
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.w500,
                    fontSize: fontSize,
                    letterSpacing: 1.5,
                    color: fontColor,
                  ),
                ),
                SizedBox(
                  width: 3,
                ),
                Icon(
                  Icons.edit_outlined,
                  color: ColorPallete.blue,
                  size: 14,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
