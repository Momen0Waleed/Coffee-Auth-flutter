import 'package:coffee/core/constants/theme/colors/app_colors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TextFieldWidget extends StatefulWidget {
  TextFieldWidget({
    super.key,
    required this.title,
    this.prefixIcon,
    this.isPassword = false,
    this.maxlines = 1,
    this.minlines,
    this.color =  Colors.white,
    this.textColor =  Colors.grey,
    this.borderColor =  Colors.grey,

    this.controller,
    this.validator,
    this.onChanged
  });
  final String title;
  final Widget? prefixIcon;
  final bool isPassword;
  final int? maxlines;
  final int? minlines;
  final Color color;
  final Color textColor;
  final Color borderColor;

  final TextEditingController? controller;
  String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  bool obscurePassword = true;
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: TextFormField(
        controller: widget.controller,
        maxLines: widget.maxlines,
        minLines: widget.minlines,
        validator: widget.validator,
        onChanged: widget.onChanged,
        obscureText: widget.isPassword
            ? (widget.isPassword ? obscurePassword : false)
            : false,
        style: theme.bodyMedium!.copyWith(
          color: widget.textColor,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: widget.color,
          hintText: widget.title,
          hintStyle: theme.bodyMedium!.copyWith(
            color: widget.textColor
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(width: 1, color:widget.borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(width: 1, color: widget.borderColor),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: AppColors.redError, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: AppColors.redError, width: 1),
          ),
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}
