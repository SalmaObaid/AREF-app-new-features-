import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignUpWidget extends StatefulWidget {
  final VoidCallback onClickSignIn;

  SignUpWidget({
    Key? key,
    required this.onClickSignIn,
  }) : super(key: key);

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
  // List get LecturesMap => _SignUpWidgetState._lecturesMap;
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final formKey = GlobalKey<FormState>();
  final passwordCont = TextEditingController();
  final emailCont = TextEditingController();
  final nameCont = TextEditingController();
  final userNameCont = TextEditingController();
  final CollectionReference Users =
      FirebaseFirestore.instance.collection("Users");
  bool isLoading = false;
  String? uid;
  final List<String> avatars = [
    "images/avatars_images/user1.png",
    "images/avatars_images/user2.png",
    "images/avatars_images/user3.png",
    "images/avatars_images/user4.png",
    "images/avatars_images/user5.png",
    "images/avatars_images/user6.png",
    "images/avatars_images/user7.png",
    "images/avatars_images/user8.png",
    "images/avatars_images/user9.png",
  ];

  String _selectedAvatar = "images/USER-IMAGE.png";

  @override
  void dispose() {
    passwordCont.dispose();
    emailCont.dispose();
    nameCont.dispose();
    super.dispose();
  }

  Future<void> signUp() async {
    final isValid = formKey.currentState!.validate();

    if (!isValid) return;

    setState(() {
      isLoading = true;
    });

    try {
      // Check if username is unique
      final userNameList = await FirebaseFirestore.instance
          .collection('Users')
          .where('Username', isEqualTo: userNameCont.text.trim())
          .get();

      if (userNameList.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              "عذراً اسم المستخدم محجوز",
              style: TextStyle(
                  color: Colors.white, fontFamily: "thin", fontSize: 12),
            ),
          ),
          backgroundColor: Color.fromARGB(255, 100, 27, 21),
        ));
      } else {
        // Proceed with Firebase Authentication
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailCont.text.trim(),
          password: passwordCont.text.trim(),
        );
        await FirebaseAuth.instance.currentUser
            ?.updateDisplayName(nameCont.text);

        if (FirebaseAuth.instance.currentUser != null) {
          uid = FirebaseAuth.instance.currentUser?.uid;
          print(uid);

          // Save user data to Firestore
          String name = nameCont.text.trim();
          String username = userNameCont.text.trim();
          String email = emailCont.text.trim();
          String photo = _selectedAvatar;
          int points = 0;
          List? SubscribedSubjects;

          await FirebaseFirestore.instance.collection('Users').doc(uid).set({
            'Email': email,
            'Name': name,
            'PhotoURL': photo,
            'Username': username,
            "User Points": points,
            "Subscribed Subjects": SubscribedSubjects
          });

          print("User added successfully!");
        }
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            "البريد الإلكتروني سبق استخدامه",
            style: TextStyle(
                color: Colors.white, fontFamily: "thin", fontSize: 12),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 100, 27, 21),
      ));
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            "حدث خطأ غير متوقع، حاول مرة أخرى.",
            style: TextStyle(
                color: Colors.white, fontFamily: "thin", fontSize: 12),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 100, 27, 21),
      ));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          children: [
            Center(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 32),

                    Text(
                      "حساب جديد",
                      style: TextStyle(fontFamily: "blod", fontSize: 38),
                    ),
                    SizedBox(height: 23),
                    Stack(
                      children: [
                        CircleAvatar(
                            radius: 64,
                            backgroundColor: Colors.white,
                            backgroundImage: AssetImage(_selectedAvatar)),
                        Positioned(
                          bottom: -8,
                          left: -1,
                          child: IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  useSafeArea: true,
                                  showDragHandle: true,
                                  backgroundColor: Colors.white,
                                  context: context,
                                  builder: (context) {
                                    return Center(
                                      child: Card(
                                        elevation: 0,
                                        surfaceTintColor: Colors.white,
                                        color: Colors.white,
                                        child: GridView.builder(
                                          padding: EdgeInsets.all(10),
                                          shrinkWrap: true,
                                          itemCount: avatars.length,
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            crossAxisSpacing: 10.0,
                                            mainAxisSpacing: 10.0,
                                          ),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _selectedAvatar =
                                                        avatars[index];
                                                  });
                                                  Navigator.pop(context);
                                                },
                                                child: Image.asset(
                                                  avatars[index],
                                                  fit: BoxFit.cover,
                                                ));
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              icon: Image.asset(
                                "images/PlusIcon.png",
                                scale: 4.5,
                              )),
                        )
                      ],
                    ),
                    SizedBox(height: 23),
                    // Name input
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 20),
                        // Second name input
                        SizedBox(
                          width: 175,
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextFormField(
                              controller: userNameCont,
                              cursorColor: Colors.purple,
                              style: TextStyle(fontFamily: "mid"),
                              decoration: InputDecoration(
                                filled: true,
                                hintText: "",
                                labelText: "اسم المستخدم",
                                labelStyle: TextStyle(
                                  color: Colors.black87,
                                  fontFamily: "thin",
                                ),
                                border: OutlineInputBorder(),
                                fillColor: Colors.grey.shade100,
                                focusedBorder: OutlineInputBorder(
                                  gapPadding: 11,
                                  borderSide: BorderSide(
                                    color: Colors.purple,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        // First name input
                        SizedBox(
                          width: 175,
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextFormField(
                              controller: nameCont,
                              cursorColor: Colors.purple,
                              style: TextStyle(fontFamily: "mid"),
                              decoration: InputDecoration(
                                filled: true,
                                hintText: "",
                                labelText: "الاسم الاول",
                                labelStyle: TextStyle(
                                  color: Colors.black87,
                                  fontFamily: "thin",
                                ),
                                border: OutlineInputBorder(),
                                fillColor: Colors.grey.shade100,
                                focusedBorder: OutlineInputBorder(
                                  gapPadding: 11,
                                  borderSide: BorderSide(
                                    color: Colors.purple,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Email input
                    Padding(
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20,
                        bottom: 15,
                        top: 15,
                      ),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextFormField(
                          controller: emailCont,
                          cursorColor: Colors.purple,
                          style: TextStyle(fontFamily: "mid"),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (email) =>
                              email != null && !EmailValidator.validate(email)
                                  ? "البريد الإلكتروني ليس صالح"
                                  : null,
                          decoration: InputDecoration(
                            filled: true,
                            hintText: "",
                            labelText: 'البريد الإلكتروني',
                            labelStyle: TextStyle(
                              color: Colors.black87,
                              fontFamily: "thin",
                            ),
                            border: OutlineInputBorder(),
                            fillColor: Colors.grey.shade100,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.purple,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Password input
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: 2),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextFormField(
                          controller: passwordCont,
                          obscureText: true,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (password) =>
                              password != null && password.length < 6
                                  ? "كلمة المرور يجب أن تكون من 6 خانات أو أكثر"
                                  : null,
                          cursorColor: Colors.purple,
                          style: TextStyle(fontFamily: "mid"),
                          decoration: InputDecoration(
                            filled: true,
                            hintText: "",
                            labelText: "كلمة المرور",
                            labelStyle: TextStyle(
                              color: Colors.black87,
                              fontFamily: "thin",
                            ),
                            border: OutlineInputBorder(),
                            fillColor: Colors.grey.shade100,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.purple,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Sign Up button
                    Padding(
                      padding: EdgeInsets.only(left: 22, right: 22, top: 40),
                      child: GestureDetector(
                        onTap: isLoading ? null : signUp,
                        child: Container(
                          height: 62,
                          width: 366,
                          decoration: BoxDecoration(
                            color: isLoading ? Colors.grey : Color(0xFFC9A7EB),
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                          ),
                          child: Center(
                            child: isLoading
                                ? CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  )
                                : Text(
                                    "تسجيل الدخول",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontFamily: "blod",
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 11),
                    // Sign in link
                    RichText(
                      text: TextSpan(
                        text: "عندك حساب ؟ ",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: "thin",
                        ),
                        children: [
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = widget.onClickSignIn,
                            text: "سجل دخول",
                            style: TextStyle(
                              fontFamily: "thin",
                              color: Colors.purple,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Lecturer {
  final String name;
  final String photoURL;
  final String RateURL;
  final String major;

  // Generative constructor with initializing formal parameters
  Lecturer(
      {required this.name,
      required this.photoURL,
      required this.major,
      required this.RateURL});
  toJson() {
    return {"Name": name, "PhotoURL": photoURL, "RateURL": RateURL};
  }
}

class Subject {
  final String name;
  final String description;
  final Lecturer lecturer;
  final List lecturesList;

  // Generative constructor with initializing formal parameters
  Subject(
      {required this.name,
      required this.description,
      required this.lecturesList,
      required this.lecturer});
}
