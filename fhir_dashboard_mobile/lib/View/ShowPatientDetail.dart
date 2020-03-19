import 'package:fhirdashboardmobile/Controller/httpRequest.dart';
import 'package:flutter/material.dart';
import "dart:convert";

class PatientDetailWidget extends StatefulWidget {
  final String patientid;
  final String patientName;
  PatientDetailWidget(this.patientid, this.patientName);
  @override
  PatientDetailWidgetState createState() {
    return PatientDetailWidgetState(this.patientid, this.patientName);
  }
}

class PatientDetailWidgetState extends State<PatientDetailWidget> {
  String patientid;
  String patientname;

  @override
  void initState(){
    super.initState();
  }

  PatientDetailWidgetState(this.patientid, this.patientname);

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<Map<String, dynamic>>(
        future: fetchPatientObservation(patientid),
        builder:(BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (!snapshot.hasData) return Center(
            child: Container(
              child: CircularProgressIndicator(),
              height: 60.0,
              width: 60.0,
            ),
          );
          var fields = snapshot.data.keys.toList();
          return Scaffold(
              appBar: new AppBar(
                title: new Text(patientname),
              ),
              body: ListView.builder(
                itemCount: snapshot.data.length * 2,
                  itemBuilder: (context, fieldindex) {
                    if (fieldindex % 2 == 0){
                      return Column(
                        children: <Widget>[
                          Divider(color: Colors.black,),
                          ListTile(
                          title: Text(fields[fieldindex ~/ 2]),
                          )
                        ],
                      );
                    }
                    return Container(
                      height: 200,
                      child: ListView.builder(
                          itemCount: snapshot.data[fields[fieldindex ~/ 2]].length + 1,
                          itemBuilder: (context, observationindex){
                            if (observationindex == 0){
                              return Divider(color: Colors.grey,);
                            }
                            var data = snapshot.data[fields[fieldindex ~/ 2]][observationindex - 1];
                            return ListTile(
                              title: Text("ID:" + data["id"]),
                              subtitle: Text("Date: " + data["date"] + "\nValue: " + data["value"]),
                              onTap: () {
                              },
                            );
                          },
                      ),
                    );
                  },
                )
          );
      }
    );
  }
}