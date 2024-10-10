import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final TextStyle? textStyle;
  final VoidCallback buttonCallback;

  const CustomElevatedButton({
    super.key,
    required this.text,
    this.backgroundColor,
    this.foregroundColor,
    this.textStyle,
    required this.buttonCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 280, // Set a fixed width
        height: 60, // Set a fixed height
        child: ElevatedButton(
          onPressed: () => buttonCallback.call(),
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? const Color(0xFF36E0E0),
            foregroundColor: foregroundColor ?? Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0), // Add rounded corners
            ),
            padding: EdgeInsets.zero, // Remove padding to maintain fixed size
          ),
          child: Text(
            text,
            style: textStyle ?? const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}




