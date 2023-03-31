import 'dart:async';

import 'package:excel/excel.dart';
import 'package:first_app/screens/googleApi.dart';
import 'package:first_app/screens/prescriptionScreen.dart';
import 'package:first_app/utils/app_style.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatefulWidget {
  String imagePath;

  LoadingScreen({Key? key, required this.imagePath}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool isLoading = true;
  static List<dynamic> excelList = [];

  process() async {
    String parsed=await googleApi(widget.imagePath);
    await searchExcel(parsed);

  }

  searchExcel(String meds) async {
    List<String> med = meds.split(" ");
    await _upload(med);
    Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => PrescriptionScreen(
                  image: widget.imagePath,
                  excelList: excelList,
                )));

  }

  static FutureOr<void> _upload(List<String> meds) async {
    ByteData data = await rootBundle.load('assests/dataset.xlsx');
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);
    Sheet sheetObject = excel['Sheet1'];
    for (int rowIndex = 1; rowIndex <= 1305; rowIndex++) {
      var excelfileDetails = new MyExcelTable();
      excelfileDetails.name = sheetObject
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex))
          .value
          .toString();
      excelfileDetails.price = sheetObject
          .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex))
          .value;
      excelfileDetails.manufacturer = sheetObject
          .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: rowIndex))
          .value
          .toString();
      excelfileDetails.size = sheetObject
          .cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: rowIndex))
          .value
          .toString();
      excelfileDetails.composition = sheetObject
          .cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: rowIndex))
          .value
          .toString();
      for (int j = 0; j < meds.length; j++) {
        if (excelfileDetails.name!
            .toLowerCase()
            .contains(meds[j].toLowerCase())) {
          excelList.add(excelfileDetails);
        }
      }
    }


  }

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    Timer(Duration(seconds: 1,milliseconds: 500), () {process(); });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orangeAccent,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(30)),
          height: MediaQuery.of(context).size.height / 3,
          width: MediaQuery.of(context).size.width / 1.3,
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                ),
                SpinKitPumpingHeart(size: 50,color: Colors.red,),
                SizedBox(
                  height: 20,
                ),
                Center(child: Text("Processing your Prescription",style: Styles.headlineStyle3,)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
