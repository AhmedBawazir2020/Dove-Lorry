import 'dart:async';

import 'package:dove_larry_0_1/book.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'book.dart';
import 'mainS.dart';
import 'user.dart';

class Acceptbook extends StatefulWidget {
  final BOOK book;
  final User user;

  const Acceptbook({Key key, this.book, this.user}) : super(key: key);

  @override
  _Acceptbook createState() => _Acceptbook();
}

class _Acceptbook extends State<Acceptbook> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.blue));
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: Text('ACCEPT BOOK'),
            backgroundColor: Colors.blue,
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
              child: AcceptInterface(
                book: widget.book,
                user: widget.user,
              ),
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

class AcceptInterface extends StatefulWidget {
  final BOOK book;
  final User user;
  AcceptInterface({this.book, this.user});

  @override
  _AcceptInterfaceState createState() => _AcceptInterfaceState();
}

class _AcceptInterfaceState extends State<AcceptInterface> {
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _myLocation;

  @override
  void initState() {
    super.initState();
    _myLocation = CameraPosition(
      target: LatLng(
          double.parse(widget.book.booklat), double.parse(widget.book.booklon)),
      zoom: 17,
    );
    print(_myLocation.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Center(),
        Container(
          width: 280,
          height: 200,
          child: Image.network(
              'https://ahmedbawazir.com/flutter/images/${widget.book.bookimage}.jpg',
              fit: BoxFit.fill),
        ),
        SizedBox(
          height: 10,
        ),
        Text(widget.book.booktitle.toUpperCase(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            )),
        Text(
          widget.book.booktime,
          style: TextStyle(
            fontStyle: FontStyle.italic,
          ),
        ),
        Container(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 5,
              ),
              Table(children: [
                TableRow(children: [
                  Text("Book Description",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    widget.book.bookdes,
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ]),
                TableRow(children: [
                  Text("Book Price",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    "RM" + widget.book.bookprice,
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ]),
                TableRow(children: [
                  Text("Book Location",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("")
                ]),
              ]),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 120,
                width: 340,
                child: GoogleMap(
                  // 2
                  initialCameraPosition: _myLocation,
                  // 3
                  mapType: MapType.normal,
                  // 4

                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
                 color: Colors.black,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: 350,
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  height: 40,
                  child: Text(
                    'ACCEPT BOOK',
                    style: TextStyle(fontSize: 16),
                  ),
                  color: Colors.blue,
                  textColor: Colors.white,
                  elevation: 5,
                  onPressed: _onAcceptBook,
                ),
                //MapSample(),
              )
            ],
          ),
        ),
      ],
    );
  }

  void _onAcceptBook() {
    if (widget.user.email == "user@noregister") {
      Toast.show("Please register to accept books", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else {
      _showDialog();
    }
    print("Accept Book");
  }

  void _showDialog() {
    // flutter defined function
    if (int.parse(widget.user.credit) < 1) {
      Toast.show("Credit not enough ", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Accept " + widget.book.booktitle,
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
              child: new Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                acceptRequest();
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

  Future<String> acceptRequest() async {
    String urlLoadBooks = "https://ahmedbawazir.com/flutter/php/accept_book.php";
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Accepting Book");
    pr.show();
    http.post(urlLoadBooks, body: {
      "bookid": widget.book.bookid,
      "email": widget.user.email,
      "credit": widget.user.credit,
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show("Success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        pr.dismiss();
        _onLogin(widget.user.email, context);
      } else {
        Toast.show("Failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        pr.dismiss();
      }
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
    return null;
  }

  void _onLogin(String email, BuildContext ctx) {
    String urlgetuser = "https://ahmedbawazir.com/flutter/php/get_user.php";

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
}
