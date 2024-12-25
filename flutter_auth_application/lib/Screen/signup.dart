import 'package:flutter/material.dart';
import '../Services/authentication.dart';
import '../Widget/button.dart';
import '../Widget/inline_error.dart';
import '../Widget/show_top_popup.dart';
import '../Widget/text_field.dart';
import 'login.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isLoading = false;

  String? emailError;
  String? passwordError;
  String? confirmPasswordError;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
  }

  String? validatePassword(String password) {
    if (password.length < 6) {
      return "Password must be at least 6 characters long.";
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return "Password must contain at least one uppercase letter.";
    }
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return "Password must contain at least one number.";
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      return "Password must contain at least one special character.";
    }
    return null;
  }

  void signupUser() async {
    setState(() {
      emailError = null;
      passwordError = null;
      confirmPasswordError = null;
    });

    if (!emailController.text.contains('@')) {
      setState(() {
        emailError = "Please enter a valid email address.";
      });
      return;
    }

    String? passwordValidation = validatePassword(passwordController.text);
    if (passwordValidation != null) {
      setState(() {
        passwordError = passwordValidation;
      });
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      setState(() {
        confirmPasswordError = "Passwords do not match.";
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    // Signup user using AuthMethod
    String res = await AuthMethod().signupUser(
      email: emailController.text,
      password: passwordController.text,
      name: nameController.text,
    );

    setState(() {
      isLoading = false;
    });

    if (res.contains("verify your email")) {
      showTopPopup(context, res, isError: false);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      showTopPopup(context, res, isError: true);
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
                height: height / 3,
                child: Image.asset('images/signup1.png'),
              ),
              TextFieldInput(
                icon: Icons.person,
                textEditingController: nameController,
                hintText: 'Enter your name',
                textInputType: TextInputType.text,
              ),
              TextFieldInput(
                icon: Icons.email,
                textEditingController: emailController,
                hintText: 'Enter your email',
                textInputType: TextInputType.emailAddress,
              ),
              InlineError(errorText: emailError),
              TextFieldInput(
                icon: Icons.lock,
                textEditingController: passwordController,
                hintText: 'Enter your password',
                textInputType: TextInputType.text,
                isPass: true,
              ),
              InlineError(errorText: passwordError),
              TextFieldInput(
                icon: Icons.lock,
                textEditingController: confirmPasswordController,
                hintText: 'Confirm your password',
                textInputType: TextInputType.text,
                isPass: true,
              ),
              InlineError(errorText: confirmPasswordError),
              MyButtons(
                onTap: signupUser,
                text: isLoading ? "Signing Up..." : "Sign Up",
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      " Login",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
