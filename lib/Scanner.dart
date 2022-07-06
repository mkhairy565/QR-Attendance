import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first/constants.dart';
import 'package:first/models/attend_model.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class Scanner extends StatefulWidget {
  const Scanner({Key? key}) : super(key: key);

  @override
  _ScannerState createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? barcode;
  QRViewController? controller;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  // @override
  // void reassemble() async {
  //   super.reassemble();
  //   if (Platform.isAndroid) {
  //     await controller?.pauseCamera();
  //   }
  //   controller?.resumeCamera();
  // }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          body: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              buildQrView(context),
              Positioned(bottom: 10, child: buildResult()),
            ],
          ),
        ),
      );

  Widget buildResult() => Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white24,
        ),
        child: Text(
          barcode != null ? 'Result : ${barcode!.code}' : 'Scan A Code!',
          maxLines: 3,
        ),
      );

  Widget buildQrView(BuildContext context) => QRView(
        key: qrKey,
        onQRViewCreated: (controller) {
          setState(() {
            this.controller = controller;
          });
          controller.scannedDataStream.listen((barcode) async {
            print("sample code print");
            await controller.pauseCamera();
            showResultDialog(context, barcode);
          });
        },
        overlay: QrScannerOverlayShape(
          borderColor: Colors.cyanAccent,
          borderRadius: 10,
          borderLength: 20,
          borderWidth: 10,
          cutOutSize: MediaQuery.of(context).size.width * 0.8,
        ),
        onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
      );

  void showResultDialog(BuildContext context, Barcode barcode) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Scan result'),
          content: Text(
            barcode != null ? 'Result : ${barcode.code}' : 'Scan A Code!',
            maxLines: 3,
          ),
          actions: [
            RaisedButton(
              onPressed: () {
                addAttend(barcode.code);
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text('ReScan'),
            )
          ],
        );
      },
    );
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    print('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  void addAttend(String? code) {
    AttendModel attendModel = AttendModel.fromJson(jsonDecode(code!));
    FirebaseFirestore.instance
        .collection("Attends")
        .add(attendModel.toJson())
        .then((value) => print("attend succ"));
  }
}
