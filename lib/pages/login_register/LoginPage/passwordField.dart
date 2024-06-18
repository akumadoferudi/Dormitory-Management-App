import 'package:flutter/material.dart';
import 'package:fp_golekost/pages/login_register/Animation/FadeAnimation.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController passwordController;

  const PasswordField({super.key, required this.passwordController});
  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _ishidden = true;


  void _toggleVisibility() {
    setState(() {
        _ishidden = !_ishidden;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeAnimation(
      0.5,
      TextField(
        controller: widget.passwordController,
        obscureText: _ishidden ? true : false,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(_ishidden ? Icons.visibility_off : Icons.visibility),
            onPressed: _toggleVisibility,
          ),
          border: InputBorder.none,
          hintText: "Password",
          hintStyle: TextStyle(
            color: Colors.grey[400],
          ),
        ),
      ),
    );
  }
}
