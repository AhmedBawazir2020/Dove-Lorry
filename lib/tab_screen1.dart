import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'package:http/http.dart' as http;

import 'book_detail.dart';
import 'book.dart';
import 'slide_right_route.dart';
import 'user.dart';


double perpage = 1;

class TabScreen extends StatefulWidget {
  final User user;

  TabScreen({Key key, this.user});

  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  GlobalKey<RefreshIndicatorState> refreshKey;

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  String _currentAddress = "Searching current location...";
  List data;

  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    
   SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.blue));
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        
        home: Scaffold(
            resizeToAvoidBottomPadding: false,
           
            body: RefreshIndicator(
              key: refreshKey,
              color: Colors.blue,
              onRefresh: () async {
                await refreshList();
              },
              child: ListView.builder(
                  //Step 6: Count the data
                  itemCount: data == null ? 1 : data.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Container(
                        child: Column(
                          children: <Widget>[
                            Stack(children: <Widget>[
                              Image.asset(
                                "assets/images/bg.png",
                            fit: BoxFit.fitWidth,
                            
                              ),
                              Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Center(
                                    child: Text("Dove Lorry",
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontSize: 25,
                                            color: Colors.blue[100])),
                                  ),
                                  SizedBox(height: 5),
                                  Container(
                                    width: 320,
                                    height: 130,
                                    child: Card(
                                      color: Colors.lightBlue[50].withOpacity(0.70),
                                      child: Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Icon(Icons.person,
                                                    ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    widget.user.name
                                                            .toUpperCase() ??
                                                        "Not registered",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Icon(Icons.location_on,
                                                    ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Flexible(
                                                  child: Text(_currentAddress,
                                                   style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                    ),),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Icon(Icons.rounded_corner,
                                                    ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Flexible(
                                                  child: Text(
                                                      "Book Radius within " +
                                                          widget.user.radius +
                                                          " KM", style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                    ),),
                                                ),
                                              ],
                                            ),
                                         /*   Row(
                                              children: <Widget>[
                                                Icon(Icons.credit_card,
                                                  ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Flexible(
                                                  child: Text("You have " +
                                                      widget.user.credit +
                                                      " Credit", style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                    ),),
                                                ),
                                              ],
                                            ),*/
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                            SizedBox(
                              height: 1.5,
                            ),
                            Container(
                              color: Colors.blue,
                              child: Center(
                                child: Text("Books Available Today",
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 17,
                                        color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    if (index == data.length && perpage > 1) {
                      return Container(
                        width: 250,
                        color: Colors.white,
                        child: MaterialButton(
                          child: Text(
                            "Load More",
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () {},
                        ),
                      );
                    }
                    index -= 1;
                    return Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Card(
                        color: Colors.blue[50],//color item
                        elevation: 5,
                        child: InkWell(
                          onTap: () => _onBookDetail(
                            data[index]['bookid'],
                            data[index]['bookprice'],
                            data[index]['bookdesc'],
                            data[index]['bookowner'],
                            data[index]['bookimage'],
                            data[index]['booktime'],
                            data[index]['booktitle'],
                            data[index]['booklatitude'],
                            data[index]['booklongitude'],
                            data[index]['bookrating'],
                            widget.user.radius,
                            widget.user.name,
                            widget.user.credit,
                          ),
                          onLongPress: _onBookDelete,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                      border: Border.all(color: Colors.black),
                                      image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(
                                    "https://ahmedbawazir.com/flutter/images/${data[index]['bookimage']}.jpg"
                                  )))),
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                            data[index]['booktitle']
                                                .toString()
                                                .toUpperCase(),
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                        RatingBar(
                                          itemCount: 5,
                                          itemSize: 12,
                                          initialRating: double.parse(data[index]['bookrating']
                                                .toString()),
                                          itemPadding: EdgeInsets.symmetric(
                                              horizontal: 2.0),
                                          itemBuilder: (context, _) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text("RM " + data[index]['bookprice'],
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                          ),),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(data[index]['booktime'],
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                          ),),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            )));
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
        init(); //load data from database into list array 'data'
      });
    } catch (e) {
      print(e);
    }
  }

  Future<String> makeRequest() async {
    String _onBookDetail = "https://ahmedbawazir.com/flutter/php/load_books.php";
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Loading Books");
    pr.show();
    http.post(_onBookDetail, body: {
      "email": widget.user.email ?? "notavail",
      "latitude": _currentPosition.latitude.toString(),
      "longitude": _currentPosition.longitude.toString(),
      "radius": widget.user.radius ?? "10",
    }).then((res) {
      setState(() {
        var extractdata = json.decode(res.body);
        data = extractdata["books"];
        perpage = (data.length / 10);
        print("data");
        print(data);
        pr.dismiss();
      });
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
    return null;
  }

  Future init() async {
    this.makeRequest();
    //_getCurrentLocation();
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    this.makeRequest();
    return null;
  }

  

  void _onBookDetail(
      String bookid,
      String bookprice,
      String bookdesc,
      String bookowner,
      String bookimage,
      String booktime,
      String booktitle,
      String booklatitude,
      String booklongitude,
      String bookrating,
      String email,
      String name,
      String credit) {
    BOOK book = new BOOK(
        bookid: bookid,
        booktitle: booktitle,
        bookowner: bookowner,
        bookdes: bookdesc,
        bookprice: bookprice,
        booktime: booktime,
        bookimage: bookimage,
        bookworker: null,
        booklat: booklatitude,
        booklon: booklongitude,
        bookrating:bookrating );
    //print(data);
    
    Navigator.push(context, SlideRightRoute(page: BookDetail(book: book, user: widget.user)));
  }

  void _onBookDelete() {
    print("Delete");
  }
}

