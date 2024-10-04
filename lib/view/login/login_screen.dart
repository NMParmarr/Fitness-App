

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workout_fitness/common/common_toast.dart';
import 'package:workout_fitness/common/loader.dart';
import 'package:workout_fitness/common/string_validating_extension.dart';
import 'package:workout_fitness/common_widget/round_button.dart';
import 'package:workout_fitness/view/login/on_boarding_view.dart';
import 'package:workout_fitness/viewmodel/home_viewmodel.dart';

import '../../common/color_extension.dart';
import '../../common/custom_text_field.dart';
import '../menu/menu_view.dart';

class LoginScreen extends StatefulWidget {
  final DateTime? birthDate;
  final String? height;
  final String? weight;
  final String? gender;

  const LoginScreen({super.key, this.birthDate, this.height, this.weight, this.gender});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCtr = TextEditingController();
  final passCtr = TextEditingController();
  final cpassCtr = TextEditingController();

  bool isLogin = true;
  bool isPassV = false;
  bool isCPassV = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final sp = await SharedPreferences.getInstance();
      sp.setBool("isFirst", false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        elevation: 1,
        title: Text(
          isLogin ? "Login" : "Register",
          style: TextStyle(color: TColor.primary, fontSize: 24, fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: AnimatedSize(
            duration: Duration(milliseconds: 300),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                CustomTextField(ctr: emailCtr, hintText: "Email"),
                SizedBox(height: 20),
                CustomTextField(
                  ctr: passCtr,
                  hintText: "Password",
                  obsecuredText: !isPassV,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isPassV = !isPassV;
                      });
                    },
                    icon: Icon(isPassV ? Icons.visibility_off : Icons.visibility),
                  ),
                ),
                SizedBox(height: 20),
                if (!isLogin)
                  CustomTextField(
                    ctr: cpassCtr,
                    hintText: "Confirm Password",
                    obsecuredText: !isCPassV,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isCPassV = !isCPassV;
                        });
                      },
                      icon: Icon(isCPassV ? Icons.visibility_off : Icons.visibility),
                    ),
                  ),
                if (!isLogin) SizedBox(height: 20),
                SizedBox(height: 40),
                ((widget.birthDate == null || widget.gender == null || widget.weight == null || widget.height == null))
                    ? InkWell(
                        onTap: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const OnBoardingView()), (route) => false),
                        borderRadius: BorderRadius.circular(10),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Register New Account", style: TextStyle(color: TColor.primary)),
                        ),
                      )
                    : (isLogin)
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Don't have an accout ? "),
                              InkWell(
                                onTap: () => setState(() => isLogin = false),
                                borderRadius: BorderRadius.circular(10),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Register", style: TextStyle(color: TColor.primary)),
                                ),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Already have an accout ? "),
                              InkWell(
                                onTap: () => setState(() => isLogin = true),
                                borderRadius: BorderRadius.circular(10),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Login", style: TextStyle(color: TColor.primary)),
                                ),
                              ),
                            ],
                          ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Container(
        margin: const EdgeInsets.all(8.0),
        height: 40,
        child: RoundButton(
          onPressed: () async {
            final email = emailCtr.text.trim();
            final pass = passCtr.text.trim();
            final cpass = cpassCtr.text.trim();
            if (email == "") {
              showSnackbar("Please enter email");
              return;
            }

            if (!email.isValidEmail) {
              showSnackbar("Please enter valid email");
              return;
            }

            if (pass == "") {
              showSnackbar("Please enter password");
              return;
            }

            if(pass.length < 8) {
              showSnackbar("Password should be at least 8 characters");
              return;

            }

            if (cpass == "" && !isLogin) {
              showSnackbar("Please enter confirm password");
              return;
            }

            if (pass != cpass && !isLogin) {
              showSnackbar("Passwords are mismatched");
              return;
            }

            bool success = false;
            if (isLogin) {
              String? docId = null;
              try {
                showLoader(context);
                final res = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: pass);
                docId = res.user?.uid;
                success = true;
              } catch (e) {
                print("error in login : $e");
              }
              hideLoader();
              if (success) {
                showSnackbar("Login successfully");
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MenuView()), (route) => false);
              }
            } else {
              ///
              String? docId = null;
              try {
                showLoader(context);
                final res = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: pass);
                docId = res.user?.uid;
                success = true;
              } catch (e) {}
              hideLoader();
              if (success) {
                showLoader(context);
                try {
                  if(docId != null) {
                    await FirebaseFirestore.instance.collection("users").doc(docId).set({
                      'id' : docId,
                      'email' : email,
                      'password' : pass,
                      'height' : widget.height,
                      'weight' : widget.weight,
                      'birthdate' : widget.birthDate?.toIso8601String(),
                    });
                  }
                } catch(e) {}
                hideLoader();
                showSnackbar("Registered successfully");
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MenuView()), (route) => false);
              }
            }
          },
          // icon: Icon(Icons.login),
          title: isLogin ? "Login" : "Register",
        ),
      ),
    );
  }
}
