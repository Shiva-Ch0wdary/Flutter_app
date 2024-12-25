import 'package:flutter/material.dart';
import '../Services/authentication.dart';
import '../Widget/button.dart';
import '../Widget/snackbar.dart';

class ModifyUserDetailsScreen extends StatefulWidget {
  const ModifyUserDetailsScreen({super.key});

  @override
  State<ModifyUserDetailsScreen> createState() => _ModifyUserDetailsScreenState();
}

class _ModifyUserDetailsScreenState extends State<ModifyUserDetailsScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCurrentUserName();
  }

  // Fetch the current username to populate the text field
  void fetchCurrentUserName() async {
    String? name = await AuthMethod().getUserName();
    setState(() {
      _nameController.text = name ?? "";
    });
  }

  // Save the updated username
  void saveDetails() async {
    String newName = _nameController.text.trim();
    if (newName.isNotEmpty) {
      String res = await AuthMethod().updateUserName(newName);
      if (res == "success") {
        Navigator.of(context).pop();
        showSnackBar(context, "Details updated successfully!");
      } else {
        showSnackBar(context, res);
      }
    } else {
      showSnackBar(context, "Name cannot be empty!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Modify User Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Modify User Details",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            MyButtons(
              onTap: saveDetails,
              text: "Save",
            ),
          ],
        ),
      ),
    );
  }
}
