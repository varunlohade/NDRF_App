import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                  style: TextStyle(fontSize: 30),
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
                            return Column(
                              children: [
                                Container(
                                  height: 200,
                                  width: 300,
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 219, 219, 219),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text("Location: Solapur"),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text("Severity: ${course['severity']}"),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text("RWL: ${course['RWL']}"),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                            "RWL at flood discharge: ${course['RWL at flood discharge']}"),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text("Velocity: ${course['velocity']}"),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            String googleUrl =
                                                'https://www.google.com/maps/search/?api=1&query=${75.28089164849547},${17.6951101327645}';
                                            if (await canLaunch(googleUrl)) {
                                              await launch(googleUrl);
                                            } else {
                                              throw 'Could not open the map.';
                                            }
                                          },
                                          child: Container(
                                            height: 50,
                                            width: 90,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
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
                                SizedBox(
                                  height: 10,
                                )
                              ],
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
              //             Text.rich(TextSpan(text: "Location: ", children: [
              //               TextSpan(
              //                   text: "Pandharpur ",
              //                   style: TextStyle(
              //                       fontSize: 15, fontWeight: FontWeight.w600)),
              //             ])),
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
