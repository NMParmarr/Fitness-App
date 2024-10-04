import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workout_fitness/common/color_extension.dart';
import 'package:workout_fitness/common/color_extension.dart';
import 'package:workout_fitness/view/login/login_screen.dart';
import 'package:workout_fitness/view/login/on_boarding_view.dart';
import 'package:workout_fitness/view/menu/menu_view.dart';

class DecidePage extends StatelessWidget {
  const DecidePage({super.key});

  // pls make statefull widget first than apply this function (revoke/recall)----

  // getUid(){               <---------------------------------------------------
  //     String uid = SharedPreferences.getUid();
  //     if (uid.isEmpty){
  //         DecidePage.authStream.add("");
  //     }else{
  //         DecidePage.authStream.add(uid);
  //     }
  // }

  Future<bool?> isFirst() async {
    final sp = await SharedPreferences.getInstance();
    final res = await sp.getBool("isFirst");
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
                backgroundColor: Colors.white,
                body: Center(child: CircularProgressIndicator(color: TColor.primary)));
          }
          if (snapshot.data == null) {
            return FutureBuilder<bool?>(
                future: isFirst(),
                builder: (context, s) {
                  if (s.connectionState == ConnectionState.waiting) {
                    return Scaffold(
                        backgroundColor: Colors.white,
                        body: Center(child: CircularProgressIndicator(color: TColor.primary)));
                  }
                  if (s.hasData) {
                    print("data : ${s.data}");
                    if(!(s.data ?? true)) {
                      return LoginScreen();
                    }
                  }
                  return OnBoardingView();
                });
          } else{
            return MenuView();
                }
            }
        );
    }
}