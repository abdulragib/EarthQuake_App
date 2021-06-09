import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // used for date formatting

var _data;
List _features = _data['features'];

void main() async {
  _data = await getQuakes();

  //print(_data['features'][0]['properties']);
  runApp(new MaterialApp(
    title: "Quakes",
    home: new Quakes(),
  ));
}

class Quakes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Quakes'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: new Center(
        child: new ListView.builder(
            itemCount: _features.length,
            padding: const EdgeInsets.all(15.0),
            itemBuilder: (BuildContext context, int position) {
              if (position.isOdd) return new Divider();
              final index = position ~/
                  2; // we are dividing position by 2 and returning an integer result.

              var format = new DateFormat.yMMMMd("en_US")
                  .add_jm(); // date and time format
              var date = format.format(
                DateTime.fromMillisecondsSinceEpoch(
                    _features[index]['properties']['time'],
                    isUtc: true),
              );

              return ListTile(
                title: new Text(
                  "At: $date",
                  style: new TextStyle(
                      fontSize: 15.5,
                      color: Colors.orange,
                      fontWeight: FontWeight.w500),
                ),
                subtitle: new Text(
                  "${_features[index]['properties']['place']}",
                  style: new TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                leading: new CircleAvatar(
                  backgroundColor: Colors.green,
                  child: new Text(
                    "${_features[index]['properties']['mag']}",
                    style: TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontStyle: FontStyle.normal),
                  ),
                ),
                onTap: () {
                  _showAlertMessage(context,
                      "Place: ${_features[index]["properties"]['title']}");
                },
              );
            }),
      ),
    );
  }

  void _showAlertMessage(BuildContext context, String message) {
    var alert = new AlertDialog(
      title: new Text('Quakes'),
      content: new Text(message),
      actions: <Widget>[
        new ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: new Text('Ok'))
      ],
    );
    showDialog(builder: (context) => alert, context: context);
  }
}

Future<Map> getQuakes() async {
  String apiUrl =
      'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson';
  http.Response response = await http.get(Uri.parse(apiUrl));
  return json.decode(response.body);
}

//https://pub.dev/packages/http/install to install http package.
//https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson api link.const

//new DateTime.fromMillisecondsSinceEpoch is used to convert our unix time stamp into human readable time stamp.
//isUtc: true means we it convert internation time into local time zone

//https://pub.dev/packages/intl/install install date format package
// we using format format.format to set date and time format
