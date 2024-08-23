//import 'dart:math';//import 'package:appinio_video_player/appinio_video_player.dart';
// import 'package:another_stepper/another_stepper.dart';
// import 'package:arefapp/Screens/challange_list.dart';

// import 'package:arefapp/Screens/home_screen.dart';
//import 'package:arefapp/Screens/home_screen.dart';
//import 'package:arefapp/Screens/signupscreen.dart';

//import 'package:firebase_core/firebase_core.dart';

// import 'package:get/get_connect/http/src/utils/utils.dart';
// import 'package:timeline_tile/timeline_tile.dart';
//import 'package:get/get_connect/http/src/utils/utils.dart';
//import 'package:video_player/video_player.dart';
import 'package:arefapp/Screens/course_list_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class CourseScreen extends StatefulWidget {
  final String path;
  final String SubjectDoc;

  CourseScreen({
    Key? key,
    required this.path,
    required this.SubjectDoc,
  }) : super(key: key);

  //bool get subscribed => _CourseScreenState.subscribed;

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  //static bool subscribed = false;
  int Points = 0;
  int? updateedPoints;
  String? userId;
  String _Subjectname = "";
  String _description = "";
  double progressOfSubjects = 0;
  String _lecturerName = "";
  String _lecturerMajor = "";
  String _lecturerPhoto = "images/waiting.png";
  String _lecturerRate = "images/waiting.png";
  List lecturesArray = [];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    getData();
    userId = FirebaseAuth.instance.currentUser!.uid;
    if (userId == null) {
      print("User is not logged in");
      return;
    }
    getUserPoints();
    setState(() {});
  }

  Future<void> getData() async {
    String userID = FirebaseAuth.instance.currentUser!.uid;
    print("Subject name: $userID");
    _Subjectname = widget.SubjectDoc;
    print("Subject name: $_Subjectname");
    try {
      if (_Subjectname.isEmpty) {
        throw Exception("SubjectDoc cannot be empty.");
      }

      if (widget.path == "HomeScreen") {
        String userId = FirebaseAuth.instance.currentUser!.uid;

        if (userId.isEmpty) {
          throw Exception("User ID cannot be empty.");
        }

        DocumentSnapshot subscribedSubject = await _firestore
            .collection("Users")
            .doc(userId)
            .collection("Subscibed Subjects")
            .doc(_Subjectname)
            .get(GetOptions(source: Source.server));

        if (subscribedSubject.exists) {
          _Subjectname = subscribedSubject["Subject name"];
          _description = subscribedSubject['description'];
          progressOfSubjects =
              subscribedSubject['Progress Of Subjects'].toDouble();
          Map<String, dynamic> lecturerData = subscribedSubject['Lecturer'];

          _lecturerName = lecturerData['Name'];
          _lecturerPhoto = lecturerData['PhotoURL'];
          _lecturerMajor = lecturerData['Major'];
          _lecturerRate = lecturerData['RateURL'];

          // QuerySnapshot lecturesSnapshot = await _firestore
          //       .collection('Subjects')
          //       .doc(_Subjectname)
          //       .collection("Lectures")
          //       .get();
          print(
              "Document does  exist: Users/$userId/Subscibed Subjects/$_Subjectname");

          // Additional logic here
        } else {
          print(_Subjectname.toString());
          print(
              "Document does not exist: Users/$userId/Subscibed Subjects/$_Subjectname");
        }
      } else if (widget.path == "Search") {
        // Logic for SearchScreen path
        _Subjectname = SearchScreen().Subjectname;
        _description = SearchScreen().Description;
        _lecturerName = SearchScreen().lecturerName;
        _lecturerMajor = SearchScreen().lecturerMajor;
        progressOfSubjects = SearchScreen().progressOfSubjects.toDouble();
        _lecturerPhoto = SearchScreen().lecturerPhoto;
        _lecturerRate = SearchScreen().lecturerRate;
        lecturesArray = SearchScreen().lecturesStateMap;
      } else {
        print("Unknown path: ${widget.path}");
      }
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      setState(() {});
    }
  }

  Future<void> addToUser() async {
    // await getData();
    if (_Subjectname.isNotEmpty) {
      try {
        DocumentSnapshot subject =
            await _firestore.collection('Subjects').doc(_Subjectname).get();

        if (subject.exists) {
          Map<String, dynamic> subjectData =
              subject.data() as Map<String, dynamic>;

          // collection 1
          await _firestore
              .collection('Users')
              .doc(userId)
              .collection("Subscibed Subjects")
              .doc(_Subjectname)
              .set(subjectData);

          //  collection 2 lectures
          QuerySnapshot lecturesSnapshot = await _firestore
              .collection('Subjects')
              .doc(_Subjectname)
              .collection("Lectures")
              .get();

          // Add each lecture
          for (var lectureDoc in lecturesSnapshot.docs) {
            await _firestore
                .collection('Users')
                .doc(userId)
                .collection("Subscibed Subjects")
                .doc(_Subjectname)
                .collection("Subscibed Lectures")
                .doc(lectureDoc.id)
                .set(lectureDoc.data() as Map<String, dynamic>);
          }
        } else {
          print("subject dose not existed");
        }
      } catch (e) {
        print("Error occurred while add a subject: $e");
      }
    } else {
      print("No data for subject");
    }
  }

  Future removeFromUser() async {
    try {
      CollectionReference subject = await _firestore
          .collection('Users')
          .doc(userId)
          .collection("Subscibed Subjects");
      subject.doc(_Subjectname).delete();
    } catch (e) {
      print("Somthing get wrong while adding subject to user ");
    }
  }

  Future<void> getUserPoints() async {
    if (userId != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        int _points = userDoc.get('User Points');

        setState(() {
          Points = _points;
        });
      } else {
        print("User document does not exist");
      }
    } else {
      print("User is not logged in");
    }
  }

  void updatePoints() async {
    await getUserPoints(); // Ensure Points are uptodate

    Points += 5; // Increment Points by 5

    if (userId != null) {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .update({'User Points': Points});

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            foregroundColor: Colors.blueGrey,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white70,
            //shadowColor: Colors.yellow,
            title: Padding(
              padding: EdgeInsets.symmetric(horizontal: 49),
              child: Text(
                _Subjectname,
                style: TextStyle(
                  fontFamily: "blod",
                ),
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 200,
                    width: 400,
                    child: Center(
                        child: Text(
                      _Subjectname,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: "blod",
                          fontSize: 50,
                          color: Colors.white),
                    )),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFFCCC1F0),
                    ),
                  ),
                  SizedBox(
                    height: 26,
                  ),
                  Text(
                    _description,
                    textAlign: TextAlign.right,
                    style: TextStyle(fontFamily: "thin", color: Colors.black45),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  (widget.path != "HomeScreen")
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: 20,
                              width: 45,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.grey[350],
                              ),
                              child: Text(
                                "  موجز# ",
                                style: TextStyle(
                                    fontFamily: "THIN",
                                    color: Colors.black54,
                                    fontSize: 10),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              height: 20,
                              width: 45,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.grey[350],
                              ),
                              child: Text(
                                "  ممتع# ",
                                style: TextStyle(
                                    fontFamily: "THIN",
                                    color: Colors.black54,
                                    fontSize: 10),
                              ),
                            ),
                          ],
                        )
                      : Container(height: 20),
                  SizedBox(
                    height: 5,
                  ),
                  // in case PATH WAS HOME SCREEN
                  widget.path == "HomeScreen"
                      ? GestureDetector(
                          onDoubleTap: () {
                            Navigator.pop(context);
                          },
                          onTap: () async {
                            try {
                              await removeFromUser();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Text(
                                    'تم إلغاء الاشتراك بنجاح',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "thin",
                                        fontSize: 12),
                                  ),
                                ),
                                backgroundColor:
                                    Color.fromARGB(255, 21, 100, 24),
                              ));

                              Navigator.pop(context, 'تم إلغاء الاشتراك بنجاح');
                            } catch (e) {
                              print("Error during removal: $e");
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(9)),
                                child: Center(
                                    child: Text(
                                  "إلفاء الإنضمام",
                                  style: TextStyle(
                                      fontFamily: "thin", color: Colors.black),
                                )),
                                height: 32,
                                width: 120,
                              ),
                              SizedBox(
                                width: 75,
                              ),
                            ],
                          ),
                        )
                      :
                      // in case PATH WAS SEARCH SCREEN
                      GestureDetector(
                          onTap: () async {
                            await addToUser();

                            await _firestore
                                .collection("Users")
                                .doc(userId)
                                .collection("Subscibed Subjects")
                                .doc(_Subjectname)
                                .update({"State of Subject": true});
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Directionality(
                                textDirection: TextDirection.rtl,
                                child: Text(
                                  "تم الاشتراك بنجاح",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "thin",
                                      fontSize: 12),
                                ),
                              ),
                              backgroundColor: Color.fromARGB(255, 21, 100, 24),
                            ));
                            Navigator.pop(context);
                            setState(() {});
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(9)),
                                child: Center(
                                    child: Text(
                                  "إنضمام",
                                  style: TextStyle(
                                      fontFamily: "thin", color: Colors.white),
                                )),
                                height: 32,
                                width: 120,
                              ),
                              SizedBox(
                                width: 97,
                              ),
                              Directionality(
                                textDirection: TextDirection.rtl,
                                child: Text(
                                  "39 مشترك",
                                  style: TextStyle(fontFamily: "thin"),
                                ),
                              ),
                              SizedBox(
                                width: 1,
                              ),
                              Image.asset(
                                "images/USER.png",
                                width: 85,
                              )
                            ],
                          ),
                        ),

                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          ": المحتويات",
                          style: TextStyle(fontFamily: "blod", fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('Users')
                          .doc(userId)
                          .collection("Subscibed Subjects")
                          .doc(_Subjectname)
                          .collection("Subscibed Lectures")
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              "Error loading Lectures data",
                              style: TextStyle(fontFamily: "mid"),
                            ),
                          );
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(
                              semanticsLabel: "[جاري تحميل الدروس]",
                            ),
                          );
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Center(
                            child: Text(
                              "لا يوجد دروس",
                              style: TextStyle(fontFamily: "mid"),
                            ),
                          );
                        }

                        final LecturesDocs = snapshot.data!.docs;
                        return Container(
                          height: 500,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: const Color.fromARGB(255, 255, 255, 255),
                          ),
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: LecturesDocs.length,
                            itemBuilder: (context, index) {
                              final LectureDocData = LecturesDocs[index].data()
                                  as Map<String, dynamic>;
                              final LectureDocArrays =
                                  LectureDocData["LecutersArray"];

                              final LectureName =
                                  LectureDocArrays["Name of Lecture"];
                              // final bool LectureState =
                              //     LectureDocArrays["State of Lecture"];

                              print("this is the name of $LectureName");

                              return Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Container(
                                    child: GestureDetector(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              padding:
                                                  EdgeInsets.only(left: 50),
                                              height: 50,
                                              decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      252, 212, 212, 212),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                              child: Center(
                                                  child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      '$LectureName -${index + 1}',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontFamily: "blod",
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ))),
                                        ],
                                      ),
                                      onTap: () {},
                                    ),
                                  ));
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 17,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        ":المقدم",
                        style: TextStyle(fontFamily: "blod", fontSize: 20),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 11,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            _lecturerName,
                            style: TextStyle(fontFamily: "blod", fontSize: 17),
                          ),
                          SizedBox(
                            height: 0,
                          ),
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: Text(
                              _lecturerMajor,
                              style: TextStyle(fontFamily: "mid", fontSize: 10),
                            ),
                          ),
                          Image.asset(
                            _lecturerRate,
                            height: 34,
                            width: 34,
                          )
                        ],
                      ),
                      SizedBox(
                        width: 11,
                      ),
                      Image.asset(
                        _lecturerPhoto,
                        width: 64,
                        height: 64,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
