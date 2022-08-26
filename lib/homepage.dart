import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  openMapsSheet(context) async {
    try {
      final coords = Coords(17.6951101327645, 75.28089164849547);
      final title = "Flood Alert";
      final availableMaps = await MapLauncher.installedMaps;

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Container(
                child: Wrap(
                  children: <Widget>[
                    for (var map in availableMaps)
                      ListTile(
                        onTap: () => map.showMarker(
                          coords: coords,
                          title: title,
                        ),
                        title: Text(map.mapName),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  "NDRF",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Alerts ⚠️",
                style: TextStyle(fontSize: 30, color: Colors.red),
              ),
              SizedBox(
                height: 30,
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("NDRF")
                        .doc("Solapur")
                        .collection("Alerts")
                        .orderBy('Date', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Text("Data fetching");
                      } else {
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            DocumentSnapshot course =
                                snapshot.data!.docs[index];
                            return Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Center(
                                    child: Container(
                                      // height: 200,
                                      width: 300,
                                      decoration: BoxDecoration(
                                          color: Color.fromARGB(
                                              255, 219, 219, 219),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text.rich(TextSpan(
                                                text: "Location: ",
                                                children: [
                                                  TextSpan(
                                                      text: "Pandharpur ",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                ])),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text.rich(TextSpan(
                                                text: "Severity: ",
                                                children: [
                                                  TextSpan(
                                                      text:
                                                          "${course['severity']} ",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color:
                                                              course['severity'] ==
                                                                      'Extreme'
                                                                  ? Colors.red
                                                                  : Colors
                                                                      .orange)),
                                                ])),
                                            // Text("Severity: ${course['severity']}"),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text.rich(TextSpan(
                                                text: "RWL: ",
                                                children: [
                                                  TextSpan(
                                                      text:
                                                          "${course['RWL']} m ",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                ])),
                                            // Text("RWL: ${course['RWL']}"),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text.rich(TextSpan(
                                                text:
                                                    "RWL at flood discharge:: ",
                                                children: [
                                                  TextSpan(
                                                      text:
                                                          "${course['RWL at flood discharge']} cusecs",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                ])),
                                            // Text(
                                            //     "RWL at flood discharge: ${course['RWL at flood discharge']}"),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text.rich(TextSpan(
                                                text: "Velocity: ",
                                                children: [
                                                  TextSpan(
                                                      text:
                                                          "${course['velocity']} m/sec",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                ])),
                                            // Text("Velocity: ${course['velocity']}"),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text.rich(
                                                  TextSpan(
                                                      text: "Depth: ",
                                                      children: [
                                                        TextSpan(
                                                            text:
                                                                "${course['depth']} m",
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600)),
                                                      ]),
                                                ),
                                                SizedBox(width: 10),
                                                course['velocity'] *
                                                            course['depth'] >
                                                        7.44
                                                    ? Icon(
                                                        Icons.car_crash,
                                                        color: Colors.redAccent,
                                                      )
                                                    : Icon(
                                                        Icons.flood,
                                                        color:
                                                            Colors.blueAccent,
                                                      )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                openMapsSheet(context);
                                              },
                                              child: Container(
                                                height: 50,
                                                width: 90,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: Colors.red),
                                                child: Center(
                                                    child: Text(
                                                  "Locate",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      }
                    }),
              ),

              // Container(
              //   height: 200,
              //   decoration: BoxDecoration(
              //       color: Color.fromARGB(255, 215, 215, 215),
              //       borderRadius: BorderRadius.circular(20)),
              //   child: Padding(
              //     padding: const EdgeInsets.all(15.0),
              //     child: Row(
              //       children: [
              //         Column(
              //           children: const [
              // Text.rich(TextSpan(text: "Location: ", children: [
              //   TextSpan(
              //       text: "Pandharpur ",
              //       style: TextStyle(
              //           fontSize: 15, fontWeight: FontWeight.w600)),
              // ])),
              //             // Text("Location: Pandharpur"),
              //             SizedBox(
              //               height: 10,
              //             ),
              //             Text.rich(
              //               TextSpan(
              //                 text: "River Name: ",
              //                 children: [
              //                   TextSpan(
              //                       text: "Bhima River",
              //                       style: TextStyle(
              //                           fontSize: 15,
              //                           fontWeight: FontWeight.w600,
              //                           color: Colors.blue)),
              //                 ],
              //               ),
              //             ),
              //             SizedBox(
              //               height: 10,
              //             ),
              //             Text.rich(
              //                 TextSpan(text: "Flood Severity: ", children: [
              //               TextSpan(
              //                   text: "Medium ",
              //                   style: TextStyle(
              //                       fontSize: 15,
              //                       fontWeight: FontWeight.w600,
              //                       color: Colors.orange)),
              //             ])),

              //             SizedBox(
              //               height: 10,
              //             ),
              //             Text.rich(
              //               TextSpan(
              //                 text: "RWL:     ",
              //                 children: [
              //                   TextSpan(
              //                       text: "496.780 m",
              //                       style: TextStyle(
              //                           fontSize: 15,
              //                           fontWeight: FontWeight.w600,
              //                           color: Colors.black)),
              //                 ],
              //               ),
              //             ),
              //             SizedBox(
              //               height: 10,
              //             ),
              //             Text.rich(
              //               TextSpan(
              //                 text: "RWL at flood discharge: ",
              //                 children: [
              //                   TextSpan(
              //                       text: "",
              //                       style: TextStyle(
              //                           fontSize: 15,
              //                           fontWeight: FontWeight.w600,
              //                           color: Colors.blue)),
              //                 ],
              //               ),
              //             ),
              //           ],
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.only(left: 10.0),
              //           child: Align(
              //             alignment: Alignment.bottomRight,
              //             child: Container(
              //               decoration: BoxDecoration(
              //                   color: Colors.redAccent,
              //                   borderRadius: BorderRadius.circular(10)),
              //               child: Padding(
              //                 padding: const EdgeInsets.all(8.0),
              //                 child: Text("Locate Flood Area"),
              //               ),
              //             ),
              //           ),
              //         )
              //       ],
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
