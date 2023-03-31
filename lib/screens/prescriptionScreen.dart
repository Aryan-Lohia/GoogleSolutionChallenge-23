import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';

import '../utils/app_style.dart';

class MyExcelTable {
  String? name;

  var price;

  var manufacturer;

  var size;

  var composition;

  MyExcelTable(
      {this.name, this.price, this.manufacturer, this.size, this.composition});
}

class PrescriptionScreen extends StatefulWidget {
  String image;
  List excelList;

  //String meds; TODO:ADD MEDS OPTION
  PrescriptionScreen({Key? key, required this.image, required this.excelList})
      : super(key: key);

  @override
  State<PrescriptionScreen> createState() => _PrescriptionScreenState();
}

class _PrescriptionScreenState extends State<PrescriptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Prescription"),
        backgroundColor: Colors.orangeAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.all(16),
                child: Container(
                    height: MediaQuery.of(context).size.height / 3,
                    child: Image.file(
                      File(widget.image),
                      fit: BoxFit.cover,
                    ))),
            Divider(
              color: Colors.grey,
              height: 16,
            ),
            Text(
              "Your Medicines:",
              style: Styles.headlineStyle1,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: MediaQuery.of(context).size.height / 3,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: widget.excelList.length,
                  itemBuilder: (context, index) =>
                      MedCard(myExcelTable: widget.excelList[index])),
            ),
            ElevatedButton(

              onPressed: () async{
                List meds=[];
                var a=Uuid().v1();
                final storageRef = FirebaseStorage.instance.ref();
                Reference b=storageRef.child('prescriptions/$a.jpg');
                await b.putFile(File(widget.image));
                String path=await b.getDownloadURL();
                for(int i=0;i<widget.excelList.length;i++)
                  {
                    meds.add({
                      'name':widget.excelList[i].name,
                      'manufacturer':widget.excelList[i].manufacturer,
                      'composition':widget.excelList[i].composition,
                      'price':widget.excelList[i].price,
                    });
                  }
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .update({
                  "prescriptions":FieldValue.arrayUnion([{
                    "img":path,
                    'meds':meds
                }])});
                },
              child: Text("Save Prescription"),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.orangeAccent)),
            )
          ],
        ),
      ),
    );
  }
}

class MedCard extends StatelessWidget {
  MyExcelTable myExcelTable;

  MedCard({Key? key, required this.myExcelTable}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: Image.asset("assests/images/logo-nobg.png"),
        title: Text(myExcelTable.name!),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(myExcelTable.manufacturer),
            Text(myExcelTable.composition),
          ],
        ),
        trailing: Text("Rs. ${myExcelTable.price}"),
      ),
    );
  }
}
