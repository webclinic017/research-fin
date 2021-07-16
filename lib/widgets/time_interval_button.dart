import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:researchfin/theme/colors.dart';
import 'package:researchfin/controller/controller.dart';

class TimeIntervalButton extends StatefulWidget {
  final String label;
  final Function()? onTap;

  TimeIntervalButton({required this.label, this.onTap});
  @override
  _TimeIntervalButtonState createState() => _TimeIntervalButtonState();
}

class _TimeIntervalButtonState extends State<TimeIntervalButton> {
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
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
        decoration: BoxDecoration(
          color: AppColor.stockBlack,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
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
        child: Text(
          widget.label,
          style: Theme.of(context).textTheme.subtitle2!.copyWith(
                color: controller.function.contains(widget.label) ? AppColor.stockGreen : AppColor.stockWhite,
              ),
        ),
      ),
    );
  }
}
