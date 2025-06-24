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
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyMedium?.color ?? Colors.grey;
    final colonColor = theme.primaryColor;
    final amPmColor = theme.textTheme.bodyMedium?.color ?? Colors.grey;

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
            _buildFlipUnit(hour, textColor),
            _buildColon(colonColor),
            _buildFlipUnit(minute, textColor),
            _buildColon(colonColor),
            _buildFlipUnit(second, textColor),
            const SizedBox(width: 8),
            Text(
              amPm,
              style: TextStyle(
                fontSize: 12,
                color: amPmColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFlipUnit(int value, Color color) {
    return AnimatedFlipCounter(
      value: value,
      duration: const Duration(milliseconds: 500),
      wholeDigits: 2,
      textStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }

  Widget _buildColon(Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Text(
        ":",
        style: TextStyle(
          fontSize: 24,
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
