
import 'package:arefapp/Screens/loginscreen.dart';
import 'package:arefapp/Screens/signupscreen.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  @override
  Widget build(BuildContext context) => isLogin
      ? LoginWidget(onClickSignUp: toggle)
      : SignUpWidget(onClickSignIn: toggle);
  void toggle() => setState(() => isLogin = !isLogin);
}
