import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../components/error.dart';
import '../components/scanpage/scan_button_page.dart';
import '../models/vr_scanned_user_model.dart';

class DataGridView extends StatefulWidget {
  const DataGridView({super.key});

  @override
  State<DataGridView> createState() => _DataGridViewState();
}

class _DataGridViewState extends State<DataGridView> {
  Map<String, VRScannedUser> vrscanneduserList = {};

  Barcode? result;
  QRViewController? controller;
  var isLoading = false;
  String loadingStatus = "";
  List<String> items = [];

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (validateQRData(scanData.code)) {
        // Valid data
        print('QR code data is valid: ${scanData.code}');
        setState(() {
          result = scanData;
          controller.stopCamera();
        });
      } else {
        // Invalid data
        print('QR code data is invalid: ${scanData.code}');
        setState(() {
          controller.stopCamera();
          showErrorDialog(context, 'Scanned QR not valid');
        });
      }
    });
  }

  bool validateQRData(String? qrText) {
    // Regular expression to validate the scanned data
    RegExp exp = RegExp(r"VRFOC23");
    return exp.hasMatch(qrText!);
  }

  void fetchData() async {
    Response response;
    setState(() {
      var loadingStatus = "loading";
    });
    try {
      response = await Dio().get(
          "https://registervr-2c445-default-rtdb.firebaseio.com/scannedUser.json");
      print(response);
      if (response.statusCode == 200) {
        VRScannedUserResponse vrscanneduserResponse =
            VRScannedUserResponse.fromJson(response.data);

        setState(() {
          vrscanneduserList = vrscanneduserResponse.vrscanneduserList;
        });

        // Assuming you have a map of VRScannedUser objects named vrscanneduserList
        VRScannedUser vrUser = vrscanneduserList["VRFOC230003"]!;
        Map<String, bool> gameList = vrUser.gameList; // get the gameList map
        String gameListJson =
            jsonEncode(gameList); // encode the map as a JSON string

        print("VRScannedUser GameList $gameListJson");
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void didChangeDependencies() {
    fetchData();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DefaultTabController(
        length: 7,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              isScrollable: true, // Set this to true
              tabs: [
                Tab(text: "Most Wanted"),
                Tab(text: "Blur"),
                Tab(text: "Crash Bandicoot"),
                Tab(text: "Breakneck"),
                Tab(text: "Pubg"),
                Tab(text: "Call Of Duty Modern Warfare 4"),
                Tab(text: "Pubg"),
              ],
            ),
            title: const Text('Individual Game'),
          ),
          body: TabBarView(
            children: [
              SecondScreen(),
              SecondScreen(),
              SecondScreen(),
              SecondScreen(),
              SecondScreen(),
              SecondScreen(),
              SecondScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
