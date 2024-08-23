import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String _textButton = "    تعديل معلوماتي";
  bool ableToEdit = false;
  bool editMode = false;
  //
  final passwordCont = TextEditingController();
  final emailCont = TextEditingController();
  final nameCont = TextEditingController();

  String? PhotoURL;
  String? Username;
  int? Points;
  String avatar = "";

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
  // List<Map<String, dynamic>> _allSubjects = [
  //   {"name": "جافا 101"},
  //   {"name": "جافا 102"},
  //   {"name": "أنظمة التشغيل"},
  //   {"name": "المنطق الرقمي"},
  //   {"name": "تراكيب محددة"},
  //   {"name": "عمارة الحاسب"},
  // ];
  // List<Map<String, dynamic>> _SubscribedSubjects = [];

  @override
  void initState() {
    super.initState();
    getUsername();
  }

  Future<void> getUsername() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        String? _username = userDoc.get('Username');
        String? photourl = userDoc.get('PhotoURL');
        int? points = userDoc.get('User Points');

        setState(() {
          Username = _username;
          PhotoURL = photourl;
          Points = points;
          print(Username);
        });
      } else {
        print("User document does not exist");
      }
    } else {
      print("User is not logged in");
    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      print(Username);
    });
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: SafeArea(
              child: Center(
                  child: Column(
                children: [
                  SizedBox(
                    height: 31,
                  ),
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 64,
                        backgroundColor: Colors.black,
                        backgroundImage: PhotoURL != null
                            ? AssetImage(PhotoURL!)
                            : AssetImage("images/USER-IMAGE.png"),
                      ),
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
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  PhotoURL = avatars[index];
                                                  FirebaseFirestore.instance
                                                      .collection("Users")
                                                      .doc(FirebaseAuth.instance
                                                          .currentUser?.uid)
                                                      .update({
                                                    "PhotoURL": PhotoURL
                                                  });
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
                  SizedBox(
                    height: 11,
                  ),
                  Text(
                    FirebaseAuth.instance.currentUser?.displayName ?? "No Name",
                    style: TextStyle(
                      fontFamily: "blod",
                      color: Colors.black,
                      fontSize: 40,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: RichText(
                          text: TextSpan(
                            text: '',
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              TextSpan(
                                  text: ' $Points',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "thin",
                                      fontSize: 20)),
                              TextSpan(
                                  text: ' نقطة',
                                  style: TextStyle(
                                      fontFamily: "thin", fontSize: 18)),
                            ],
                          ),
                        ),
                      ),
                      Image.asset(
                        "images/Icons/Fire.png",
                        scale: 3.6,
                      ),
                    ],
                  ),
                  Card(
                    margin: EdgeInsets.all(10),
                    color: Colors.white,
                    surfaceTintColor: Colors.white,
                    elevation: 7,
                    child: Padding(
                      padding: EdgeInsets.all(35),
                      child: Column(children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                ": بياناتي",
                                style: TextStyle(
                                  fontFamily: "mid",
                                  fontSize: 20,
                                ),
                              ),
                            ]),
                        //username
                        Padding(
                          padding: EdgeInsets.only(
                            top: 13,
                            bottom: 2,
                          ),
                          child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: TextFormField(
                                controller: nameCont,
                                cursorColor: Colors.purple,
                                style: TextStyle(fontFamily: "mid"),
                                decoration: InputDecoration(
                                  filled: true,
                                  enabled: false,
                                  hintText: "",
                                  labelText: Username != null
                                      ? "$Username@"
                                      : 'يوجد خطاْ',
                                  labelStyle: TextStyle(
                                      color: Colors.black87,
                                      fontFamily: "thin"),
                                  border: OutlineInputBorder(),
                                  fillColor: Colors.grey.shade100,
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.purple, width: 1.5)),
                                ),
                              )),
                        ),
                        //name
                        Padding(
                          padding: EdgeInsets.only(
                            top: 13,
                            bottom: 2,
                          ),
                          child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: TextFormField(
                                controller: nameCont,
                                //   obscureText: true,
                                cursorColor: Colors.purple,
                                style: TextStyle(fontFamily: "mid"),
                                decoration: InputDecoration(
                                  filled: true,
                                  enabled: ableToEdit,
                                  hintText: "",
                                  labelText: FirebaseAuth
                                      .instance.currentUser?.displayName,
                                  labelStyle: TextStyle(
                                      color: Colors.black87,
                                      fontFamily: "thin"),
                                  border: OutlineInputBorder(),
                                  fillColor: Colors.grey.shade100,
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.purple, width: 1.5)),
                                ),
                              )),
                        ),

                        //email
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: 15,
                            top: 15,
                          ),
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextFormField(
                              enabled: ableToEdit,
                              controller: emailCont,
                              cursorColor: Colors.purple,
                              style: TextStyle(fontFamily: "mid"),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (email) => email != null &&
                                      !EmailValidator.validate(email)
                                  ? "البريد الإلكتروني ليس صالح"
                                  : null,
                              decoration: InputDecoration(
                                filled: true,
                                hintText: "",
                                labelText:
                                    FirebaseAuth.instance.currentUser?.email,
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
                        Padding(
                          padding: EdgeInsets.only(top: 5, bottom: 15),
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextFormField(
                              enabled: ableToEdit,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextButton(
                              onPressed: () async {
                                setState(() {
                                  editMode = !editMode;
                                  if (editMode) {
                                    ableToEdit = true;
                                    _textButton = "حفظ";
                                  } else {
                                    setState(() {});
                                    ableToEdit = false;
                                    _textButton = "تعديل بياناتي";
                                  }
                                });
                                bool wrong = false;
                                bool emailUpdated = false;
                                if (nameCont.text.isNotEmpty) {
                                  await FirebaseAuth.instance.currentUser!
                                      .updateDisplayName(nameCont.text.trim());
                                  wrong = true;
                                }
                                if (passwordCont.text.isNotEmpty) {
                                  try {
                                    await FirebaseAuth.instance.currentUser
                                        ?.updatePassword(
                                            passwordCont.text.trim());
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor:
                                            Color.fromARGB(255, 29, 121, 51),
                                        content: Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: Text(
                                              "تم تحديث كلمة المرور",
                                              style:
                                                  TextStyle(fontFamily: "thin"),
                                            )),
                                      ),
                                    );
                                    wrong = true;
                                  } catch (e) {
                                    print(e.toString());
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          backgroundColor:
                                              Color.fromARGB(255, 100, 27, 21),
                                          content: Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: Text(
                                              'حدث خطأ, يرجى المحاولة في وقت أخر',
                                              style:
                                                  TextStyle(fontFamily: "thin"),
                                            ),
                                          )),
                                    );
                                  }
                                }
                                if (emailCont.text.isNotEmpty) {
                                  try {
                                    await FirebaseAuth.instance.currentUser!
                                        .verifyBeforeUpdateEmail(
                                            emailCont.text.trim());
                                    emailUpdated = true;
                                    wrong = true;

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor:
                                            Color.fromARGB(255, 29, 121, 51),
                                        content: Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: Text(
                                              "تحقق من بريدك الإلكتروني الجديد",
                                              style:
                                                  TextStyle(fontFamily: "thin"),
                                            )),
                                      ),
                                    );
                                  } catch (e) {
                                    print(e.toString());
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor:
                                            Color.fromARGB(255, 100, 27, 21),
                                        content: Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: Text(
                                              'حدث خطأ, يرجى المحاولة في وقت أخر',
                                              style:
                                                  TextStyle(fontFamily: "thin"),
                                            )),
                                      ),
                                    );
                                  }
                                }

                                if (wrong) {
                                  setState(() {});
                                }

                                if (emailUpdated) {
                                  await Future.delayed(Duration(seconds: 6));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor:
                                          Color.fromARGB(255, 29, 121, 51),
                                      content: Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: Text(
                                            "يجب أن تسجل دخولك ببريد الإلكتروني الجديد",
                                            style:
                                                TextStyle(fontFamily: "thin"),
                                          )),
                                    ),
                                  );
                                  await Future.delayed(Duration(seconds: 6));

                                  FirebaseAuth.instance.signOut();
                                }
                              },
                              child: Text(
                                _textButton,
                                style: TextStyle(
                                    fontFamily: "thin", color: Colors.purple),
                              ),
                            )
                          ],
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                ":" " الإنجازات المكتملة",
                                style: TextStyle(
                                  fontFamily: "mid",
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ]),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[50],
                          ),
                          height: 160,
                          width: 400,
                          alignment: Alignment.center,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                Container(
                                  child: Center(
                                    child: Text("تحدي\nعارف",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: "blod",
                                            color: Colors.white,
                                            fontSize: 28)),
                                  ),
                                  height: 160,
                                  width: 160,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color(0xFFFFDDAE),
                                  ),
                                ),
                                SizedBox(width: 20),
                                Container(
                                  child: Center(
                                    child: Text("وسام\nعارف",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: "blod",
                                            color: Colors.white,
                                            fontSize: 28)),
                                  ),
                                  height: 160,
                                  width: 160,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color(0xFFC4B989),
                                  ),
                                ),
                                SizedBox(width: 20),
                                Container(
                                  child: Center(
                                    child: Text("وسام\nالإنجاز",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: "blod",
                                            color: Colors.white,
                                            fontSize: 28)),
                                  ),
                                  height: 160,
                                  width: 160,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.pink[50],
                                  ),
                                ),
                                SizedBox(width: 20),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                ":" " المواد المكتملة",
                                style: TextStyle(
                                  fontFamily: "mid",
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(
                                height: 60,
                              ),
                            ]),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[50],
                          ),
                          height: 160,
                          width: 400,
                          alignment: Alignment.center,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                Container(
                                  child: Center(
                                    child: Text("تراكيب\nمحددة",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: "blod",
                                            color: Colors.white,
                                            fontSize: 28)),
                                  ),
                                  height: 160,
                                  width: 160,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color(0xFFCCC1F0),
                                  ),
                                ),
                                SizedBox(width: 20),
                                Container(
                                  child: Center(
                                    child: Text("عمارة\nحاسب",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: "blod",
                                            color: Colors.white,
                                            fontSize: 28)),
                                  ),
                                  height: 160,
                                  width: 160,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color(0xFFB4E5BC),
                                  ),
                                ),
                                SizedBox(width: 20),
                                Container(
                                  child: Center(
                                    child: Text("جافا\n101",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: "blod",
                                            color: Colors.white,
                                            fontSize: 28)),
                                  ),
                                  height: 160,
                                  width: 160,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.pink[50],
                                  ),
                                ),
                                SizedBox(width: 20),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          child: Container(
                              margin: EdgeInsets.only(top: 20),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10)),
                              width: 400,
                              height: 65,
                              child: Text("تسجيل خروج",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontFamily: "mid",
                                      fontSize: 22,
                                      color: const Color.fromARGB(
                                          255, 163, 30, 21)))),
                          onTap: () {
                            FirebaseAuth.instance.signOut();
                          },
                        ),
                      ]),
                    ),
                  )
                ],
              )),
            ),
          )),
    );
  }
}
