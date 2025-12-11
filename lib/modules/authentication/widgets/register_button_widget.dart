import 'package:coffee/core/constants/theme/colors/app_colors.dart';
import 'package:flutter/material.dart';

class RegisterButtonWidget extends StatelessWidget {
  const RegisterButtonWidget({
    super.key,
    required this.bgColor,
    required this.child,
    this.buttonAction,
  });
  final Widget child;
  final Color bgColor;
  final Function()? buttonAction;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: buttonAction,
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(width: 1, color: AppColors.gold),
        ),
        child: Align(alignment: Alignment.center, child: child),
      ),
    );
  }
}
