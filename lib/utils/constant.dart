import 'package:flutter/material.dart';

class Constants {
  static const primaryColor = Color(0xff0080FF);
  static const basicColor = Color(0xffF4F4F4);
  static const whiteColor = Color(0xffFFFFFF);
  static const darkColor = Color(0xff242424);
  static const secondaryColor = Color(0xffEF0F0F);

  static pickDate(context, DateTime pickedDate) async {
    var picked = await showDatePicker(
      context: context,
      initialDate: pickedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                  primary: Constants.primaryColor,
                  onPrimary: Constants.basicColor,
                  onSurface: Constants.primaryColor),
            ),
            child: child!);
      },
    );

    return picked;
  }

  static pickTime(context, DateTime pickedTime) async {
    var pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 00, minute: 00),
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                    primary: Constants.primaryColor,
                    onPrimary: Constants.basicColor,
                    onSurface: Constants.primaryColor)),
            child: child!);
      },
    );
    if (pickedTime != null) {
      return pickedTime;
    }
  }
}
