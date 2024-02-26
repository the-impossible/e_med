import 'package:e_med/components/delegatedText.dart';
import 'package:flutter/material.dart';
import '../utils/constant.dart';

class delegatedForm extends StatefulWidget {
  final String fieldName;
  final IconData icon;
  final String hintText;
  final bool isSecured;
  final TextEditingController? formController;
  final String? Function(String?)? validator;

  const delegatedForm({
    required this.fieldName,
    required this.icon,
    required this.hintText,
    required this.isSecured,
    this.formController,
    this.validator,
    Key? key,
  }) : super(key: key);

  @override
  State<delegatedForm> createState() => _delegatedFormState();
}

class _delegatedFormState extends State<delegatedForm> {
  @override
  Widget build(BuildContext context) {
    String? errorText;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Row(
            children: [
              Icon(widget.icon),
              const SizedBox(width: 15),
              DelegatedText(
                text: widget.fieldName,
                fontSize: 15,
                fontName: 'InterMed',
              ),
              const Spacer(),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 12),
          child: TextFormField(
            obscureText: widget.isSecured,
            validator: widget.validator,
            controller: widget.formController,
            style: const TextStyle(
              fontSize: 15,
            ),
            decoration: InputDecoration(
              errorText: errorText,
              filled: true,
              fillColor: Constants.basicColor,
              hintText: widget.hintText,
              border: const OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2.0,
                  color: Constants.basicColor,
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1.0,
                  color: Constants.primaryColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
