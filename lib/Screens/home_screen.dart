import 'package:arefapp/Screens/course_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();

  List<String> get SubscibedSubjects => _HomeScreenState.subscibedSubjects;
}

class _HomeScreenState extends State<HomeScreen> {
  static List<String> subscibedSubjects = [];
  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    // Check if user is logged in
    if (userId == null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Text(
              "User not logged in",
              style: TextStyle(fontFamily: "mid", fontSize: 20),
            ),
          ),
        ),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: ListView(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 23, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Image.asset(
                          //   "images/Icons/Bell.png",
                          //   scale: 2.5,
                          // ),
                          Column(
                            children: [
                              Text(
                                FirebaseAuth
                                        .instance.currentUser?.displayName ??
                                    "No Name",
                                style: TextStyle(
                                  fontFamily: "mid",
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple[300],
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'المستوى: 1',
                                style: TextStyle(
                                  fontFamily: "thin",
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple[300],
                                ),
                              ),
                            ],
                          ),
                          Image.asset(
                            "images/Icons/Light Bulb (1).png",
                            scale: 2.5,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 25),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 17),
                        child: Container(
                          padding: const EdgeInsets.only(
                              bottom: 20, right: 10, left: 10, top: 20),
                          height: 230,
                          decoration: BoxDecoration(
                            color: Colors.blue[100],
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: 130,
                                width: 90,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Color(0xFFCCC1F0),
                                      ),
                                      height: 30,
                                      width: 80,
                                    ),
                                    SizedBox(height: 6),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Colors.pink[200],
                                          ),
                                          height: 30,
                                          width: 35,
                                        ),
                                        SizedBox(width: 6),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Color(0xFFFFDDAE),
                                          ),
                                          height: 30,
                                          width: 35,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 6),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Colors.black26,
                                          ),
                                          height: 30,
                                          width: 35,
                                        ),
                                        SizedBox(width: 6),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Colors.pink[300],
                                          ),
                                          height: 30,
                                          width: 35,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 30),
                              Column(
                                children: [
                                  Text(
                                    ' أفضل المقالات ',
                                    style: TextStyle(
                                      fontFamily: "mid",
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "أفضل المقالات التي تتم كتابتها \nعن طريق المتعلمين في البرنامج",
                                    style: TextStyle(
                                      fontFamily: "thin",
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 25),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 50, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 255, 167, 198),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'ابدأ القراءة',
                                        style: TextStyle(
                                          fontFamily: "mid",
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            border: InputBorder.none,
                            hintText: 'البحث',
                            hintStyle: TextStyle(fontFamily: "thin"),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            ' أكمل تقدمك:',
                            style: TextStyle(
                              fontFamily: "mid",
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: Container(
                        width: 400,
                        height: 200,
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('Users')
                              .doc(userId)
                              .collection("Subscibed Subjects")
                              .snapshots(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Center(
                                child: Text(
                                  "Error loading data",
                                  style: TextStyle(fontFamily: "mid"),
                                ),
                              );
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(
                                  semanticsLabel: "[جاري تحميل المواد]",
                                ),
                              );
                            }
                            if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return Center(
                                child: Text(
                                  "لم يتم إضافة مواد",
                                  style: TextStyle(fontFamily: "mid"),
                                ),
                              );
                            }

                            final subscibedSubjectsDocs = snapshot.data!.docs;

                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: subscibedSubjectsDocs.length,
                              itemBuilder: (context, index) {
                                final subjectData = subscibedSubjectsDocs[index]
                                    .data() as Map<String, dynamic>;
                                final colorString =
                                    subjectData["Subject Color"] ??
                                        "0xFFFFFFFF";
                                final double ProgressOfSubjects =
                                    subjectData["Progress Of Subjects"]
                                            ?.toDouble() ??
                                        0.0;

                                Color color;
                                try {
                                  color = Color(int.parse(colorString));
                                } catch (e) {
                                  color = Colors.white;
                                }

                                return GestureDetector(
                                  child: Container(
                                    width: 300,
                                    height: 50,
                                    margin: EdgeInsets.all(11),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                            height: 109,
                                            width: 400,
                                            decoration: BoxDecoration(
                                                color: color,
                                                borderRadius: BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(10),
                                                    topLeft:
                                                        Radius.circular(10))),
                                            child: Center(
                                              child: Text(
                                                '${subjectData["Subject name"]} ',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: "blod",
                                                  fontSize: 30,
                                                ),
                                              ),
                                            )),
                                        Container(
                                            decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                borderRadius: BorderRadius.only(
                                                    bottomRight:
                                                        Radius.circular(10),
                                                    bottomLeft:
                                                        Radius.circular(10))),
                                            width: 300,
                                            height: 69,
                                            padding: EdgeInsets.only(
                                                bottom: 25,
                                                left: 10,
                                                right: 10,
                                                top: 35),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child:
                                                      LinearProgressIndicator(
                                                    value: ProgressOfSubjects
                                                        .toDouble(),
                                                    backgroundColor:
                                                        Colors.grey,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                                Color>(
                                                            Colors.green),
                                                  ),
                                                )
                                              ],
                                            )),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return CourseScreen(
                                            path: "HomeScreen",
                                            SubjectDoc:
                                                subjectData["Subject name"],
                                          );
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
