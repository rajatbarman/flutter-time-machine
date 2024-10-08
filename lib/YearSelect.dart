import 'package:flutter/material.dart';

class YearDropdown extends StatefulWidget {
  final int selectedYear;
  final ValueChanged<int> onYearChange;
  const YearDropdown(
      {super.key, required this.selectedYear, required this.onYearChange});

  @override
  _YearDropdownState createState() => _YearDropdownState();
}

class _YearDropdownState extends State<YearDropdown> {
  final List<int> years =
      List.generate(2024 - 1998 + 1, (index) => 1998 + index);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 108, // Enforcing the height of the parent container
        padding: EdgeInsets.symmetric(vertical: 8),
        alignment: Alignment.center,
        child: DropdownButton<int>(
            itemHeight: 100.0,
            value: widget.selectedYear,
            iconEnabledColor: Colors.white,
            hint: Text('Select Year'),
            items: years.map((year) {
              return DropdownMenuItem<int>(
                  value: year,
                  child: Container(
                      alignment: Alignment.center,
                      child: Text(year.toString(),
                          style: TextStyle(
                            fontSize: 24, // Increase font size if selected
                            color: Colors.black, // Change color if selected
                          ))));
            }).toList(),
            onChanged: (newValue) {
              if (newValue != null) {
                widget.onYearChange(newValue);
              }
            },
            underline: SizedBox(), // Removes the underline from the dropdown
            // dropdownColor: Colors.blue, // Sets the dropdown background color
            selectedItemBuilder: (BuildContext context) {
              // Ensures the selected item displays with the same height as the parent container
              return years.map((year) {
                return Container(
                  alignment: Alignment.center,
                  child: Text(
                    year.toString(),
                    style: TextStyle(
                      fontSize: 64, // Larger font size for the selected item
                      color:
                          Colors.white70, // White color for the selected item
                    ),
                  ),
                );
              }).toList();
            }));
  }
}
