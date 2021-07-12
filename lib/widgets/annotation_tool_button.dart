import 'package:flutter/material.dart';

import 'package:researchfin/theme/colors.dart';

class AnnotationButton extends StatefulWidget {
  final IconData icon;
  final Function()? onTap;

  AnnotationButton({required this.icon, this.onTap});

  @override
  _AnnotationButtonState createState() => _AnnotationButtonState();
}

class _AnnotationButtonState extends State<AnnotationButton> {
  bool _isTapped = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (tapDownDetails) {
        setState(() {
          _isTapped = true;
        });
      },
      onTapUp: (tapUpDetails) {
        setState(() {
          _isTapped = false;
        });
      },
      child: Container(
        height: 56.0,
        width: 56.0,
        decoration: BoxDecoration(
            color: AppColor.stockBlack,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            boxShadow: _isTapped
            ? []
                : [
        BoxShadow(
        color: Colors.black.withOpacity(0.5),
        offset: Offset(4.0, 4.0),
        blurRadius: 8.0,
        spreadRadius: 1.0,
      ),
      BoxShadow(
        color: Colors.white.withOpacity(0.2),
        offset: Offset(-4.0, -4.0),
        blurRadius: 8.0,
        spreadRadius: 1.0,
      ),
      ],
    ),
    child: Icon(
    widget.icon,
    color: AppColor.stockWhite,
    size: 24.0,
    ),
    ),
    );
  }
}