import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'details_book.dart';
import 'book.dart';
import 'newbook.dart';
import 'slide_right_route.dart';
import 'user.dart';

double perpage = 1;

class TabScreen2 extends StatefulWidget {
  final User user;

  TabScreen2({Key key, this.user});

  @override
  _TabScreen2State createState() => _TabScreen2State();
}

class _TabScreen2State extends State<TabScreen2> {
  GlobalKey<RefreshIndicatorState> refreshKey;

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  String _currentAddress = "Searching current location...";
  List data;

  @override
  void initState() {
    super.initState();
    //init();
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
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              backgroundColor: Colors.blue[300],
              elevation: 2.0,
              onPressed: requestNewBook,
              tooltip: 'Request new help',
            ),
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
                                     color: Colors.lightBlue[50].withOpacity(0.70),/// color: Colors.lightBlue[50],///
                                      child: Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.person,
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
                                                Icon(
                                                  Icons.location_on,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    _currentAddress,
                                                    style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.rounded_corner,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    "Book Radius within " +
                                                        widget.user.radius +
                                                        " KM",
                                                    style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                        /*    Row(
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
                                                        " Credit",
                                                    style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                    ),
                                                  ),
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
                                child: Text("Your Posted Books ",
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
                        color: Colors.blue[50],
                        elevation: 5,
                        child: InkWell(
                          ///////////////////////////////////////
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
                          /////////////////////////////////////////
                          onLongPress: () => _onBookDelete(
                              data[index]['bookid'].toString(),
                              data[index]['booktitle'].toString()),
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
                                                "https://ahmedbawazir.com/flutter/images/${data[index]['bookimage']}.jpg")))),
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
                                          initialRating: double.parse(
                                              data[index]['bookrating']
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
                                        Text(
                                          "RM " + data[index]['bookprice'],
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          data[index]['booktime'],
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
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
    String urlLoadBooks =
        "https://ahmedbawazir.com/flutter/php/load_book_user.php";
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false); //progress
    pr.style(
      message: "Loading All Posted Books",
    );
    pr.show();
    http.post(urlLoadBooks, body: {
      "email": widget.user.email ?? "notavail",
    }).then((res) {
      // print(res.body);
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
    if (widget.user.email == "user@noregister") {
      Toast.show("Please register to view posted books", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else {
      this.makeRequest();
    }
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    this.makeRequest();
    return null;
  }

  void requestNewBook() {
    print(widget.user.email);
    if (widget.user.email != "user@noregister") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => NewBook(
                    user: widget.user,
                  )));
    } else {
      Toast.show("Please Register First to request new books", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      //RegisterScreen
    }
  }

  void _onBookDelete(String bookid, String bookname) {
    print("Delete " + bookid);
    _showDialog(bookid, bookname);
  }

  void _showDialog(String bookid, String bookname) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Delete " + bookname,
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
                deleteRequest(bookid);
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

  Future<String> deleteRequest(String bookid) async {
    String urlLoadBooks = "https://ahmedbawazir.com/flutter/php/delete_book.php";
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Deleting Books");
    pr.show();
    http.post(urlLoadBooks, body: {
      "bookid": bookid,
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show("Success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        init();
      } else {
        Toast.show("Failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
    return null;
  }

  /////////////////
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
        bookrating: bookrating);
    //print(data);

    Navigator.push(
        context, SlideRightRoute(page: EditBook(book: book, user: widget.user)));
  }
//////////////////////
}

class SlideMenu extends StatefulWidget {
  final Widget child;
  final List<Widget> menuItems;

  SlideMenu({this.child, this.menuItems});

  @override
  _SlideMenuState createState() => new _SlideMenuState();
}

class _SlideMenuState extends State<SlideMenu>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  initState() {
    super.initState();
    _controller = new AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animation = new Tween(
            begin: const Offset(0.0, 0.0), end: const Offset(-0.2, 0.0))
        .animate(new CurveTween(curve: Curves.decelerate).animate(_controller));

    return new GestureDetector(
      onHorizontalDragUpdate: (data) {
        // we can access context.size here
        setState(() {
          _controller.value -= data.primaryDelta / context.size.width;
        });
      },
      onHorizontalDragEnd: (data) {
        if (data.primaryVelocity > 2500)
          _controller
              .animateTo(.0); //close menu on fast swipe in the right direction
        else if (_controller.value >= .5 ||
            data.primaryVelocity <
                -2500) // fully open if dragged a lot to left or on fast swipe to left
          _controller.animateTo(1.0);
        else // close if none of above
          _controller.animateTo(.0);
      },
      child: new Stack(
        children: <Widget>[
          new SlideTransition(position: animation, child: widget.child),
          new Positioned.fill(
            child: new LayoutBuilder(
              builder: (context, constraint) {
                return new AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return new Stack(
                      children: <Widget>[
                        new Positioned(
                          right: .0,
                          top: .0,
                          bottom: .0,
                          width: constraint.maxWidth * animation.value.dx * -1,
                          child: new Container(
                            color: Colors.black26,
                            child: new Row(
                              children: widget.menuItems.map((child) {
                                return new Expanded(
                                  child: child,
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
