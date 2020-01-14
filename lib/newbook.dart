import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:place_picker/place_picker.dart';
import 'package:image_picker/image_picker.dart';

import 'mainS.dart';
import 'user.dart';

File _image;
String pathAsset = 'assets/images/add.png';
String urlUpload = "https://ahmedbawazir.com/flutter/php/upload_book.php";
String urlgetuser = "https://ahmedbawazir.com/flutter/php/get_user.php";

TextEditingController _bookcontroller = TextEditingController();
final TextEditingController _desccontroller = TextEditingController();
final TextEditingController _pricecontroller = TextEditingController();
final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
Position _currentPosition;
String _currentAddress = "Searching your current location...";

class NewBook extends StatefulWidget {
  final User user;

  const NewBook({Key key, this.user}) : super(key: key);

  @override
  _NewBookbState createState() => _NewBookbState();
}

class _NewBookbState extends State<NewBook> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
          //resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: Text(
              'ADD NEW BOOK',
              style: TextStyle(
                fontStyle: FontStyle.italic,
              ),
            ),
            backgroundColor: Colors.blue,
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
              child: CreateNewBook(widget.user),
            ),
          )),
    );
  }

  Future<bool> _onBackPressAppBar() async {
    Navigator.pop(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(
            user: widget.user,
          ),
        ));
    return Future.value(false);
  }
}

class CreateNewBook extends StatefulWidget {
  final User user;
  CreateNewBook(this.user);

  @override
  _CreateNewBookState createState() => _CreateNewBookState();
}

class _CreateNewBookState extends State<CreateNewBook> {
  String defaultValue = 'Pickup';
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
            onTap: _choose,
            child: Container(
              width: 350,
              height: 200,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image:
                    _image == null ? AssetImage(pathAsset) : FileImage(_image),
                fit: BoxFit.fill,
              )),
            )),
        Text(
          'Click on image above to take BOOl picture',
          style: TextStyle(
            fontStyle: FontStyle.italic,
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              new IconButton(
                  iconSize: 40,
                  icon: new Icon(Icons.directions_bike),
                  onPressed: _changebook),
              new IconButton(
                  iconSize: 40,
                  icon: new Icon(Icons.fastfood),
                  onPressed: _changeFood),
              new IconButton(
                  iconSize: 40,
                  icon: new Icon(Icons.code),
                  onPressed: _programer),
              new IconButton(
                  iconSize: 40,
                  icon: new Icon(Icons.code),
                  onPressed: _pphDevelper),
              new IconButton(
                  iconSize: 40, icon: new Icon(Icons.book), onPressed: _novels),
              new IconButton(
                  iconSize: 40,
                  icon: new Icon(Icons.book),
                  onPressed: _storis),
              new IconButton(
                  iconSize: 40,
                  icon: new Icon(Icons.book),
                  onPressed: _bookM),
              new IconButton(
                  iconSize: 40,
                  icon: new Icon(Icons.build),
                  onPressed: _bookA),
            ],
          ),
        ),
        TextField(
            controller: _bookcontroller,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Book Title',
              labelStyle: TextStyle(
                              fontStyle: FontStyle.italic,
                            ),
              icon: Icon(Icons.title),
            )),
        TextField(
            controller: _pricecontroller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Book Price',labelStyle: TextStyle(
                              fontStyle: FontStyle.italic,
                            ),
              icon: Icon(Icons.attach_money),
            )),
        TextField(
            controller: _desccontroller,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.previous,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Book Description',
              labelStyle: TextStyle(
                              fontStyle: FontStyle.italic,
                            ),
              icon: Icon(Icons.info),
            )),
        SizedBox(
          height: 5,
        ),
        GestureDetector(
            onTap: _loadmap,
            child: Container(
              alignment: Alignment.topLeft,
              child: Text("Book Location",
                  style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 14
                            ),),
            )),
        SizedBox(
          height: 5,
        ),
        Row(
          children: <Widget>[
            Icon(Icons.location_searching),
            SizedBox(
              width: 10,
            ),
            Flexible(
              child: Text(_currentAddress,style: TextStyle(
                              fontStyle: FontStyle.italic,
                            ),),
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
        MaterialButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          minWidth: 300,
          height: 50,
          child: Text('Add New Book'),
          color: Colors.blue,
          textColor: Colors.white,
          elevation: 15,
          onPressed: _onAddbook,
        ),
      ],
    );
  }

  void _choose() async {
    //  _image =await ImagePicker.pickImage(source: ImageSource.camera, maxHeight: 400);
    setState(() {});
    // _image = await ImagePicker.pickImage(source: ImageSource.gallery);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Take  profile picture?"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                // usually buttons at the bottom of the dialog
                new FlatButton(
                  child: new Text("Camera"),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    _image = await ImagePicker.pickImage(
                        source: ImageSource.camera, maxHeight: 400);
                  },
                ),
                new FlatButton(
                  child: new Text("Gallery"),
                  onPressed: () async {
                    Navigator.of(context).pop();

                    _image = await ImagePicker.pickImage(
                        source: ImageSource.gallery, maxHeight: 400);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onAddbook() {
    if (_image == null) {
      Toast.show("Please take picture", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (_bookcontroller.text.isEmpty) {
      Toast.show("Please enter book title", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (_pricecontroller.text.isEmpty) {
      Toast.show("Please enter book price", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Adding...");
    pr.show();
    String base64Image = base64Encode(_image.readAsBytesSync());
    print(_currentPosition.latitude.toString() +
        "/" +
        _currentPosition.longitude.toString());

    http.post(urlUpload, body: {
      "encoded_string": base64Image,
      "email": widget.user.email,
      "booktitle": _bookcontroller.text,
      "bookdesc": _desccontroller.text,
      "bookprice": _pricecontroller.text,
      "latitude": _currentPosition.latitude.toString(),
      "longitude": _currentPosition.longitude.toString(),
      "credit": widget.user.credit,
      "rating": widget.user.rating
    }).then((res) {
      print(urlUpload);

      ///  print("kjhkj");
      Toast.show(res.body, context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      if (res.body.contains("success")) {
        _image = null;
        _bookcontroller.text = "";
        _pricecontroller.text = "";
        _desccontroller.text = "";
        pr.dismiss();
        print(widget.user.email);
        _onLogin(widget.user.email, context);
      } else {
        pr.dismiss();
        Toast.show(res.body + ". Please reload", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
  }

  _getCurrentLocation() async {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        // print(_getCurrentLocation);
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
      });
    } catch (e) {
      print(e);
    }
  }

  void _onLogin(String email, BuildContext ctx) {
    http.post(urlgetuser, body: {
      "email": email,
    }).then((res) {
      print(res.statusCode);
      var string = res.body;
      List dres = string.split(",");
      print(dres);
      if (dres[0] == "success") {
        User user = new User(
            name: dres[1],
            email: dres[2],
            phone: dres[3],
            radius: dres[4],
            credit: dres[5],
            rating: dres[6]);
        Navigator.push(ctx,
            MaterialPageRoute(builder: (context) => MainScreen(user: user)));
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _loadmap() async {
    LocationResult result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            PlacePicker("AIzaSyAvIHhXiQ7TxWE2L7WY_qP2WpBDrR7TWHk")));

    // Handle the result in your way
    print("MAP SHOW:");
    print(result);
  }

  void _changebook() {
    _bookcontroller.text = "Sport";
  }
 
  void _changeFood() {
    _bookcontroller.text = "How to cook";
  }

  void _programer() {
    _bookcontroller.text = "Learn Java";
  }

  void _pphDevelper() {
    _bookcontroller.text = "PHP code";
  }

  void _storis() {
    _bookcontroller.text = "The Hunger Games";
  }

  void _novels() {
    _bookcontroller.text = "You and  Me and US";
  }

  void _bookM() {
    _bookcontroller.text = "The Book Of Magic";
  }

  void _bookA() {
    _bookcontroller.text = "The Car Fix-Up Book";
  }
}
