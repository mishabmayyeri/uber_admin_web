import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:uber_admin_web/methods/common_methods.dart';

class DriversDataList extends StatefulWidget {
  const DriversDataList({super.key});

  @override
  State<DriversDataList> createState() => _DriversDataListState();
}

class _DriversDataListState extends State<DriversDataList> {
  final driversRecordsFromDatabase =
      FirebaseDatabase.instance.ref().child('drivers');
  CommonMethods cMethods = CommonMethods();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: driversRecordsFromDatabase.onValue,
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
                  cMethods.data(
                      1,
                      Image.network(
                        itemsList[index]['photo'].toString(),
                        width: 50,
                        height: 50,
                      )),
                  cMethods.data(1, Text(itemsList[index]['name'].toString())),
                  cMethods.data(
                      1,
                      Text(itemsList[index]['car_details']['carModel']
                          .toString())),
                  cMethods.data(1, Text(itemsList[index]['phone'].toString())),
                  cMethods.data(
                      1,
                      Text(
                          "\$ ${itemsList[index]['earnings'] != null ? itemsList[index]['earnings'].toString() : 0}")),
                  cMethods.data(
                    1,
                    itemsList[index]['blockStatus'] == 'no'
                        ? ElevatedButton(
                            onPressed: () async {
                              await FirebaseDatabase.instance
                                  .ref()
                                  .child('drivers')
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
                                  .child('drivers')
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
