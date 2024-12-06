import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:uber_admin_web/methods/common_methods.dart';
import 'package:url_launcher/url_launcher.dart';

class TripDataList extends StatefulWidget {
  const TripDataList({super.key});

  @override
  State<TripDataList> createState() => _TripDataListState();
}

class _TripDataListState extends State<TripDataList> {
  final tripsRecordsFromDatabase =
      FirebaseDatabase.instance.ref().child('tripRequests');
  CommonMethods cMethods = CommonMethods();

  launchGoogleMapFromSourceToDestination(
      pickUpLat, pickUpLng, dropOffLat, dropOffLng) async {
    String directionAPIUrl =
        'https://www.google.com/maps/dir/?api=1&origin=$pickUpLat,$pickUpLng&destination=$dropOffLat,$dropOffLng&travelmode=driving&dir_action=navigate';

    if (await canLaunchUrl(Uri.parse(directionAPIUrl))) {
      await launchUrl(Uri.parse(directionAPIUrl));
    } else {
      throw "Could not launch google map";
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: tripsRecordsFromDatabase.onValue,
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
              if (itemsList[index]['status'] != null &&
                  itemsList[index]['status'] != 'ended') {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    cMethods.data(
                        2,
                        Text(
                          itemsList[index]['tripID'],
                          // style: const TextStyle(color: Colors.white),
                        )),
                    cMethods.data(
                        1, Text(itemsList[index]['userName'].toString())),
                    cMethods.data(
                        1, Text(itemsList[index]['driverName'].toString())),
                    cMethods.data(
                        1, Text(itemsList[index]['carDetails'].toString())),
                    cMethods.data(
                      1,
                      Text(
                        itemsList[index]['publishDateTime'].toString(),
                      ),
                    ),
                    cMethods.data(
                        1,
                        Text(
                            "\$ ${itemsList[index]['fareAmount'] != null && itemsList[index]['fareAmount'] != '' ? itemsList[index]['fareAmount'].toString() : 0}")),
                    cMethods.data(
                      1,
                      ElevatedButton(
                        onPressed: () {
                          String pickUpLat = itemsList[index]['pickUpLatLng']
                                  ['latitude']
                              .toString();
                          String pickUpLng = itemsList[index]['pickUpLatLng']
                                  ['longitude']
                              .toString();
                          String dropOffLat = itemsList[index]['dropOffLatLng']
                                  ['latitude']
                              .toString();
                          String dropOffLng = itemsList[index]['dropOffLatLng']
                                  ['longitude']
                              .toString();

                          launchGoogleMapFromSourceToDestination(
                              pickUpLat, pickUpLng, dropOffLat, dropOffLng);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5))),
                        child: const Text(
                          'View More',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return Container();
              }
            });
      },
    );
  }
}
