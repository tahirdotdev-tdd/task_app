import 'package:flutter/material.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';

class DigitalFlipClock extends StatefulWidget {
  const DigitalFlipClock({super.key});

  @override
  State<DigitalFlipClock> createState() => _DigitalFlipClockState();
}

class _DigitalFlipClockState extends State<DigitalFlipClock> {
  late Stream<DateTime> _timeStream;

  @override
  void initState() {
    super.initState();
    _timeStream = Stream.periodic(
      const Duration(seconds: 1),
      (_) => DateTime.now(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final digitFontSize = screenWidth * 0.06;
    final colonFontSize = screenWidth * 0.06;
    final amPmFontSize = screenWidth * 0.035;

    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyMedium?.color ?? Colors.grey;
    final colonColor = theme.primaryColor;
    final amPmColor = theme.textTheme.bodyMedium?.color ?? Colors.blue;

    return StreamBuilder<DateTime>(
      stream: _timeStream,
      initialData: DateTime.now(),
      builder: (context, snapshot) {
        final now = snapshot.data ?? DateTime.now();

        final int hourRaw = now.hour;
        final int hour = hourRaw % 12 == 0 ? 12 : hourRaw % 12;
        final int minute = now.minute;
        final int second = now.second;
        final String amPm = hourRaw >= 12 ? 'PM' : 'AM';

        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildFlipUnit(hour, textColor, digitFontSize),
            _buildColon(colonColor, colonFontSize),
            _buildFlipUnit(minute, textColor, digitFontSize),
            _buildColon(colonColor, colonFontSize),
            _buildFlipUnit(second, textColor, digitFontSize),
            SizedBox(width: screenWidth * 0.02),
            Text(
              amPm,
              style: TextStyle(
                fontSize: amPmFontSize,
                color: amPmColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFlipUnit(int value, Color color, double fontSize) {
    return AnimatedFlipCounter(
      value: value,
      duration: const Duration(milliseconds: 500),
      wholeDigits: 2,
      textStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }

  Widget _buildColon(Color color, double fontSize) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: fontSize * 0.2),
      child: Text(
        ":",
        style: TextStyle(
          fontSize: fontSize,
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
