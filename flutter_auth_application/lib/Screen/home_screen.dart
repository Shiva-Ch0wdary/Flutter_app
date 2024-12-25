import 'package:flutter/material.dart';
import '../Services/authentication.dart';
import '../Widget/button.dart';
import '../Widget/snackbar.dart';
import 'login.dart';
import 'signup.dart';
import 'ModifyUserDetails.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? userName;

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  // Fetch user name from Firebase
  void fetchUserName() async {
    String? name = await AuthMethod().getUserName();
    setState(() {
      userName = name ?? "User";
    });
  }

  // Refresh username after returning from ModifyUserDetailsScreen
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchUserName();
  }

  // Delete account and navigate to signup screen
  void deleteAccount() async {
    String res = await AuthMethod().deleteUserAccount();
    if (res == "success") {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const SignupScreen(),
        ),
      );
    } else {
      showSnackBar(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define height inside the build method
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add the image at the top
            SizedBox(
              height: height / 2.7,
              child: Image.asset(
                  'images/sunyalogo.png'), // Change the path if needed
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome, ${userName ?? 'User'}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    MyButtons(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      text: "Log Out",
                    ),
                    const SizedBox(height: 10),
                    MyButtons(
                      onTap: deleteAccount,
                      text: "Delete Account",
                    ),
                    const SizedBox(height: 10),
                    MyButtons(
                      onTap: () {
                        Navigator.of(context)
                            .push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ModifyUserDetailsScreen(),
                              ),
                            )
                            .then((_) =>
                                fetchUserName()); // Refresh username when returning
                      },
                      text: "Update Details",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
