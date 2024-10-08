import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WebAddressInput extends StatefulWidget {
  final ValueChanged<String> onValueChange;
  final String? inputError;
  const WebAddressInput(
      {required this.onValueChange, this.inputError, Key? key})
      : super(key: key);

  @override
  _WebAddressInputState createState() => _WebAddressInputState();
}

class _WebAddressInputState extends State<WebAddressInput> {
  final TextEditingController _controller = TextEditingController();

  void _handleValueChange(String value) {
    widget.onValueChange(value);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 256, left: 40, right: 40),
        child: Container(
            width: double.infinity,
            child: TextField(
              controller: _controller,
              // inputFormatters: [
              //   TextInputFormatter.withFunction(
              //     (oldValue, newValue) => TextEditingValue(
              //       text: newValue.text.toLowerCase(),
              //       selection: newValue.selection,
              //     ),
              //   ),
              // ],

              style: TextStyle(
                color: Colors.white, // Set the input text color to white
              ),
              keyboardType: TextInputType
                  .url, // Ensure it uses a URL input keyboard (for mobile)
              decoration: InputDecoration(
                  hintText: "Type in the address Ex: google.com",
                  border: UnderlineInputBorder(),
                  hintStyle: TextStyle(color: Colors.white70),
                  errorStyle: TextStyle(color: Colors.red),
                  errorText: widget.inputError),
              onChanged: _handleValueChange,
            )));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
