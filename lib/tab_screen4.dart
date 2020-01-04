import 'dart:io';
import 'dart:math';

import 'package:dove_larry_0_1/splashS.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';

import 'loginS.dart';
import 'mainS.dart';
import 'payment.dart';
import 'registationS.dart';
import 'user.dart';

String urlgetuser = "https://ahmedbawazir.com/flutter/php/get_user.php";
String urluploadImage =
    "https://ahmedbawazir.com/flutter/php/upload_imageprofile.php";
String urlupdate = "https://ahmedbawazir.com/flutter/php/update_profile.php";
File _image;
int number = 0;
String _value;

class TabScreen4 extends StatefulWidget {
  //final String email;
  final User user;

  TabScreen4({this.user});
  static double sliderHeight = 330;
  @override
  _TabScreen4State createState() => _TabScreen4State();
}

class _TabScreen4State extends State<TabScreen4> {
  GlobalKey<RefreshIndicatorState> refreshKey;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  String _currentAddress = "Searching current location...";

  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.black));
    return MaterialApp(
        
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(),
          drawer: Drawer(
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                Container(
                  height: TabScreen4.sliderHeight,
                  child: DrawerHeader(
                    child: ListView(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            SizedBox(
                              height: 5,
                            ),
                            GestureDetector(
                              onTap: _takePicture,
                              child: Container(
                                  width: 150.0,
                                  height: 150.0,
                                  decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.black),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: new NetworkImage(
                                              "https://ahmedbawazir.com/flutter/profile/${widget.user.email}.jpg?dummy=${(number)}'")))),
                            ),
                            SizedBox(height: 5),
                            Row(children: <Widget>[
                              Icon(
                                Icons.person,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Flexible(
                                child: Text(
                                  widget.user.name?.toUpperCase() ??
                                      'Not register',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ]),
                            Row(children: <Widget>[
                              Icon(
                                Icons.email,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Flexible(
                                child: Text(
                                  widget.user.email,
                                  style: TextStyle(
                                    //fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ]),
                            Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.phone_android,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Flexible(
                                      child: Text(
                                        widget.user.phone ?? 'not registered',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.credit_card,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Flexible(
                                      child: Text(
                                        "You have " +
                                                widget.user.credit +
                                                " Credit" ??
                                            "You have 0 Credit",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontStyle: FontStyle.italic,
                                          //    backgroundColor: Colors.black45,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text(
                    "CHANGE NAME",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  onTap: () {
                    _changeName();
                    // ...
                  },
                ),
                ListTile(
                  leading: Icon(Icons.lock),
                  title: Text(
                    "CHANGE PASSWORD",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  onTap: () {
                    _changePassword(); // ...
                  },
                ),
                ListTile(
                  leading: Icon(Icons.phone),
                  title: Text(
                    "CHANGE PHONE",
                    style: TextStyle(
                        fontStyle: FontStyle.italic, color: Colors.blue[20]),
                  ),
                  onTap: () {
                    _changePhone();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.rounded_corner),
                  title: Text(
                    "CHANGE RADIUS",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  onTap: () {
                    _changeRadius(); // ...
                  },
                ),
                ListTile(
                  leading: Icon(Icons.credit_card),
                  title: Text(
                    "BUY CREDIT",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  onTap: () {
                    _loadPayment();
                    // ...
                  },
                ),
                ListTile(
                  leading: Icon(Icons.input),
                  title: Text(
                    'REGISTER',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  onTap: () {
                    _registerAccount();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.subdirectory_arrow_right),
                  title: Text(
                    "LOG IN",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  onTap: () {
                    _gotologinPage();
                    // ...
                  },
                ),
                ListTile(
                  leading: Icon(Icons.subdirectory_arrow_left),
                  title: Text(
                    "LOG OUT",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  onTap: () {
                    _gotologout();
                    // ...
                  },
                ),
               
              ],
            ),
          ),
          body: ListView.builder(
              //Step 6: Count the data
              itemCount: 5,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Container(
                    child: Column(
                      children: <Widget>[
                        Stack(children: <Widget>[
                          Image.asset(
                            "assets/images/blur2.png",
                            fit: BoxFit.fill,
                            height: 495,
                          ),
                          Column(
                            children: <Widget>[
                              SizedBox(
                                height: 15,
                              ),
                              Center(
                                child: Text("Dove Lorry",
                                    style: TextStyle(
                                        fontSize: 35,
                                        fontStyle: FontStyle.italic,
                                        //     backgroundColor: Colors.black45,////
                                        color: Colors.lightBlue[100])),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              GestureDetector(
                                onTap: _takePicture,
                                child: Container(
                                    width: 280.0,
                                    height: 280.0,
                                    decoration: new BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.black),
                                        image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: new NetworkImage(
                                                "https://ahmedbawazir.com/flutter/profile/${widget.user.email}.jpg?dummy=${(number)}'")))),
                              ),
                              SizedBox(height: 5),
                              Container(
                                child: Text(
                                  widget.user.name?.toUpperCase() ??
                                      'Not register',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 25,
                                    color: Colors.white,
                                    //     backgroundColor: Colors.black45,
                                  ),
                                ),
                              ),
                              /*  Container(
                                child: Text(
                                  widget.user.email,
                                  style: TextStyle(
                                    //fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 17,
                                    color: Colors.white,
                                //    backgroundColor: Colors.black45,
                                  ),
                                ),
                              ),*/
                              /*    Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.phone_android,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        widget.user.phone ?? 'not registered',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontStyle: FontStyle.italic,
                                       //   backgroundColor: Colors.black45,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),*/
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.rate_review,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  RatingBar(
                                    itemCount: 5,
                                    itemSize: 15,
                                    initialRating: double.parse(
                                        widget.user.rating.toString() ?? 0.0),
                                    itemPadding:
                                        EdgeInsets.symmetric(horizontal: 2.0),
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.rounded_corner,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                      width: 5,
                                    ),
                                      Text(
                                        "Books Radius " +
                                                widget.user.radius +
                                                "KM" ??
                                            'Book Radius 0 KM',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
                                          fontStyle: FontStyle.italic,
                                          //    backgroundColor: Colors.black45,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.credit_card,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Flexible(
                                        child: Text(
                                          "You have " +
                                                  widget.user.credit +
                                                  " Credit" ??
                                              "You have 0 Credit",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                            fontStyle: FontStyle.italic,
                                            //    backgroundColor: Colors.black45,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Flexible(
                                      child: Text(
                                        _currentAddress,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontStyle: FontStyle.italic,
                                          //     backgroundColor: Colors.black45,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                color: Colors.blue,
                                child: Center(
                                  child: Text("My Profile ",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.white)),
                                ),
                              ),
                            ],
                          ),
                        ]),
                        SizedBox(
                          height: 0,
                        ),
                      ],
                    ),
                  );
                }

                if (index == 1) {
                  return Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        /*   MaterialButton(
                          onPressed: _changeName,
                          child: Text(
                            "CHANGE NAME",
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                        MaterialButton(
                          onPressed: _changePassword,
                          child: Text(
                            "CHANGE PASSWORD",
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                        MaterialButton(
                          onPressed: _changePhone,
                          child: Text(
                            "CHANGE PHONE",
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                        MaterialButton(
                          onPressed: _changeRadius,
                          child: Text(
                            "CHANGE RADIUS",
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                        MaterialButton(
                          onPressed: _loadPayment,
                          child: Text(
                            "BUY CREDIT",
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                        MaterialButton(
                          onPressed: _registerAccount,
                          child: Text(
                            "REGISTER",
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                        MaterialButton(
                          onPressed: _gotologinPage,
                          child: Text(
                            "LOG IN",
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),*/
                        SizedBox(height: 20),
                        Expanded(
                          child: RaisedButton(
                            onPressed: _gotologinPage,
                            child: Text(
                              "LOG IN",
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }),
        ));
  }

  void _takePicture() async {
    if (widget.user.name == "not register") {
      Toast.show("Not allowed please register", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Take new profile picture?",
            style: TextStyle(
              fontStyle: FontStyle.italic,
            ),
          ),
          content: new Text(
            "Are your sure?",
            style: TextStyle(
              fontStyle: FontStyle.italic,
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop();

                /////////////////////////////////////////////////

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    // return object of type Dialog
                    return AlertDialog(
                      title: new Text(
                        "Take  profile picture?",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            // usually buttons at the bottom of the dialog
                            new FlatButton(
                              child: new Text(
                                "Camera",
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              onPressed: () async {
                                Navigator.of(context).pop();
                                _image = await ImagePicker.pickImage(
                                    source: ImageSource.camera);
                              },
                            ),
                            new FlatButton(
                              child: new Text(
                                "Gallery",
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              onPressed: () async {
                                Navigator.of(context).pop();

                                _image = await ImagePicker.pickImage(
                                    source: ImageSource.gallery);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );

                ///////////////////

                String base64Image = base64Encode(_image.readAsBytesSync());
                http.post(urluploadImage, body: {
                  "encoded_string": base64Image,
                  "email": widget.user.email,
                }).then((res) {
                  print(res.body);
                  if (res.body == "success") {
                    setState(() {
                      number = new Random().nextInt(100);
                      print(number);
                    });
                  } else {}
                }).catchError((err) {
                  print(err + 'hgfjhghgf');
                });
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _getCurrentLocation() async {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        print(_currentPosition);
      });
      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.name},${place.locality}, ${place.postalCode}, ${place.country}";
        //load data from database into list array 'data'
      });
    } catch (e) {
      print(e);
    }
  }

  void _changeRadius() {
    if (widget.user.name == "not register") {
      Toast.show("Not allowed please register", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    TextEditingController radiusController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Change new Radius (km)?",
            style: TextStyle(
              fontStyle: FontStyle.italic,
            ),
          ),
          content: new TextField(
              keyboardType: TextInputType.number,
              controller: radiusController,
              decoration: InputDecoration(
                /////
                labelText: 'new radius',
                labelStyle: TextStyle(
                  fontStyle: FontStyle.italic,
                ),
                icon: Icon(Icons.map),
              )),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
              onPressed: () {
                if (radiusController.text.length < 1) {
                  Toast.show("Please enter new radius ", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  return;
                }
                http.post(urlupdate, body: {
                  "email": widget.user.email,
                  "radius": radiusController.text,
                }).then((res) {
                  var string = res.body;
                  List dres = string.split(",");
                  if (dres[0] == "success") {
                    setState(() {
                      widget.user.radius = dres[4];
                      Toast.show("Success ", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                      Navigator.of(context).pop();
                      return;
                    });
                  } else {}
                }).catchError((err) {
                  print(err);
                });
                Toast.show("Failed ", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _changeName() {
    TextEditingController nameController = TextEditingController();
    // flutter defined function

    if (widget.user.name == "not register") {
      Toast.show("Not allowed please register", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Change name for " + widget.user.name + "?",
            style: TextStyle(
              fontStyle: FontStyle.italic,
            ),
          ),
          content: new TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(
                  fontStyle: FontStyle.italic,
                ),
                icon: Icon(Icons.person),
              )),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
              onPressed: () {
                if (nameController.text.length < 5) {
                  Toast.show(
                      "Name should be more than 5 characters long", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  return;
                }
                http.post(urlupdate, body: {
                  "email": widget.user.email,
                  "name": nameController.text,
                }).then((res) {
                  var string = res.body;
                  List dres = string.split(",");
                  if (dres[0] == "success") {
                    print('in success');
                    setState(() {
                      widget.user.name = dres[1];
                    });
                    Toast.show("Success", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                    Navigator.of(context).pop();
                    return;
                  } else {}
                }).catchError((err) {
                  print(err);
                });
                Toast.show("Failed", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _changePassword() {
    TextEditingController passController = TextEditingController();
    // flutter defined function
    print(widget.user.name);
    if (widget.user.name == "not register") {
      Toast.show("Not allowed please register", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Change Password for " + widget.user.name,
            style: TextStyle(
              fontStyle: FontStyle.italic,
            ),
          ),
          content: new TextField(
            controller: passController,
            decoration: InputDecoration(
              labelText: 'New Password',
              labelStyle: TextStyle(
                fontStyle: FontStyle.italic,
              ),
              icon: Icon(Icons.lock),
            ),
            obscureText: true,
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
              onPressed: () {
                if (passController.text.length < 5) {
                  Toast.show("Password too short", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  return;
                }
                http.post(urlupdate, body: {
                  "email": widget.user.email,
                  "password": passController.text,
                }).then((res) {
                  var string = res.body;
                  List dres = string.split(",");
                  if (dres[0] == "success") {
                    print('in success');
                    setState(() {
                      widget.user.name = dres[1];
                      if (dres[0] == "success") {
                        Toast.show("Success", context,
                            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                        savepref(passController.text);
                        Navigator.of(context).pop();
                      }
                    });
                  } else {}
                }).catchError((err) {
                  print(err);
                });
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _changePhone() {
    TextEditingController phoneController = TextEditingController();
    // flutter defined function
    print(widget.user.name);
    if (widget.user.name == "not register") {
      Toast.show("Not allowed please register", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Change phone for" + widget.user.name,
            style: TextStyle(
              fontStyle: FontStyle.italic,
            ),
          ),
          content: new TextField(
              keyboardType: TextInputType.phone,
              controller: phoneController,
              decoration: InputDecoration(
                labelText: 'phone',
                labelStyle: TextStyle(
                  fontStyle: FontStyle.italic,
                ),
                icon: Icon(Icons.phone),
              )),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
              onPressed: () {
                if (phoneController.text.length < 5) {
                  Toast.show("Please enter correct phone number", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  return;
                }
                http.post(urlupdate, body: {
                  "email": widget.user.email,
                  "phone": phoneController.text,
                }).then((res) {
                  var string = res.body;
                  List dres = string.split(",");
                  if (dres[0] == "success") {
                    setState(() {
                      widget.user.phone = dres[3];
                      Toast.show("Success ", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                      Navigator.of(context).pop();
                      return;
                    });
                  }
                }).catchError((err) {
                  print(err);
                });
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _registerAccount() {
    TextEditingController phoneController = TextEditingController();
    // flutter defined function
    print(widget.user.name);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Register new account?",
            style: TextStyle(
              fontStyle: FontStyle.italic,
            ),
          ),
          content: new Text(
            "Are your sure?",
            style: TextStyle(
              fontStyle: FontStyle.italic,
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                print(
                  phoneController.text,
                );
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Register()));
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _gotologinPage() {
    // flutter defined function
    print(widget.user.name);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Go to login page?" + widget.user.name,
            style: TextStyle(
              fontStyle: FontStyle.italic,
            ),
          ),
          content: new Text(
            "Are your sure?",
            style: TextStyle(
              fontStyle: FontStyle.italic,
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginPage()));
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _gotologout() async {
    // flutter defined function
    if (widget.user.name == "not register") {
      Toast.show("You Must Have Account !!", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    print(widget.user.name);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Logout of account " + widget.user.name,
            style: TextStyle(
              fontStyle: FontStyle.italic,
            ),
          ),
          content: new Text(
            "Are your sure?",
            style: TextStyle(
              fontStyle: FontStyle.italic,
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString('email', '');
                await prefs.setString('pass', '');
                print("LOGOUT");
                Navigator.pop(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => MainScreen()));
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void savepref(String pass) async {
    print('Inside savepref');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('pass', pass);
  }

  void _loadPayment() async {
    // flutter defined function
    if (widget.user.name == "not register") {
      Toast.show("Not allowed please register", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Buy Credit?",
            style: TextStyle(
              fontStyle: FontStyle.italic,
            ),
          ),
          content: Container(
            height: 100,
            child: DropdownExample(),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
              onPressed: () async {
                /*   if (DropdownExample != null) {
                  Toast.show("Please Select Credit ", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);}
                */
                Navigator.of(context).pop();
                var now = new DateTime.now();
                var formatter = new DateFormat('ddMMyyyyhhmmss-');
                String formatted =
                    formatter.format(now) + randomAlphaNumeric(10);
                print(formatted);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PaymentScreen(
                            user: widget.user,
                            orderid: formatted,
                            val: _value)));
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

 
}

class DropdownExample extends StatefulWidget {
  @override
  _DropdownExampleState createState() {
    return _DropdownExampleState();
  }
}

class _DropdownExampleState extends State<DropdownExample> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: DropdownButton<String>(
        items: [
          DropdownMenuItem<String>(
            child: Text(
              '50 HCredit (RM10)',
              style: TextStyle(
                fontStyle: FontStyle.italic,
              ),
            ),
            value: '10',
          ),
          DropdownMenuItem<String>(
            child: Text(
              '100 HCredit (RM20)',
              style: TextStyle(
                fontStyle: FontStyle.italic,
              ),
            ),
            value: '20',
          ),
          DropdownMenuItem<String>(
            child: Text(
              '150 HCredit (RM30)',
              style: TextStyle(
                fontStyle: FontStyle.italic,
              ),
            ),
            value: '30',
          ),
        ],
        onChanged: (String value) {
          setState(() {
            _value = value;
          });
        },
        hint: Text(
          'Select Credit',
          style: TextStyle(
            fontStyle: FontStyle.italic,
          ),
        ),
        value: _value,
      ),
    );
  }
}
