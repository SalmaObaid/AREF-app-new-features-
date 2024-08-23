import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChallangesList extends StatefulWidget {
  const ChallangesList({super.key});

  @override
  State<ChallangesList> createState() => _ChallangesListState();
}

class _ChallangesListState extends State<ChallangesList> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey[50],
        body: SingleChildScrollView(
          // physics: NeverScrollableScrollPhysics(),
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      " :التحديات الحالية",
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
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              border: InputBorder.none,
                              hintText: 'أبحث عن تحدي..',
                              hintStyle: TextStyle(fontFamily: "thin"),
                            ),
                          ),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[50],
                      ),
                      height: 600,
                      width: 400,
                      alignment: Alignment.center,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: ListView(
                          scrollDirection: Axis.vertical,
                          children: [
                            SizedBox(height: 20),
                            Container(
                              height: 200,
                              width: 60,
                              child: Center(
                                  child: Text(
                                "تحدي عارف",
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
                              height: 20,
                            ),
                            SizedBox(height: 20),
                            Container(
                              child: Center(
                                  child: Text(
                                textAlign: TextAlign.center,
                                "تحدي جافا",
                                style: TextStyle(
                                    fontFamily: "blod",
                                    fontSize: 50,
                                    color: Colors.white),
                              )),
                              height: 200,
                              width: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0xFFB4E5BC),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(height: 20),
                            Container(
                              alignment: Alignment.center,
                              child: Center(
                                  child: Text(
                                textAlign: TextAlign.center,
                                "تحدي الشهر",
                                style: TextStyle(
                                    fontFamily: "blod",
                                    fontSize: 50,
                                    color: Colors.white),
                              )),
                              height: 200,
                              width: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0xFFFFDDAE),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(width: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class searchScreen extends StatefulWidget {
  const searchScreen({super.key});

  @override
  State<searchScreen> createState() => _searchScreenState();
}

class _searchScreenState extends State<searchScreen> {
  List<Map<String, dynamic>> _allSubjects = [
    {"name": "جافا 101"},
    {"name": "جافا 102"},
    {"name": "أنظمة التشغيل"},
    {"name": "المنطق الرقمي"},
    {"name": "تراكيب محددة"},
    {"name": "عمارة الحاسب"},
  ];
  List<Map<String, dynamic>> _foundSubjects = [];
  @override
  void initState() {
    _foundSubjects = _allSubjects;
    super.initState();
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
    return Scaffold(
      appBar: AppBar(
        title: Text("aref list"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            TextField(
              onChanged: (value) => _runFilter(value),
              decoration: const InputDecoration(
                  labelText: 'Search', suffixIcon: Icon(Icons.search)),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
                child: _foundSubjects.isNotEmpty
                    ? ListView.builder(
                        itemCount: _foundSubjects.length,
                        itemBuilder: (context, index) => Card(
                          key: ValueKey(_foundSubjects[index]["name"]),
                          color: Colors.grey,
                          elevation: 9,
                          margin: EdgeInsets.all(12),
                          child: ListTile(
                            title: Text(
                              _foundSubjects[index]["name"],
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      )
                    : Text("No results"))
          ],
        ),
      ),
    );
  }
}
