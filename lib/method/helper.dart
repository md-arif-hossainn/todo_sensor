import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Helper {
  Future<void> showDatePickerDialog(BuildContext context, Function(DateTime?) onDateSelected) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2026),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color.fromRGBO(54, 224, 224, 1.0),
            hintColor: const Color.fromRGBO(54, 224, 224, 1.0),
            colorScheme: const ColorScheme.light(primary: Color.fromRGBO(54, 224, 224, 1.0)),
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      onDateSelected(pickedDate);
    }
  }
}
