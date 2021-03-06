import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:glug_app/resources/firestore_provider.dart';
import 'package:glug_app/screens/login_screen.dart';
import 'package:glug_app/screens/profile_edit_screen.dart';
import 'package:glug_app/services/auth_service.dart';
import 'package:glug_app/widgets/drawer_items.dart';
import 'package:glug_app/widgets/error_widget.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  FirestoreProvider _provider;

  @override
  void initState() {
    _provider = FirestoreProvider();
    super.initState();
  }

  @override
  void dispose() {
    _provider = null;
    super.dispose();
  }

  _buildEventsWidget(List<dynamic> events) {
    List<Widget> dataWidget;
    dataWidget = events.map((data) {
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Center(
          child: Text(
            data["name"] + " ",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: "Montserrat",
              fontSize: 12.0,
            ),
          ),
        ),
      );
    }).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
      child: Container(
        height: 175.0,
        child: GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 5.0,
          mainAxisSpacing: 5.0,
          childAspectRatio: 3.3,
          // shrinkWrap: true,
          children: dataWidget,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      drawer: Drawer(
        child: DrawerItems(),
      ),
      body: StreamBuilder(
        stream: _provider.fetchUserData(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            DocumentSnapshot userData = snapshot.data;
            return SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          child: CircleAvatar(
                            radius: 40.0,
                            backgroundImage: NetworkImage(userData["photoUrl"]),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              userData["name"],
                              style: TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              userData["email"],
                              style: TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Events Participated in",
                            style: TextStyle(
                              fontFamily: "Montserrat",
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            iconSize: 20.0,
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ProfileEditScreen()));
                            },
                          ),
                        ],
                      ),
                    ),
                    (userData["eventDetail"] == null ||
                            userData["eventDetail"].length == 0)
                        ? Text(
                            "No data added yet",
                            style: TextStyle(
                              fontFamily: "Montserrat",
                              fontSize: 14.0,
                            ),
                          )
                        : _buildEventsWidget(userData["eventDetail"]),
                    SizedBox(
                      height: 25.0,
                    ),
                    RaisedButton(
                      elevation: 5.0,
                      splashColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0)),
                      color: Colors.red,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.exit_to_app,
                            color: Colors.white,
                            size: 30.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(
                              "Logout",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Montserrat",
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        _provider.getAuthProvider().then((value) {
                          if (value == "Google") {
                            signOutGoogle().whenComplete(() {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context) {
                                  return LoginScreen();
                                }),
                              );
                            });
                          } else if (value == "Facebook") {
                            signOutFacebook().whenComplete(() {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context) {
                                  return LoginScreen();
                                }),
                              );
                            });
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError)
            return Center(child: errorWidget("No data found"));
          else
            return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
