import 'package:fp_golekost/model/admin_model.dart';
import 'package:fp_golekost/model/resident_model.dart';

import 'package:flutter/material.dart';
import 'package:fp_golekost/services/admin_service.dart';
import 'package:fp_golekost/services/resident_service.dart';
import '../Animation/FadeAnimation.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';


class SignupPage extends StatefulWidget {
  @override

    List<DropdownMenuItem<int>> get roleList {
      List<DropdownMenuItem<int>> menuItems = [
        DropdownMenuItem(child: Text("Penghuni Kost"), value: 0),
        DropdownMenuItem(child: Text("Pemilik Kost"), value: 1),
      ];
      return menuItems;
    }


  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final String _placeholderPhoto = "placeholder_folder/placeholder.jpg";
  int? selectedRole = 0;
  // text editing controllers
  final emailController = TextEditingController();
  final namaController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  Future<void> signUserUp() async {
    // Loading Indicator

    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    //TODO : Implementasi sanitazion dan validation pakai package khusus (sanitizationChain & validationChain)
    // If password confirmation failed
    if (passwordController.text != passwordConfirmController.text) {
      Navigator.pop(context);
      genericErrorMessage("Confirmation didn't match the password!");
    }
    else if (namaController.text == ""){
      Navigator.pop(context);
      genericErrorMessage("Please fill the name field!");
    }

    else {
      // Sign in validation
      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        // Pop loading indicator if success
        Navigator.pop(context);
        // If sign up succeed, create new user entry
        if(selectedRole == 0){
          ResidentModel newUser = ResidentModel(emailController.text, namaController.text,  "Isi nomor HP", DateTime(1900).toString(), selectedRole ?? 0, _placeholderPhoto, "");

          ResidentService().addUser(newUser);
        }
        else if(selectedRole == 1){
          AdminModel newUser = AdminModel(emailController.text, namaController.text,  "Isi nomor HP", _placeholderPhoto);
          AdminService().addUser(newUser);
        }

      
      } on FirebaseAuthException catch (e) {
        // Pop loading indicator before displaying error
        Navigator.pop(context);

        switch (e.code) {
          case 'weak-password':
            genericErrorMessage("The password provided is too weak!");
          case 'email-already-in-use':
            genericErrorMessage("The account already exists for that email!");
          case 'invalid-email':
            genericErrorMessage("Invalid email!");
          default:
            print(e.code);
            genericErrorMessage("Unknown error occurred!");
        }
      }
      // If another type of error
      catch (e) {
        print(e);
      }
    }
  }

  void genericErrorMessage(String msg) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              msg,
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            child: FadeAnimation(
              0.5,
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(143, 148, 251, .2),
                      blurRadius: 20.0,
                      offset: Offset(0, 10),
                    )
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      child: Column(
                        //Email, Nama, Tanggal Lahir, Jenis Kelamin, Role, Password + Confirm
                        children: <Widget>[
                          TextField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            cursorColor:
                                Theme.of(context).colorScheme.onPrimary,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Email",
                              hintStyle: TextStyle(color: Colors.grey[400]),
                            ),
                          ),
                          TextField(
                            controller: namaController,
                              keyboardType: TextInputType.name,
                            cursorColor:
                                Theme.of(context).colorScheme.onPrimary,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Nama Lengkap",
                              hintStyle: TextStyle(color: Colors.grey[400]),
                            ),
                          ),

                          Container(
                            width: double.maxFinite,
                            child: DropdownButtonFormField(
                              autovalidateMode: AutovalidateMode.always,
                              dropdownColor: Colors.white,
                              style: TextStyle(color: Colors.black),
                              hint: const Text("Apakah anda penghuni atau pemilik kost?"),
                              items: widget.roleList,
                              onChanged: (int? value) {
                                selectedRole = value;
                                setState(() {});
                              },
                              value: 0,
                              validator: (int? value) {
                                return value == null
                                    ? "Pilih role"
                                    : null;
                              },
                            ),
                          ),
                          TextField(
                            controller: passwordController,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            cursorColor:
                                Theme.of(context).colorScheme.onPrimary,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Password",
                              hintStyle: TextStyle(color: Colors.grey[400]),
                            ),
                          ),
                          TextField(
                            controller: passwordConfirmController,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            cursorColor:
                                Theme.of(context).colorScheme.onPrimary,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Confirm Password",
                              hintStyle: TextStyle(color: Colors.grey[400]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          FadeAnimation(
            0.5,
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(143, 148, 251, 1),
                    Color.fromRGBO(143, 148, 251, .6),
                  ],
                ),
                borderRadius: BorderRadius.circular(100.0),
              ),
              height: 50,
              width: 100,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent),
                onPressed: () {signUserUp();},
                child: Center(
                  child: Text(
                    "SignUp",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
