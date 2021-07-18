import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:researchfin/theme/colors.dart';
import 'package:researchfin/controller/controller.dart';

class NeoSquareButton extends StatefulWidget {
  final Function()? onTap;
  final Widget child;
  final double? width;
  final double? height;

  NeoSquareButton({this.onTap, required this.child, this.width, this.height});
  @override
  _NeoSquareButtonState createState() => _NeoSquareButtonState();
}

class _NeoSquareButtonState extends State<NeoSquareButton> {
  bool _isTapped = false;

  late Controller controller;
  @override
  Widget build(BuildContext context) {
    controller = Provider.of<Controller>(context);
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
        alignment: Alignment.center,
        width: widget.width ?? 48.0,
        height: widget.height ?? 48.0,
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
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
        child: widget.child,
      ),
    );
  }
}
