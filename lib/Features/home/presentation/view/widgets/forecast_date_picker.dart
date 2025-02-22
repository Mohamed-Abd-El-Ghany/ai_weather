import 'package:flutter/material.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import '../../../../../Core/resources/color_manager.dart';
import '../../../data/models/weather_response.dart';

class ForecastDatePicker extends StatelessWidget {
  final double leftPadding;
  final double width;
  final double height;
  final DateTime firstForecastDate;
  final List<ForecastDay> forecastDays;
  final ValueChanged<int> onDateChanged;

  const ForecastDatePicker({
    super.key,
    required this.leftPadding,
    required this.width,
    required this.height,
    required this.firstForecastDate,
    required this.forecastDays,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.only(left: leftPadding),
      child: DatePicker(
        firstForecastDate,
        daysCount: forecastDays.length,
        initialSelectedDate: firstForecastDate,
        width: screenWidth * 0.2,
        height: screenHeight * 0.18,
        selectionColor: ColorManager.blue,
        selectedTextColor: ColorManager.white,
        dayTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
        dateTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
        monthTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
        onDateChange: (selectedDate) {
          final index = forecastDays.indexWhere((f) =>
          f.date.year == selectedDate.year &&
              f.date.month == selectedDate.month &&
              f.date.day == selectedDate.day);
          if (index != -1) {
            onDateChanged(index);
          }
        },
      ),
    );
  }
}