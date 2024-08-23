import 'package:arefapp/Screens/forgot_password.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginWidget extends StatefulWidget {
  final VoidCallback onClickSignUp;
  const LoginWidget({
    Key? key,
    required this.onClickSignUp,
  }) : super(key: key);

  @override
  State<LoginWidget> createState() => __LongWidgetState();
}

class __LongWidgetState extends State<LoginWidget> {
  final formKey = GlobalKey<FormState>();
  final emailCont = TextEditingController();
  final passwordCont = TextEditingController();

  //
  Future signIn() async {
    // final isValid = formKey.currentState!.validate();
    // if (!isValid) return;

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailCont.text.trim(), password: passwordCont.text.trim());
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Directionality(
            textDirection: TextDirection.rtl,
            child: Text(" يوجد خطأ في البريد الإلكتروني أو كلمة المرور ",
                style: TextStyle(color: Colors.white, fontFamily: "thin"))),
        backgroundColor: Color.fromARGB(255, 100, 27, 21),
      ));
    }
  }

  void dispose() {
    passwordCont.dispose();
    emailCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            backgroundColor: Colors.grey[50],
            body: SafeArea(
              child: Center(
                  child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 32),
                      Text("تسجيل الدخول",
                          style: TextStyle(fontFamily: "blod", fontSize: 38)),
                      SizedBox(height: 42),
                      Padding(
                        padding:
                            EdgeInsets.only(left: 20, right: 20, bottom: 15),
                        child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextFormField(
                              controller: emailCont,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (email) => email != null &&
                                      !EmailValidator.validate(email)
                                  ? "البريد الإلكتروني ليس صالح"
                                  : null,
                              cursorColor: Colors.purple,
                              style: TextStyle(fontFamily: "mid"),
                              decoration: InputDecoration(
                                filled: true,
                                hintText: "",
                                labelText: 'البريد الإلكتروني',
                                labelStyle: TextStyle(
                                    color: Colors.black87, fontFamily: "thin"),
                                border: OutlineInputBorder(),
                                fillColor: Colors.grey.shade100,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.purple, width: 1.5)),
                              ),
                            )),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(left: 20, right: 20, bottom: 2),
                        child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextFormField(
                              controller: passwordCont,
                              obscureText: true,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (password) => password != null &&
                                      password.length < 6
                                  ? "كلمة المرور يجب أن تكون من 6 خانات أو أكثر"
                                  : null,
                              cursorColor: Colors.purple,
                              style: TextStyle(fontFamily: "mid"),
                              decoration: InputDecoration(
                                filled: true,
                                hintText: "",
                                labelText: "كلمة المرور",
                                labelStyle: TextStyle(
                                    color: Colors.black87, fontFamily: "thin"),
                                border: OutlineInputBorder(),
                                fillColor: Colors.grey.shade100,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.purple, width: 1.5)),
                              ),
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 22),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                                child: Text("  نسيت كلمة المرور؟",
                                    style: TextStyle(
                                        fontFamily: "thin", fontSize: 11)),
                                onTap: () => Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return ForgotPassworPage();
                                    })))
                          ],
                        ),
                      ),
                      Padding(
                          padding:
                              EdgeInsets.only(left: 22, right: 22, top: 40),
                          child: GestureDetector(
                            onTap: signIn,
                            child: Container(
                                height: 62,
                                width: 366,
                                decoration: BoxDecoration(
                                    color: Color(0xFFC9A7EB),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Center(
                                  child: Text("تسجيل الدخول",
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontFamily: "blod",
                                          color: Colors.white)),
                                )),
                          )),
                      SizedBox(
                        height: 11,
                      ),
                      RichText(
                        text: TextSpan(
                            text: "ماعندك حساب ؟ ",
                            style: TextStyle(
                                color: Colors.black, fontFamily: "thin"),
                            children: [
                              TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = widget.onClickSignUp,
                                  text: "انضم لعارف",
                                  style: TextStyle(
                                      color: Colors.purple,
                                      fontFamily: "thin")),
                            ]),
                      ),
                    ]),
              )),
            )));
  }
}
