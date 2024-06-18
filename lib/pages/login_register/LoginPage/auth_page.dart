import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fp_golekost/pages/login_register/LoginPage/loginPage.dart';
import 'package:fp_golekost/pages/profile/ProfilePage.dart';
import 'package:fp_golekost/services/admin_service.dart';
import 'package:fp_golekost/services/resident_service.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});
// Roundabout way to use async function in the main streambuilder : https://stackoverflow.com/questions/63535014/how-to-use-a-future-in-a-streambuilder-in-flutter
  Stream<int> getRole (String email) async* {

    if(await ResidentService().exists(email ?? "test@test.com")){
      yield 0;
    }
    else if(await AdminService().exists(email ?? "test2@test.com")){
      yield 1;
    }
    else{
      yield -1;
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user is logged in
          if (snapshot.hasData) {
            //Check ONCE AFTER LOGIN if user is admin or resident by querying data from both collection. Assuming a unique email only exists on 1 collection at a time.
            //If null is done to avoid error. Since it's nested inside "hasData", shouldn't get triggered.
            return StreamBuilder<int?>(
              stream: getRole(snapshot.data?.email ?? "test@test.com"),
              builder: (context, snapshot){
                if(snapshot.data == 0){
                return ProfilePage(isResident: true,);
                }
                else if(snapshot.data == 1){
                return ProfilePage(isResident: false,);
                }
                else{
                  //Add loading widget
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
            );
          }

          // user is NOT logged in
          else {
            return LoginPage();
          }
        },
      ),
    );
  }
}