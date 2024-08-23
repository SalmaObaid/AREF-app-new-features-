import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: Padding(
          padding: EdgeInsets.all(22),
          child: Column(
            children: [
              SizedBox(
                height: 12,
              ),
              Text(
                ":المتصدرين",
                style: TextStyle(fontFamily: "blod", fontSize: 30),
              ),
              SizedBox(
                height: 12,
              ),
              Directionality(
                textDirection: TextDirection.rtl,
                child: Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Users')
                        .orderBy('User Points', descending: true)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(
                            child: Text(
                          'لديك فرصة بأن تكون الأفضل',
                          style: TextStyle(
                            fontFamily: "mid",
                          ),
                        ));
                      }

                      final users = snapshot.data!.docs;

                      return ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];
                          final isTop3 = index < 3;
                          final cardColor = isTop3
                              ? (index == 0
                                  ? Color(0xFFFFAF45)
                                  : index == 1
                                      ? Color(0xFFE3E1D9)
                                      : Color(0xFFC69774))
                              : Colors.white;
                          final iconCard = isTop3
                              ? (index == 0
                                  ? Image.asset(
                                      "images/Icons/1st-Place-Medal_1f9472.png",
                                    )
                                  : index == 1
                                      ? Image.asset(
                                          "images/Icons/2nd Place Medal.png")
                                      : Image.asset(
                                          "images/Icons/3rd Place Medal.png"))
                              : null;

                          return Card(
                            elevation: 3,
                            color: cardColor,
                            margin: EdgeInsets.all(10),
                            child: ListTile(
                              trailing: isTop3
                                  ? iconCard
                                  : Text(
                                      "${index + 1}   ",
                                      style: TextStyle(
                                          fontFamily: "blod", fontSize: 28),
                                    ),
                              leading: CircleAvatar(
                                backgroundImage: AssetImage(user['PhotoURL']),
                              ),
                              title: Text(
                                user['Name'],
                                style: TextStyle(fontFamily: "mid"),
                              ),
                              subtitle: Text(
                                '${user['Username']}@ ',
                                style: TextStyle(
                                  fontFamily: "thin",
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        )));
  }
}
