import 'package:arefapp/Screens/course_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _searchScreenState();
  String get Subjectname => _searchScreenState._Subjectname;
  String get Description => _searchScreenState._description;
  String get lecturerName => _searchScreenState._lecturerName;
  double get progressOfSubjects => _searchScreenState._progressOfSubjects;
  String get lecturerMajor => _searchScreenState._lecturerMajor;
  String get lecturerPhoto => _searchScreenState._lecturerPhoto;
  String get lecturerRate => _searchScreenState._lecturerRate;

  List get lecturesStateMap => _searchScreenState._lecturesStateMap;
}

class _searchScreenState extends State<SearchScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static String _Subjectname = "لا يوجد";
  static String _description = "لا يوجد";
  static double _progressOfSubjects = 0;
  static String _lecturerName = "لا يوجد";
  static String _lecturerMajor = "لا يوجد";
  static String _lecturerPhoto = " لا يوجد";
  static String _lecturerRate = "  لا يوجد";

  static List<Map<String, dynamic>> _lecturesStateMap = [];

  List<Map<String, dynamic>> _allSubjects = [
    {
      "name": "جافا 101",
      "discreption":
          "تعتمد على مفهوم 'الكائنات' التي تحتوي على بيانات (سمات) ووظائف (أساليب). تسهّل إنشاء وبرمجة التطبيقات المعقدة باستخدام مبادئ مثل الوراثة، التغليف، التعددية، والواجهات."
    },
    {
      "name": "جافا 102",
      "discreption":
          "تعتمد على مفهوم 'الكائنات' التي تحتوي على بيانات (سمات) ووظائف (أساليب). تسهّل إنشاء وبرمجة التطبيقات المعقدة باستخدام مبادئ مثل الوراثة، التغليف، التعددية، والواجهات."
    },
    {
      "name": "أنظمة التشغيل",
      "discreption":
          "تهتم بإدارة موارد الحاسوب مثل العمليات والذاكرة والملفات والمدخلات والمخرجات. تتضمن أيضًا مواضيع مثل الأمان والتزامن بين العمليات."
    },
    {
      "name": "المنطق الرقمي",
      "discreption":
          "يُعنى بدراسة أساسيات تصميم الدوائر الإلكترونية باستخدام الأرقام الثنائية والعمليات المنطقية. يتضمن المواضيع الرئيسية مثل البوابات المنطقية، الجبر البولياني، الدارات التوافقية والتتابعية."
    },
    {
      "name": "تراكيب محددة",
      "discreption":
          "تركز على دراسة البنى الرياضية المنفصلة وتُستخدم بشكل واسع في علوم الحاسوب لتحليل الخوارزميات وتصميم الدوائر الرقمية. تشمل الموضوعات الرئيسية نظرية المجموعات، نظرية الرسوم البيانية، التوافيق، المنطق، والنظرية العددية."
    },
    {
      "name": "عمارة الحاسب",
      "discreption":
          "تُعنى بدراسة تصميم وتنظيم مكونات الحاسوب الداخلية، مثل وحدة المعالجة المركزية، الذاكرة، وأنظمة الإدخال والإخراج. تتناول أيضًا مفاهيم مثل التجزئة، الذاكرة المخبأة، ومعالجة البيانات بشكل متوازي."
    },
  ];
  List<Map<String, dynamic>> _foundSubjects = [];
  @override
  void initState() {
    _foundSubjects = _allSubjects;
    super.initState();
  }

  Future<void> addSubjectToUser(String Subjectname) async {
    DocumentSnapshot doc =
        await _firestore.collection("Subjects").doc(Subjectname).get();
    if (doc.exists) {
      _Subjectname = doc['Subject name'];

      _description = doc['description'];
      _progressOfSubjects = doc['Progress Of Subjects'].toDouble();
      Map<String, dynamic> lecturerData = doc['Lecturer'];

      _lecturerName = lecturerData['Name'];
      _lecturerPhoto = lecturerData['PhotoURL'];
      _lecturerMajor = lecturerData['Major'];
      _lecturerRate = lecturerData['RateURL'];

      // _lecturesStateMap = doc['LecutersArray'];
    } else {
      print("docoment is not exists");
    }
  }

  void _runFilter(String keyword) {
    List<Map<String, dynamic>> results = [];
    if (keyword.isEmpty) {
      results = _allSubjects;
    } else {
      results = _allSubjects
          .where((subject) =>
              subject["name"].toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundSubjects = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      addSubjectToUser("جافا 101");
    });
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              " :المواد الحالية",
              style: TextStyle(
                fontFamily: "blod",
                fontSize: 30,
              ),
            ),
            SizedBox(
              height: 28,
            ),
            Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextField(
                    onChanged: (value) => _runFilter(value),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                      hintText: 'أبحث عن مادة..',
                      hintStyle: TextStyle(fontFamily: "thin"),
                    ),
                  ),
                )),
            SizedBox(
              height: 20,
            ),
            Expanded(
                child: _foundSubjects.isNotEmpty
                    ? ListView.builder(
                        itemCount: _foundSubjects.length,
                        itemBuilder: (context, index) => GestureDetector(
                              onTap: () async {
                                await addSubjectToUser(
                                    _foundSubjects[index]["name"]);

                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    //   getStateofSubject();

                                    return CourseScreen(
                                      path: "Search",
                                      SubjectDoc: _foundSubjects[index]["name"],
                                    );
                                  },
                                ));
                              },
                              child: Container(
                                key: ValueKey(_foundSubjects[index]["name"]),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Color.fromARGB(255, 205, 196, 232),
                                ),
                                height: 200,
                                width: 60,
                                margin: EdgeInsets.all(10),
                                child: ListTile(
                                    title: Center(
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Text(
                                      _foundSubjects[index]["name"],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "blod",
                                        fontSize: 50,
                                      ),
                                    ),
                                  ),
                                )),
                              ),
                            ))
                    : Center(
                        child: Text(
                          "لا توجد نتيجة متطابقة",
                          style: TextStyle(fontFamily: "mid"),
                        ),
                      ))
          ],
        ),
      ),
    ));
  }
}
