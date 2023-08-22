import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  TextEditingController controllers;
  FormFieldValidator<String>? validator;
  String labelText;

  CustomTextField({  required this.labelText, required this.controllers,this.validator});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: TextFormField(
        controller: controllers,
        validator: validator,
        // controller: customerName.text=i.customerName==null?'':i.customerName,
      autovalidateMode: AutovalidateMode.always,
        style: TextStyle(),
        decoration: InputDecoration(labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(10.0),
            ),
          ),
          filled: true,
        ),

      ),
    );
  }
}
