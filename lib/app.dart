import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:workout_fitness/view/login/on_boarding_view.dart';
import 'package:workout_fitness/view/menu/menu_view.dart';

class DecidePage extends StatelessWidget{
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

    @override
    Widget build(BuildContext context){
        return FutureBuilder<UserCredential>(
            future: FirebaseAuth.instance.getRedirectResult(),
            builder:(context, snapshot){
              if(snapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(body: Center(child: CircularProgressIndicator()));
              }
                if (snapshot.data == null){
                    return OnBoardingView();
                }
                else{
                  if(snapshot.data!.user == null) {
                    return MenuView();
                  }
                    return MenuView();
                }
            }
        );
    }
}