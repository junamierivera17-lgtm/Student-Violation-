import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;

class ScannerPage extends StatefulWidget {
  const ScannerPage({Key? key}) : super(key: key);

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool isScanned = false;

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;

    controller.scannedDataStream.listen((scanData) {
      if (!isScanned) {
        isScanned = true;
        sendViolation(scanData.code);
      }
    });
  }

  void sendViolation(String? studentId) async {
    var url = Uri.parse("http://YOUR_IP/aclc_api/add_violation.php");

    await http.post(url, body: {
      "student_id": studentId ?? "",
      "violation_type": "No ID"
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Violation Recorded")),
    );

    controller?.pauseCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan QR Code")),
      body: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
      ),
    );
  }
}