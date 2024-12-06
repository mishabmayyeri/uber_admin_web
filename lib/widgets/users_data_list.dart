import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:uber_admin_web/methods/common_methods.dart';

class UsersDataList extends StatefulWidget {
  const UsersDataList({super.key});

  @override
  State<UsersDataList> createState() => _UsersDataListState();
}

class _UsersDataListState extends State<UsersDataList> {
  final usersRecordsFromDatabase =
      FirebaseDatabase.instance.ref().child('users');
  CommonMethods cMethods = CommonMethods();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: usersRecordsFromDatabase.onValue,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text(
              "Error Occurred.Try Later",
              style: TextStyle(
                color: Colors.pink,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.pink,
            ),
          );
        }
        if (!snapshot.hasData) {
          return const Center(
            child: Text(
              "No record found.",
              style: TextStyle(
                color: Colors.pink,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          );
        }

        Map dataMap = snapshot.data!.snapshot.value as Map;
        List itemsList = [];
        dataMap.forEach((key, value) {
          itemsList.add({'key': key, ...value});
        });
        return ListView.builder(
            itemCount: itemsList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  cMethods.data(
                      2,
                      Text(
                        itemsList[index]['id'],
                        // style: const TextStyle(color: Colors.white),
                      )),
                  cMethods.data(1, Text(itemsList[index]['name'].toString())),
                  cMethods.data(1, Text(itemsList[index]['email'].toString())),
                  cMethods.data(1, Text(itemsList[index]['phone'].toString())),
                  cMethods.data(
                      1,
                      Text(
                          "${itemsList[index]['totalTrips'] != null ? itemsList[index]['totalTrips'].toString() : 0}")),
                  cMethods.data(
                    1,
                    itemsList[index]['blockStatus'] == 'no'
                        ? ElevatedButton(
                            onPressed: () async {
                              await FirebaseDatabase.instance
                                  .ref()
                                  .child('users')
                                  .child(itemsList[index]['id'])
                                  .update({'blockStatus': 'yes'});
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.pink,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5))),
                            child: const Text(
                              'Block',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        : ElevatedButton(
                            onPressed: () async {
                              await FirebaseDatabase.instance
                                  .ref()
                                  .child('users')
                                  .child(itemsList[index]['id'])
                                  .update({'blockStatus': 'no'});
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.pink,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5))),
                            child: const Text(
                              'Approve',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                  ),
                ],
              );
            });
      },
    );
  }
}
