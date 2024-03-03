import 'package:e_med/components/delegatedText.dart';
import 'package:e_med/utils/constant.dart';
import 'package:e_med/utils/form_validators.dart';
import 'package:flutter/material.dart';

class DropDown extends StatefulWidget {
  final List<String> dropDownName;
  final String name;
  final IconData icon;
  final TextEditingController controller;

  const DropDown({
    required this.dropDownName,
    required this.name,
    required this.icon,
    required this.controller,
    super.key,
  });

  @override
  State<DropDown> createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  String? dropDownValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Row(
            children: [
              Icon(widget.icon),
              const SizedBox(width: 15),
              DelegatedText(
                text: widget.name,
                fontSize: 15,
                fontName: 'InterMed',
              ),
              const Spacer(),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 12),
          child: DropdownButtonFormField<String>(
            validator: FormValidator.validateField,
            decoration: const InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Constants.darkColor, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1.0,
                  color: Constants.darkColor,
                ),
              ),
            ),
            value: dropDownValue,
            hint: const Text('Select'),
            onChanged: (String? newValue) {
              setState(() {
                dropDownValue = newValue!;
                widget.controller.text = newValue;
              });
            },
            items: widget.dropDownName
                .map(
                  (e) => DropdownMenuItem<String>(
                    value: e,
                    child: Text(e),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
