import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewMoreText extends StatefulWidget {
  final String text;
  final int maxLength;
  Color textColor = Color(
    0xff7D8E8C,
  );
  ViewMoreText(
      {Key? key,
      required this.text,
      required this.maxLength,
      required this.textColor})
      : super(key: key);
  @override
  State<ViewMoreText> createState() => _ViewMoreTextState();
}

class _ViewMoreTextState extends State<ViewMoreText> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: widget.text.substring(
                  0, isExpanded ? widget.text.length : widget.maxLength),
              style: GoogleFonts.inter(color: widget.textColor),
            ),
            if (widget.text.length > widget.maxLength && !isExpanded)
              TextSpan(
                text: isExpanded ? "" : "...View",
                style: GoogleFonts.inter(
                  color: Color(0xff3A6BC5),
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  letterSpacing: 1.3,
                ),
              ),
          ],
        ),

        //maxLines: !isExpanded ? 2 : null,
      ),
    );
  }
}
