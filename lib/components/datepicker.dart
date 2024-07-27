import 'package:app/helpers/date.dart';
import 'package:flutter/material.dart';

class DatePicker extends StatelessWidget {
  final Function(DateTime) onChanged;
  final DateTime selectedDate;
  const DatePicker(
      {super.key, required this.onChanged, required this.selectedDate});

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));

    if (picked != null && picked != selectedDate) {
      onChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        decoration: const BoxDecoration(
            border:
                Border(bottom: BorderSide(width: 1, color: Colors.black12))),
        child: Row(
          children: [
            Text(formatDateTime(selectedDate)),
            IconButton(
                onPressed: () => selectDate(context),
                icon: const Icon(Icons.date_range))
          ],
        ),
      ),
    );
  }
}
