import 'dart:convert';
import 'dart:async';
import 'package:app/screens/google_map_screen.dart';
//import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Page',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primaryColor: Colors.white,
      ),
      home: MyHomePage(),
    );
  }
}

class Data {
  final String number;

  Data({required this.number});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      number: json['plate'],
    );
  }
}
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var number;
  final numberCon = new TextEditingController();
  
  Future<Data> postData(String number) async {
    final response = await http.get(
      Uri.parse('https://lanechangebackend.azurewebsites.net/api/getVehicledata/$number')
     );
     
     
  if (response.statusCode == 201) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    print('helooooo');
    print(jsonDecode(response.body));
    return Data.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create album.');
  }
}
Future<String> fetchData(number) async {
  final response = await http.get(Uri.parse(
      'https://lanechangebackend.azurewebsites.net/api/getVehicledata/${number.text}'));
  //print ('https://maps.googleapis.com/maps/api/directions/json?origin=$lat,$long&destination=$newLat,$newLong&key=AIzaSyB4_eF-2kgyM_i4l2HICBeWDonF3Su1bjQ');

  return response.body;
}


void makeCall(nummber) async {
  final vehicle = await fetchData(number);
  print(jsonDecode(vehicle)['vehicle']);
  Navigator.push(context,MaterialPageRoute(builder: (context) => GoogleMapScreen(jsonDecode(vehicle)['vehicle']['lat'].toDouble(), jsonDecode(vehicle)['vehicle']['Lng'].toDouble(), jsonDecode(vehicle)['vehicle']['ip'])));
}
  @override
  Widget build( BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Padding(
          padding: const EdgeInsets.all(10.0),

          //mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: numberCon,
                decoration: InputDecoration(
                  hintText: 'Enter plate number'
                ),
              ),
              ElevatedButton(onPressed: () { number = numberCon;
              makeCall(number);},
              child: Text('Send'),
              ),
            ],
          ),
        ),

    ));// This trailing comma makes auto-formatting nicer for build methods
  }
}