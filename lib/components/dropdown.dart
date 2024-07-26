import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatefulWidget {
  final List<T> data;
  final String hint;
  final Function(T? value) onChanged;
  const CustomDropdown(
      {super.key,
      required this.data,
      required this.hint,
      required this.onChanged});

  @override
  State<CustomDropdown<T>> createState() => CustomDropdownState<T>();
}

class CustomDropdownState<T> extends State<CustomDropdown<T>> {
  T? dropdownValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<T>(
      hint: Text(widget.hint),
      value: dropdownValue,
      onChanged: (T? value) {
        setState(() {
          dropdownValue = value;
        });
        widget.onChanged(value);
      },
      items: widget.data.map<DropdownMenuItem<T>>((T value) {
        return DropdownMenuItem<T>(
          value: value,
          child: Text(value.toString()),
        );
      }).toList(),
    );
  }
}
