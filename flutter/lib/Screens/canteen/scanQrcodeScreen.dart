import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:smartcanteen/Screens/canteen/orderDetailsScreen.dart';
import 'package:smartcanteen/Services/canteen/orderDetails.dart';

String? qrScannedOrderId;

class ScanCodePage extends StatefulWidget {
  const ScanCodePage({super.key});

  @override
  State<ScanCodePage> createState() => _ScanCodePageState();
}

class _ScanCodePageState extends State<ScanCodePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.popAndPushNamed(context, "/generate");
            },
            icon: const Icon(
              Icons.qr_code,
            ),
          ),
        ],
      ),
      body: Center(
        child: Container(height: 700,width: 400,
          child: MobileScanner(
            controller: MobileScannerController(
              detectionSpeed: DetectionSpeed.noDuplicates,
              returnImage: true,
            ),
            onDetect: (capture) async{
              final List<Barcode> barcodes = capture.barcodes;
              final Uint8List? image = capture.image;
              for (final barcode in barcodes) {
                qrScannedOrderId = barcode.rawValue;
                print(qrScannedOrderId);
                print('Barcode found! ${barcode.rawValue}');
              }
              if (image != null) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        barcodes.first.rawValue ?? "",
                      ),
                      content: Image(
                        image: MemoryImage(image),
                      ),
                    );
                  },
                );
                await Future.delayed(Duration(seconds: 1));
                final resp = await getOrderdetailsApi();
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => OrderDetails(order: resp!,),));
              }
            },
          ),
        ),
      ),
    );
  }
}
