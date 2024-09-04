import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Services/Custom_widegts.dart';
import '../Services/sqfLiteHelper.dart';

class sqfLite extends StatefulWidget {
  const sqfLite({super.key});
  @override
  State<sqfLite> createState() => _sqfLiteState();
}

class _sqfLiteState extends State<sqfLite> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  List<Map<String, dynamic>> journals = [];
  bool isLoading = true;
  File? _image;
  @override
  void initState() {
    super.initState();
    refreshJournals();
  }

  void refreshJournals() async {
    final data = await SqfliteHelper.getItems();
    setState(() {
      journals = data;
      isLoading = false;
    });
  }

  Future<void> update(int id) async {
    print('Updating item with ID: $id');
    print(
        'New Name: ${nameController.text}, New Number: ${numberController.text}, Image Path: ${_image?.path}');

    await SqfliteHelper.updateItem(
        id, nameController.text, numberController.text, _image?.path);
    print('Update complete');
    refreshJournals();
  }

  Future<void> delete(int id) async {
    await SqfliteHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Successfully Deleted")),
    );
    refreshJournals();
  }

  Future<void> addItem(String name, String number, String? imagePath) async {
    await SqfliteHelper.createItems(name, number, imagePath);
    refreshJournals();
  }

  void showForm(int? id) async {
    if (id != null) {
      final existingData =
          journals.firstWhere((element) => element["id"] == id);
      nameController.text = existingData["name"];
      numberController.text = existingData["number"];
      _image = existingData["imagePath"] != null
          ? File(existingData["imagePath"])
          : null;
    } else {
      nameController.clear();
      numberController.clear();
      _image = null;
    }

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        _showImageSourceDialog(context);
                      });
                    },
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          _image != null ? FileImage(_image!) : null,
                      child: _image == null
                          ? const Icon(
                              Icons.add,
                              size: 50,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Custom_Name(
                    controller: nameController,
                    hinttext: "Name",
                    print1: "Please Fill your Name",
                  ),
                  const SizedBox(height: 20),
                  Custom_Number(
                    controller: numberController,
                    hinttext: "Mobile Number",
                    print1: "Please Fill your Mobile Number",
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }
                      _formKey.currentState!.save();

                      final imagePath = _image?.path;

                      if (id == null) {
                        await addItem(nameController.text,
                            numberController.text, imagePath);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Added Successfully")),
                        );
                      } else {
                        await update(id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Updated Successfully")),
                        );
                      }

                      Navigator.pop(context);
                    },
                    child: Text(id == null ? "Add New" : "Update"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showImageSourceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: SizedBox(
            height: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  child: const Icon(
                    Icons.camera_alt,
                    size: 50,
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    final pickedFile = await ImagePicker().pickImage(
                      source: ImageSource.camera,
                    );
                    if (pickedFile != null) {
                      setState(() {
                        _image = File(pickedFile.path);
                      });
                    }
                  },
                ),
                InkWell(
                  onTap: () async {
                    Navigator.pop(context);
                    final pickedFile = await ImagePicker().pickImage(
                      source: ImageSource.gallery,
                    );
                    if (pickedFile != null) {
                      setState(() {
                        _image = File(pickedFile.path);
                      });
                    }
                  },
                  child: const Icon(
                    Icons.photo,
                    size: 50,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.white,
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onPressed: () => showForm(null),
        icon: const Icon(
          Icons.add,
          color: Colors.black,
        ),
        label: const Text(
          "Add New",
          style: TextStyle(color: Colors.black),
        ),
      ),
      appBar: AppBar(
        title: const Text("TODO LIST"),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: journals.length,
              itemBuilder: (context, index) {
                final item = journals[index];
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Custom_container(
                      leading: item["imagePath"].toString(),
                      name: item["name"].toString(),
                      number: item["number"].toString(),
                      onEdit: () => showForm(item["id"]),
                      onDelete: () => delete(item["id"])),
                );
              },
            ),
    );
  }
}
