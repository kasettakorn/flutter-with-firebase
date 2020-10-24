import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:restaurant/utility/my_style.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class AddInfoShop extends StatefulWidget {
  @override
  _AddInfoShopState createState() => _AddInfoShopState();
}

class _AddInfoShopState extends State<AddInfoShop> {
  double lat, lng;
  String words1, words2, answer;

  @override
  void initState() {
    super.initState();
    // findLatLng();
  }

  Future<void> findLatLng() async {
    LocationData locationData = await findLocationData();
    setState(() {
      lat = locationData.latitude;
      lng = locationData.longitude;
      print(lng);
    });
  }

  Future<dynamic> getText() async {
    var response = await http.get("http://127.0.0.1:5000/nlp/$words1/$words2/");

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed");
    }
  }

  Future<LocationData> findLocationData() async {
    Location location = Location();
    try {
      return location.getLocation();
    } catch (error) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ตรวจสอบคำอ่าน"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            MyStyle().sizedBox(),
            MyStyle().sizedBox(),
            MyStyle().sizedBox(),
            MyStyle().sizedBox(),
            MyStyle().sizedBox(),
            Form("คำที่ 1", Icon(Icons.text_fields)),
            MyStyle().sizedBox(),
            Form("คำที่ 2", Icon(Icons.text_fields)),
            MyStyle().sizedBox(),
//            Form("Shop name", Icon(Icons.account_box)),
//            MyStyle().sizedBox(),
//            Form("Shop address", Icon(Icons.home)),
//            MyStyle().sizedBox(),
//            Form("Shop tel.", Icon(Icons.phone)),
//            groupImages(),
//            MyStyle().sizedBox(),
//            lat == null ? MyStyle().progressIndicator() : showGoogleMap(),
            MyStyle().sizedBox(),
            saveButton()

          ],
        ),
      ),
    );
  }

  Widget saveButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: RaisedButton.icon(
        color: MyStyle().primaryColor,
        onPressed: () async {
          var response = await getText();
          answer = response["words"];
          _handleClickMe();
        },
        icon: Icon(
          Icons.file_upload,
          color: Colors.white,
        ),
        label: Text(
          "ยืนยัน",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Future<void> _handleClickMe() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('ผลการตรวจสอบ'),
          content: Text(answer),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('ตกลง'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  Set<Marker> marker() {
    return <Marker>[
      Marker(
          markerId: MarkerId('mymarker'),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(
            title: 'ร้านของคุณ',
            snippet: 'ละติจูด = $lat, ลองจิจูด = $lng',
          ))
    ].toSet();
  }

  Container showGoogleMap() {
    LatLng latLng = LatLng(lat, lng);
    CameraPosition cameraPosition = CameraPosition(
      target: latLng,
      zoom: 16,
    );

    return Container(
      height: 300,
      child: GoogleMap(
        initialCameraPosition: cameraPosition,
        mapType: MapType.normal,
        onMapCreated: (controller) {},
        markers: marker(),
      ),
    );
  }

  Row groupImages() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
            icon: Icon(
              Icons.add_a_photo,
              size: 36,
            ),
            onPressed: () {}),
        Container(
          width: 250.0,
          child: Image.asset('images/shopImage.png'),
        ),
        IconButton(
            icon: Icon(
              Icons.add_photo_alternate,
              size: 36,
            ),
            onPressed: () {}),
      ],
    );
  }

  Widget Form(labelText, prefixIcon) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              width: 250,
              child: TextField(
                keyboardType: (labelText == "Shop tel.")
                    ? TextInputType.number
                    : TextInputType.text,
                decoration: InputDecoration(
                  labelText: labelText,
                  prefixIcon: prefixIcon,
                  border: OutlineInputBorder(),
                ),
                onChanged: (String value) {
                  if (labelText == "คำที่ 1") {
                    words1 = value;
                  } else {
                    words2 = value;
                  }
                },
              )),
        ],
      );
}
