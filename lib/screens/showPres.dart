import 'package:first_app/screens/prescriptionScreen.dart';
import 'package:flutter/material.dart';
import '../utils/app_style.dart';
class Prescription extends StatelessWidget {
  final String image;
  List excelList;
  Prescription({Key? key,required this.image,required this.excelList}) : super(key: key);

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
                    child: Image.network(
                      image,
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
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: excelList.length,
                  itemBuilder: (context, index) =>
                      MedCard(myExcelTable: excelList[index])),
            ),

          ],
        ),
      ),
    );
  }
}
