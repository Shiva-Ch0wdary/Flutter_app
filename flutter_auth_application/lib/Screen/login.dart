import 'package:flutter/material.dart';
import '../Services/authentication.dart';
import '../Widget/button.dart';
import '../Widget/inline_error.dart';
import '../Widget/show_top_popup.dart';
import '../Widget/text_field.dart';
import 'home_screen.dart';
import 'signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  // Error messages for inline display
  String? emailError;
  String? passwordError;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      emailError = null;
      passwordError = null;
    });

    // Basic validation
    if (!emailController.text.contains('@')) {
      setState(() {
        emailError = "Please enter a valid email address.";
      });
      return;
    }

    if (passwordController.text.isEmpty) {
      setState(() {
        passwordError = "Password cannot be empty.";
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    // Log in the user
    String res = await AuthMethod().loginUser(
      email: emailController.text,
      password: passwordController.text,
    );

    setState(() {
      isLoading = false;
    });

    // Show popup based on response
    if (res == "success") {
      showTopPopup(context, "Login successful!",
          isError: false); // Success popup
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      showTopPopup(context, res, isError: true); // Error popup
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: height / 2.7,
                child: Image.asset('images/login.png'),
              ),
              TextFieldInput(
                icon: Icons.email,
                textEditingController: emailController,
                hintText: 'Enter your email',
                textInputType: TextInputType.emailAddress,
              ),
              InlineError(errorText: emailError), // Inline error for email

              TextFieldInput(
                icon: Icons.lock,
                textEditingController: passwordController,
                hintText: 'Enter your password',
                textInputType: TextInputType.text,
                isPass: true,
              ),
              InlineError(
                  errorText: passwordError), // Inline error for password

              MyButtons(
                onTap: loginUser,
                text: isLoading ? "Logging In..." : "Log In",
              ),

              Row(
                children: [
                  Expanded(child: Container(height: 1, color: Colors.black26)),
                  const Text("  or  "),
                  Expanded(child: Container(height: 1, color: Colors.black26)),
                ],
              ),

              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const SignupScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
