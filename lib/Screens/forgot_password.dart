import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassworPage extends StatefulWidget {
  const ForgotPassworPage({super.key});

  @override
  State<ForgotPassworPage> createState() => _ForgotPassworPageState();
}

class _ForgotPassworPageState extends State<ForgotPassworPage> {
  final formKey = GlobalKey<FormState>();
  final emailCont = TextEditingController();

  Future resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailCont.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Directionality(
            textDirection: TextDirection.rtl,
            child: Text("تم إرسال رابط الاستعادة على البريد الإلكتروني",
                style: TextStyle(color: Colors.white))),
        backgroundColor: Colors.red,
      ));
    } catch (e) {
      print(e);
      print("there is an error");
    }
  }

  void dispose() {
    emailCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
                  Text("إستعادة كلمة المرور",
                      style: TextStyle(fontFamily: "blod", fontSize: 38)),
                  SizedBox(height: 42),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, bottom: 15),
                    child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextFormField(
                          controller: emailCont,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (email) =>
                              email != null && !EmailValidator.validate(email)
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
                  //Button
                  Padding(
                      padding: EdgeInsets.only(left: 22, right: 22, top: 40),
                      child: GestureDetector(
                        onTap: resetPassword,
                        child: Container(
                            height: 62,
                            width: 366,
                            decoration: BoxDecoration(
                                color: Colors.black,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
