import 'package:charts_flutter/flutter.dart' as charts;
import 'package:fhirdashboardmobile/Model/DataSeries.dart';
import 'package:fhirdashboardmobile/Controller/httpRequest.dart';
import 'package:fhirdashboardmobile/View/PatientSearchResult.dart';
import 'package:flutter/material.dart';

class FHIROverview extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ChartsState();
  }
}

class ChartsState extends State<FHIROverview> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Patients Overview"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => PatientSearchResultPage())));
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: fetchOverview(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return AlertDialog(
              title: Text("Cannot connect"),
              content: Text("Failed to receive data. Retry?"),
              actions: <Widget>[
                FlatButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text("Retry"),
                  onPressed: () {
                    setState(() {});
                  },
                )
              ],
            );
          }
          if (!snapshot.hasData)
            return Center(
              child: Container(
                child: CircularProgressIndicator(),
                height: 60.0,
                width: 60.0,
              ),
            );
          List<List<charts.Series<DataSeries, String>>> seriesList = [];
//          snapshot.data.foreach((k, v) => seriesList.add(createSeries(v, k)));
          seriesList.add([createSeries(snapshot.data["race"], "Patients Race")]);
          seriesList.add([createSeries(snapshot.data["ethnicity"], "Patients Ethnicity")]);
          seriesList.add([createSeries(snapshot.data["mortality"], "Patients Mortality")]);
          return ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              Container(
                width: 700,
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: <Widget>[
                    ListTile(
                      title: Text('Server URL'),
                      subtitle: Text(snapshot.data["serverinfo"]["server_url"]),
                    ),
                    ListTile(
                      title: Text('FHIR version'),
                      subtitle: Text(snapshot.data["serverinfo"]["fhir_version"]),
                    ),
                    ListTile(
                      title: Text('Number of Patients'),
                      subtitle: Text(snapshot.data["patientsnumber"].toString()),
                    ),
                    Divider(color: Colors.black,),
                    ListTile(
                      title: Text("Patient Race"),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 30.0, right: 30.0),
                      width: 700,
                      height: 400,
                      child: charts.BarChart(
                          seriesList[0],
                          animate: true,
                        barRendererDecorator: new charts.BarLabelDecorator(
                          insideLabelStyleSpec: new charts.TextStyleSpec(
                            fontSize: 15,
                              color: charts.MaterialPalette.black
                          ),
                          outsideLabelStyleSpec: new charts.TextStyleSpec(
                              fontSize: 15,
                            color: charts.MaterialPalette.black
                          ),
                        ),
                        behaviors: [
                            charts.DatumLegend(
                            desiredMaxColumns: 3,
                            entryTextStyle: charts.TextStyleSpec(
                                fontSize: 15
                            ),
                          )
                          ],
                      ),
                    ),
                    Divider(color: Colors.black,),
                    ListTile(
                      title: Text("Patient Ethnicity"),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 30.0, right: 30.0),
                      width: 700,
                      height: 400,
                      child: charts.BarChart(
                        seriesList[1],
                        animate: true,
                        barRendererDecorator: new charts.BarLabelDecorator(
                          insideLabelStyleSpec: new charts.TextStyleSpec(
                              fontSize: 15,
                              color: charts.MaterialPalette.black
                          ),
                          outsideLabelStyleSpec: new charts.TextStyleSpec(
                              fontSize: 15,
                              color: charts.MaterialPalette.black
                          ),
                        ),
                        behaviors: [
                          charts.DatumLegend(
                            desiredMaxColumns: 3,
                            entryTextStyle: charts.TextStyleSpec(
                                fontSize: 15
                            ),
                          )
                        ],
                      ),
                    ),
                    Divider(color: Colors.black,),
                    ListTile(
                      title: Text("Patient Mortality"),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 30.0, right: 30.0),
                      width: 700,
                      height: 400,
                      child: charts.BarChart(
                        seriesList[2],
                        animate: true,
                        barRendererDecorator: new charts.BarLabelDecorator(
                          insideLabelStyleSpec: new charts.TextStyleSpec(
                              fontSize: 15,
                              color: charts.MaterialPalette.black
                          ),
                          outsideLabelStyleSpec: new charts.TextStyleSpec(
                              fontSize: 15,
                              color: charts.MaterialPalette.black
                          ),
                        ),
                        behaviors: [
                          charts.DatumLegend(
                            desiredMaxColumns: 3,
                            entryTextStyle: charts.TextStyleSpec(
                                fontSize: 15
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  charts.Series<DataSeries, String> createSeries(Map<String, dynamic> data, String title) {
    List<DataSeries> listdata = List();
    data.forEach((k, v) => listdata.add(DataSeries.all(k, v, listdata.length)));
    return charts.Series<DataSeries, String>(
      id: "PatientInfo",
      data: listdata,
      domainFn: (DataSeries d, _) => d.name,
      measureFn: (DataSeries d, _) => d.value,
      colorFn: (DataSeries d, _) =>
      charts.MaterialPalette.getOrderedPalettes(data.length)[d.index]
          .makeShades(1)[0],
      labelAccessorFn: (DataSeries d, _) => d.value.toString()
    );
  }
}