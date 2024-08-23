import 'dart:async';

import 'package:arefapp/Screens/navigation_bottom.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  Timer? countdownTimer;
  Duration myDuration = Duration(seconds: 30);

  void initState() {
    super.initState();
    //user need to ber created be4
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
        Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  void startTimer() {
    countdownTimer =
        Timer.periodic(Duration(seconds: 1), (_) => setCountDown());
  }

  void stopTimer() {
    setState(() => countdownTimer!.cancel());
  }

  void resetTimer() {
    stopTimer();
    setState(() => myDuration = Duration(seconds: 30));
  }

  void setCountDown() {
    final reduceSecondsBy = 1;
    setState(
      () {
        final seconds = myDuration.inSeconds - reduceSecondsBy;
        if (seconds < 0) {
          countdownTimer!.cancel();
        } else {
          myDuration = Duration(seconds: seconds);
        }
      },
    );
  }

  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    startTimer();
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) {
      timer?.cancel();
    }
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;

      await user.sendEmailVerification();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            "تم إرسال رابط التحقق",
            style: TextStyle(
              color: Colors.white,
              fontFamily: "thin",
            ),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 29, 121, 51),
      ));
      setState(() => canResendEmail = false);

      await Future.delayed(Duration(seconds: 30));
      setState(() => canResendEmail = true);
    } catch (e) {
      print(e);
      print("error in verifiction");
    }
  }

  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '');

    final seconds = strDigits(myDuration.inSeconds.remainder(30));

    if (isEmailVerified) {
      return NavigationBottom();
    } else {}
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: Center(
            child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(
                height: 93,
              ),
              Directionality(
                textDirection: TextDirection.rtl,
                child: Text(
                  "لقد تم إرسال  رابط للتحقق من البريد الإلكتروني ",
                  style: TextStyle(fontSize: 30, fontFamily: "mid"),
                ),
              ),
              SizedBox(
                height: 19,
              ),
              Text("من فضلك تحقق من بريدك الإلكتروني للمتابعة",
                  style: TextStyle(fontFamily: "thin")),
              Padding(
                  padding: EdgeInsets.only(left: 22, right: 22, top: 40),
                  child: GestureDetector(
                    onTap: () {
                      if (canResendEmail) {
                        sendVerificationEmail();
                      } else {
                        //startTimer();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Directionality(
                              textDirection: TextDirection.rtl,
                              child: Row(
                                children: [
                                  Text(
                                    "انتظر ",
                                    style: TextStyle(
                                      fontFamily: "thin",
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    '$seconds' " ثانية",
                                    style: TextStyle(
                                      fontFamily: "thin",
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              )),
                          duration: Duration(seconds: 3),
                          backgroundColor:
                              const Color.fromARGB(255, 100, 27, 21),
                        ));
                      }
                    },
                    child: Container(
                        height: 62,
                        width: 366,
                        decoration: BoxDecoration(
                            color: Color(0xFFC9A7EB),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Center(
                          child: Text("أعد الإرسال",
                              style: TextStyle(
                                  fontSize: 22,
                                  fontFamily: "blod",
                                  color: Colors.white)),
                        )),
                  )),
              SizedBox(
                height: 19,
              ),
              GestureDetector(
                onTap: () {
                  FirebaseAuth.instance.signOut();
                },
                child: Container(
                    height: 62,
                    width: 336,
                    decoration: BoxDecoration(
                        color: Color(0xFFC9A7EB),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Center(
                      child: Text("إلغاء",
                          style: TextStyle(
                              fontSize: 22,
                              fontFamily: "blod",
                              color: Colors.white)),
                    )),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
