import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first/Inputs/DropDowmMenue.dart';
import 'package:first/constants.dart';
import 'package:first/models/attend_model.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui';
import 'package:flutter/rendering.dart';

class GeneratePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GeneratePageState();
}

class GeneratePageState extends State<GeneratePage> {
  String qrData =
      "https://github.com/neon97";  // already generated qr code when the page opens

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('QR Code Generator'),
        actions: <Widget>[],
      ),
      body: Container(
        child:SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: QrImage(
                //plce where the QR Image will be shown
                data: qrData,
                size: 400,
              ),
            ),
            SizedBox(
              height: 25.0,
            ),
           Padding(padding:  EdgeInsets.fromLTRB(40, 0, 40, 0),
           child: DropDowm(),
           ),
            Padding(
              padding: EdgeInsets.fromLTRB(40, 20, 40, 0),
              child: FlatButton(
                padding: EdgeInsets.all(15.0),
                onPressed: () async {

                  // if (qrdataFeed.text.isEmpty) {        //a little validation for the textfield
                  //   setState(() {
                  //     qrData = "";
                  //   });
                  // } else {
                  //   setState(() {
                  //     qrData = qrdataFeed.text;
                  //   });
                  // }

                  generateNewAttendModel();

                },
                child: Text(
                  "Generate QR",
                  style: TextStyle(
                      color: Colors.blueAccent, fontWeight: FontWeight.bold),
                ),
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.blueAccent, width: 3.0),
                    borderRadius: BorderRadius.circular(20.0)),
              ),
            )
          ],
        ),
        ),
      ),
    );
  }

  generateNewAttendModel(){
    var newAttendId = FirebaseFirestore.instance
        .collection("Attends")
        .doc(currentLoggedInUser!.id!)
        .collection("my_attend")
        .doc()
        .id;
    AttendModel attendModel = AttendModel(
        id: newAttendId,
        attendType: "section",
        date: "05-06-2022",
        sectionNumber: "1",
        subjectId: "distributed",
        subjectName: "distributed",
        userId: currentLoggedInUser!.id!,
        userName: currentLoggedInUser!.name!
    );

    String modelData = jsonEncode(attendModel.toJson());

    qrData = modelData;
    setState(() {});
  }
  final qrdataFeed = TextEditingController();
}