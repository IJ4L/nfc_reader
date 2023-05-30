import 'dart:io';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:nfc_manager/nfc_manager.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  _listenLnLinks() async {
    bool isAvailable = await NfcManager.instance.isAvailable();
    if (isAvailable && Platform.isAndroid) {
      _startNFCSession();
    }
  }

  _startNFCSession() async {
    await NfcManager.instance.stopSession();
    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        var ndef = Ndef.from(tag);
        if (ndef != null) {
          for (var rec in ndef.cachedMessage!.records) {
            String payload = String.fromCharCodes(rec.payload);
            String nimMahasiswa = payload.substring(3);
            Logger().i(nimMahasiswa);
          }
        }
      },
    );
  }

  @override
  void initState() {
    _listenLnLinks();
    super.initState();
  }

  @override
  void dispose() {
    _listenLnLinks();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('NFC Reader'),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    'Tag Data:',
                    style: TextStyle(fontSize: 18),
                  ),
                  // Text(
                  //   tag,
                  //   style: TextStyle(fontSize: 18),
                  // ),
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
