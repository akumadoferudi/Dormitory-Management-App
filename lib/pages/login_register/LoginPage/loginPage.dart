import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fp_golekost/components/navigation/nav_drawer.dart';
import 'package:fp_golekost/pages/login_register/LoginPage/passwordField.dart';
import 'package:fp_golekost/services/admin_service.dart';
import 'package:fp_golekost/services/resident_service.dart';
import 'package:fp_golekost/services/validationService.dart';
import './verificationFields.dart';
import './loginButton.dart';
import './signupPage.dart';
import './loginDecoration.dart';
import '../Animation/FadeAnimation.dart';


class LoginPage extends StatefulWidget {


  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _residentLogin = true; // To set which collection to check if a valid account exists or not
  bool _pageLogin = true;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // bool _rememberPassword = false;

  void _togglePage(bool _switchme) {
    setState(
      () {
        _pageLogin = _switchme;
      },
    );
  }
  void _toggleRole(bool _switchme) {
    setState(
          () {
        _residentLogin = _switchme;
      },
    );
  }

  // sign user in method
  Future<void> signUserIn() async {
    // Loading Indicator
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    // TODO : No delay means attacker knows this isn't from firebase
    // Field validation
    if(!ValidationService().isEmail(emailController.text)){
      Navigator.pop(context);
      genericErrorMessage("Invalid email or password!");
      return;
    }
    // Account existance validation
    if(_residentLogin){
      ResidentService rService = ResidentService();
      if(!await rService.exists(emailController.text)){
        Navigator.pop(context);

        genericErrorMessage("Invalid email or password!");
        return;
      }
    }
    else{
      AdminService aService = AdminService();
      if(! await aService.exists(emailController.text)){
        Navigator.pop(context);

        genericErrorMessage("Invalid email or password!");
        return;
      }
    }

    // Firebase Auth Validation

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password:passwordController.text,
      );
      // Pop loading indicator if success
      Navigator.pop(context);
      print("HELLO");
    } on FirebaseAuthException catch (e) {
      // Pop loading indicator before displaying error
      Navigator.pop(context);

      switch (e.code) {
        case 'user-not-found':
          genericErrorMessage("User not found!");
        case 'wrong-password':
          genericErrorMessage("Wrong password!");
        case 'invalid-credential':
          genericErrorMessage("Invalid email or password!");
        default:
          print(e.code);
          genericErrorMessage("Unknown error occured!");
      }
    }
    // If another type of error
    catch (e) {
      print(e);
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Login or Signup',
        ),
        backgroundColor: const Color(0xff764abc),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              LoginDecoration(),
              FadeAnimation(
                0.5,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: _pageLogin
                            ? Color.fromRGBO(143, 148, 251, 1)
                            : Colors.transparent,
                      ),
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: _pageLogin
                              ? Colors.white
                              : Color.fromRGBO(143, 148, 251, 1),
                        ),
                      ),
                      onPressed: () {
                        _togglePage(true);
                      },
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: !_pageLogin
                            ? Color.fromRGBO(143, 148, 251, 1)
                            : Colors.transparent,
                      ),
                      child: Text(
                        "SignUp",
                        style: TextStyle(
                          color: _pageLogin
                              ? Color.fromRGBO(143, 148, 251, 1)
                              : Colors.white,
                        ),
                      ),
                      onPressed: () {
                        _togglePage(false);
                      },
                    ),
                  ],
                ),
              ),
              _pageLogin
                  ? Padding(
                      padding: EdgeInsets.all(30.0),
                      child: Column(
                        children: <Widget>[
                          FadeAnimation(
                            0.5,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: _residentLogin
                                        ? Color.fromRGBO(143, 148, 251, 1)
                                        : Colors.transparent,
                                  ),
                                  child: Text(
                                    "Resident",
                                    style: TextStyle(
                                      color: _residentLogin
                                          ? Colors.white
                                          : Color.fromRGBO(143, 148, 251, 1),
                                    ),
                                  ),
                                  onPressed: () {
                                    _toggleRole(true);
                                  },
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: !_residentLogin
                                        ? Color.fromRGBO(143, 148, 251, 1)
                                        : Colors.transparent,
                                  ),
                                  child: Text(
                                    "Admin",
                                    style: TextStyle(
                                      color: _residentLogin
                                          ? Color.fromRGBO(143, 148, 251, 1)
                                          : Colors.white,
                                    ),
                                  ),
                                  onPressed: () {
                                    _toggleRole(false);
                                  },
                                ),
                              ],
                            ),
                          ),
                          VerificationFields(
                            emailController: emailController,
                          ),
                          Container(
                            padding: EdgeInsets.all(8.0),
                            child: PasswordField(
                              passwordController: passwordController,
                            ),
                          ),
                          /* Remember Password */
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.end,
                          //   children: <Widget>[
                          //     Text("Remember Password?"),
                          //     Checkbox(
                          //       value: _rememberPassword ? true : false,
                          //       onChanged: (bool _newValue) {
                          //         setState(() {
                          //             _rememberPassword = _newValue;
                          //           },
                          //         );
                          //       },
                          //     ),
                          //   ],
                          // ),
                          FadeAnimation(
                            0.5,
                            Container(
                              alignment: AlignmentDirectional(1.0, 0.0),
                              child: TextButton(
                                  child: Text(
                                    "Forgot Password?",
                                    style: TextStyle(
                                      color: Color.fromRGBO(143, 148, 251, 1),
                                    ),
                                  ),
                                  onPressed: () => {} //TODO : RESET PASSWORD,
                                  ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
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
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              height: 50,
                              width: 100,
                              child: Padding(
                                padding: const EdgeInsets.all(0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent),
                                  onPressed: () {
                                    signUserIn();
                                  },
                                  child: Center(
                                    child: Text(
                                      "Login",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                          // FadeAnimation(
                          //   0.5,
                          //   Row(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     children: <Widget>[
                          //       Text(
                          //         "New User?",
                          //       ),
                          //       FlatButton(
                          //         highlightColor: Colors.transparent,
                          //         splashColor: Colors.transparent,
                          //         child: Text(
                          //           "Sign Up",
                          //           style: TextStyle(
                          //             color: Color.fromRGBO(143, 148, 251, 1),
                          //           ),
                          //         ),
                          //         onPressed: () => {},
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    )
                  : SignupPage()
            ],
          ),
        ),
      ),
    );
  }
}
