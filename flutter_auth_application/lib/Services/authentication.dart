import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethod {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // SignUp User with Email Verification
  Future<String> signupUser({
    required String email,
    required String password,
    required String name,
    
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty || name.isNotEmpty) {
        // Register user in Firebase Auth
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Send email verification
        await cred.user!.sendEmailVerification();

        // Add user details to Firestore
        await _firestore.collection("users").doc(cred.user!.uid).set({
          'name': name,
          'uid': cred.user!.uid,
          'email': email,
          'emailVerified': false, // Optional: For tracking verification
        });

        res = "Please verify your email. A verification link has been sent.";
      } else {
        res = "Please fill all fields.";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // LogIn User with Email Verification Check
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        // Logging in the user
        UserCredential cred = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Check if email is verified
        if (cred.user != null && cred.user!.emailVerified) {
          res = "success";
        } else {
          res = "Please verify your email before logging in.";
          await _auth.signOut();
        }
      } else {
        res = "Please enter all fields.";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Sign Out User
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get the user's name from Firestore
  Future<String?> getUserName() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        DocumentSnapshot snap =
            await _firestore.collection("users").doc(currentUser.uid).get();
        return snap['name'];
      }
    } catch (err) {
      return null;
    }
    return null;
  }

  // Update the user's name in Firestore
  Future<String> updateUserName(String newName) async {
    String res = "Some error occurred";
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        await _firestore
            .collection("users")
            .doc(currentUser.uid)
            .update({"name": newName});
        res = "success";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Delete user account
  Future<String> deleteUserAccount() async {
    String res = "Some error occurred";
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        // Delete user from Firestore
        await _firestore.collection("users").doc(currentUser.uid).delete();
        // Delete user from Firebase Authentication
        await currentUser.delete();
        res = "success";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
