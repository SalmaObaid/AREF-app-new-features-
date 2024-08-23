import 'package:arefapp/Screens/challange_list.dart';
import 'package:flutter/material.dart';

class ChallangeObtions extends StatefulWidget {
  const ChallangeObtions({super.key});

  @override
  State<ChallangeObtions> createState() => _ChallangeObtionsState();
}

class _ChallangeObtionsState extends State<ChallangeObtions> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey[50],
          body: SafeArea(
            child: Center(
                child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    GestureDetector(
                      child: Container(
                        height: 250,
                        width: 400,
                        child: Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("⌛", style: TextStyle(fontSize: 40)),
                            Text(
                              textAlign: TextAlign.center,
                              "التحديات الحالية",
                              style: TextStyle(
                                  fontFamily: "blod",
                                  fontSize: 50,
                                  color: Colors.white),
                            )
                          ],
                        )),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xFFCCC1F0),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ChallangesList();
                            },
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(height: 20),
                    Container(
                      child: Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("💡", style: TextStyle(fontSize: 40)),
                          Text(
                            textAlign: TextAlign.center,
                            "تحدي حديد",
                            style: TextStyle(
                                fontFamily: "blod",
                                fontSize: 50,
                                color: Colors.white),
                          )
                        ],
                      )),
                      height: 250,
                      width: 400,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xFFCCC1F0),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ]),
            )),
          ),
        ),
      ),
    );
  }
}
