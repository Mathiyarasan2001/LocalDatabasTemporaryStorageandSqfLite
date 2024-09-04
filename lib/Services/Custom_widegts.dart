import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Custom_container extends StatefulWidget {
  final String leading;
  final String name;
  final String number;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  Custom_container({
    super.key,
    required this.leading,
    required this.name,
    required this.number,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<Custom_container> createState() => _Custom_containerState();
}

class _Custom_containerState extends State<Custom_container> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: ListTile(
            leading: widget.leading.isNotEmpty
                ? CircleAvatar(
                    backgroundImage: FileImage(File(widget.leading)),
                  )
                : const CircleAvatar(
                    child: Icon(Icons.image),
                  ),
            title: Text(widget.name),
            subtitle: Text(widget.number),
            trailing: SizedBox(
              width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: widget.onEdit,
                    child: const Icon(
                      Icons.edit,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: widget.onDelete,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            )));
  }
}

class Custom_Name extends StatelessWidget {
  final String hinttext;
  final String print1;
  final TextEditingController controller;

  Custom_Name({
    super.key,
    required this.hinttext,
    required this.print1,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 250,
        child: TextFormField(
          controller: controller,
          keyboardType: TextInputType.name,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z]')),
          ],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter a name";
            }

            if (value.length < 3) {
              return "Please enter at least 3 characters";
            }

            return null;
          },
          decoration: InputDecoration(
            hintText: hinttext,
          ),
        ),
      ),
    );
  }
}

class Custom_Number extends StatelessWidget {
  final String hinttext;
  final String print1;
  final TextEditingController controller;

  Custom_Number({
    super.key,
    required this.hinttext,
    required this.print1,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 250,
        child: TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
          ],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter a value";
            } else if (value.length < 10) {
              return "Please enter at least 10 numbers";
            } else if (value.length > 10) {
              return "Please enter no more than 10 numbers";
            }
            final intValue = int.tryParse(value);
            if (intValue == null) {
              return "Please enter a valid number";
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: hinttext,
          ),
        ),
      ),
    );
  }
}
