import 'dart:convert';

import 'package:fhirdashboardmobile/Controller/httpRequest.dart';
import 'package:fhirdashboardmobile/View/ShowPatientDetail.dart';
import 'package:flutter/material.dart';

class PatientSearchResultPage extends StatefulWidget {
  @override
  PatientSearchResultPageState createState() => PatientSearchResultPageState();
}

class PatientSearchResultPageState extends State<PatientSearchResultPage> {
  List filteredID = new List();
  List allID = new List();
  final TextEditingController _filter = TextEditingController();
  Icon _searchIcon = Icon(Icons.search);
  Widget _appBarTitle = Text("Patients Search");

  PatientSearchResultPageState(){
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          filteredID = allID;
        });
      } else {
        setState(() {
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: _appBarTitle,
        actions: <Widget>[
          IconButton(
            icon: _searchIcon,
            onPressed: () {
              setState(() {
                if (_searchIcon.icon == Icons.search){
                  _searchIcon = Icon(Icons.close);
                  _appBarTitle = new TextField(
                    controller: _filter,
                    decoration: new InputDecoration(
                        prefixIcon: new Icon(Icons.search),
                        hintText: 'Search patient ID ...'
                    ),
                  );
                }
                else{
                  _searchIcon = Icon(Icons.search);
                  filteredID = allID;
                  _filter.clear();
                }
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<dynamic, dynamic>>>(
          future: fetchPatientList(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Map<dynamic, dynamic>>> snapshot) {
            if (!snapshot.hasData) return Center(
              child: Container(
                child: CircularProgressIndicator(),
                height: 60.0,
                width: 60.0,
              ),
            );
            allID = snapshot.data;
            filteredID = allID;
            if (_filter.text.isNotEmpty) {
              List tempList = new List();
              for (int i = 0; i < filteredID.length; i++) {
                if (filteredID[i]['id'].toLowerCase().contains(_filter.text.toLowerCase())) {
                  tempList.add(filteredID[i]);
                }
              }
              filteredID = tempList;
            }
            return ListView.builder(
              itemCount: filteredID.length,
              itemBuilder: (context, index) {
                var data = filteredID[index];
                return ListTile(
                  title: Text("ID:" + data["id"]),
                  subtitle: Text("Name: " + data["name"]),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => PatientDetailWidget(data["id"], data["name"])),),
                    );
                  },
                );
              },
            );
          }),
    );
  }

}
