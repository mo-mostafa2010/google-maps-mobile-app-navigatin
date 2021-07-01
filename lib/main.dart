import 'package:app/screens/google_map_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Map',
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
      home: LocationonApp(),
    );
  }
}

class LocationonApp extends StatefulWidget {
  @override
  _LocationonAppState createState() => _LocationonAppState();
}

class _LocationonAppState extends State<LocationonApp> {
  var locationMessage = "";
  var lat ;
  var long;  
  void getCurrentLocation() async {
    var position = await Geolocator.getCurrentPosition (desiredAccuracy: LocationAccuracy.high);
    var lastPosition = await Geolocator.getLastKnownPosition();
    print (position);
    print(lastPosition); 
     lat = position.latitude;
     long = position.longitude;
    print("$lat , $long");


    setState(() {
      locationMessage = "Latitude : $lat , Logitude : $long";
    }); 
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
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Google Map Demo',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold
              )
            ),
            SizedBox(
              height: 10.0,
            ),
           
            SizedBox(height: 20,),
            Text ("Position : $locationMessage"),
            ElevatedButton(
              onPressed: (){
                getCurrentLocation();
              },
              child: Text('Get Current Location'),              
            ),


          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GoogleMapScreen(lat,long),
          ),
        ),
        tooltip: 'Increment',
        child: Icon(Icons.pin_drop_outlined),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}