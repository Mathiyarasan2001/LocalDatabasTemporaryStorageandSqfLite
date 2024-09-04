import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:testtask1/Services/Custom_widegts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  List<DataItem> allData = [];
  File? _selectedImageFile;
  int? _editIndex;

  Future<void> _pickImage(ImageSource source, Function setState) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _selectedImageFile = File(pickedFile.path);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No image selected")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to pick image: $e")),
      );
    }
  }

  void addOrUpdateItem() {
    if (_formKey.currentState!.validate()) {
      final name = nameController.text;
      final number = numberController.text;
      if (_selectedImageFile != null) {
        final imagePath = _selectedImageFile!.path;
        setState(() {
          if (_editIndex != null) {
            allData[_editIndex!] = DataItem(
              name: name,
              number: number,
              imagePath: imagePath,
            );

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("List update successfully")),
            );

            _editIndex = null;
          } else {
            allData.add(DataItem(
              name: name,
              number: number,
              imagePath: imagePath,
            ));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("List saved successfully")),
            );
          }
          nameController.clear();
          numberController.clear();
          _selectedImageFile = null;
        });
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select an image")),
        );
      }
    }
  }

  void deleteItem(int index) {
    setState(() {
      allData.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("List deleted successfully")),
    );
  }

  void editItem(int index) {
    setState(() {
      nameController.text = allData[index].name;
      numberController.text = allData[index].number;
      _selectedImageFile = File(allData[index].imagePath);
      _editIndex = index;
    });
    _showFormDialog();
  }

  void _showFormDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                child: SizedBox(
                                  height: 120,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      InkWell(
                                        child: const Icon(
                                          Icons.camera_alt,
                                          size: 40,
                                        ),
                                        onTap: () async {
                                          Navigator.pop(context);
                                          await _pickImage(
                                              ImageSource.camera, setState);
                                        },
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          Navigator.pop(context);
                                          await _pickImage(
                                              ImageSource.gallery, setState);
                                        },
                                        child: const Icon(
                                          Icons.photo,
                                          size: 40,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage: _selectedImageFile != null
                              ? FileImage(_selectedImageFile!)
                              : null,
                          child: _selectedImageFile == null
                              ? const Icon(Icons.add, size: 40)
                              : null,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Custom_Name(
                        controller: nameController,
                        hinttext: "Name",
                        print1: "Please Fill your Name",
                      ),
                      const SizedBox(height: 10),
                      Custom_Number(
                        controller: numberController,
                        hinttext: "Mobile Number",
                        print1: "Please Fill your Mobile Number",
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: addOrUpdateItem,
                        child: Text(_editIndex != null ? "Update" : "Add"),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
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
        onPressed: _showFormDialog,
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
      body: ListView.builder(
        itemCount: allData.length,
        itemBuilder: (context, index) {
          return Padding(
              padding: const EdgeInsets.all(10),
              child: Custom_container(
                leading: allData[index].imagePath,
                name: allData[index].name,
                number: allData[index].number,
                onEdit: () => editItem(index),
                onDelete: () => deleteItem(index),
              ));
        },
      ),
    );
  }
}

class DataItem {
  final String name;
  final String number;
  final String imagePath;

  DataItem({
    required this.name,
    required this.number,
    required this.imagePath,
  });
}
