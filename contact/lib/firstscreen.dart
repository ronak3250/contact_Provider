import 'dart:io';
import 'package:contact/cantact_view.dart';
import 'package:contact/sharepefrence.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';

import 'HiddenContact.dart';
import 'contact_edit.dart';
import 'contact_save.dart';

class HomeScreen extends StatefulWidget {


  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

List<Map<String, dynamic>> contactData = [];

List<Map<String, dynamic>> hiddenData = [];

class _HomeScreenState extends State<HomeScreen> {

  final auth = LocalAuthentication();
  String authorized = "not authorized";
  bool _canCheckBiometric = false;
  late List<BiometricType> _availableBiometric;

  Future<void> _authenticate() async {
    bool authenticated = false;

    try {
      authenticated = await auth.authenticate(

          localizedReason: "Scan your finger to authenticate",
          options:AuthenticationOptions(biometricOnly: false,stickyAuth: true
              ,sensitiveTransaction: true)

      );
    } on PlatformException catch (e) {
      print(e);
    }

    setState(() {
      authorized =
      authenticated ? "Authorized success" : "Failed to authenticate";
      print(authorized);
      authenticated ?    Navigator.push(context, MaterialPageRoute(builder: (context) => HideContactPage())):Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
          builder: (context) => HomeScreen()), (Route route) => false);
    });
  }

  Future<void> _checkBiometric() async {
    bool canCheckBiometric = false;

    try {
      canCheckBiometric = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;

    setState(() {
      _canCheckBiometric = canCheckBiometric;
    });
  }

  Future _getAvailableBiometric() async {
    List<BiometricType> availableBiometric = [];

    try {
      availableBiometric = await auth.getAvailableBiometrics();
      print(availableBiometric.length);

    } on PlatformException catch (e) {
      print(e);
    }

    setState(() {
      _availableBiometric = availableBiometric;
    });
    if (_availableBiometric.contains(BiometricType.face)) {
      print("Face scan is available");
    }else{
      print("Face scan is not available");
    }
  }

  @override
  void initState() {
    _checkBiometric();
    _getAvailableBiometric();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {
      return SafeArea(
          child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text(
            "Contacts",
          ),
          actions: [
            InkWell(
                onTap: () {
                  setState(() {
                    themeNotifier.isDark
                        ? themeNotifier.isDark = false
                        : themeNotifier.isDark = true;
                  });
                },
                child: Icon(Icons.circle_rounded)),
            PopupMenuButton<int>(
              color: Colors.blue,
              itemBuilder: (context) => [

                PopupMenuItem(
                  value: 1,
                  // row has two child icon and text.
                  child: Container(
                    child: Row(
                      children: [
                        Icon(Icons.remove_red_eye),
                        SizedBox(
                          // sized box with width 10
                          width: 10,
                        ),
                        Text("Show Hidden Contact")
                      ],
                    ),
                  ),
                ),

              ],

              offset: Offset(0, 10),

              elevation: 2,
              // on selected we show the dialog box
              onSelected: (value) {
                // if value 1 show dialog
                if (value == 1) {
                  _authenticate();


                  // if value 2 show dialog
                }},
            ),
          ],
        ),
        body: Center(
            child: contactData.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/box.png',
                        height: 130,
                        width: 130,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "You have not contact yet",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  )
                : ListView.separated(
                    physics: BouncingScrollPhysics(
                        decelerationRate: ScrollDecelerationRate.fast),
                    itemCount: contactData.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ContactView(userDetails: contactData[index],indexValue: 1,)),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 20, right: 20, top: 40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              contactData[index]['image']!="" ?
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: FileImage(File('${contactData[index]['image']}',),
                                    ),
                                    fit: BoxFit.cover
                                  )
                                ),
                              /*  child: Image.file(
                                  File('${contactdata[index]['image']}'),
                                  fit: BoxFit.fill,
                                  width: 30,
                                  height: 30,
                                ),*/
                              )
                                  :
                               Icon(Icons.person,size: 50,),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "${contactData[index]['firstname']} ${contactData[index]['Secondname']}",
                                      style: TextStyle(
                                        fontSize: 20,
                                      )),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text("+91 ${contactData[index]['phone']}",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.grey))
                                ],
                              ),

                              Spacer(
                                flex: 2,
                              ),
                              Icon(
                                Icons.call,
                                color: Colors.green,
                                size: 40,
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: 10,
                      );
                    },
                  )),
        floatingActionButton: Align(
          alignment: Alignment(0.9, 0.9),
          child: FloatingActionButton(
            child: Icon(
              Icons.add,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ContactSave()),
              );
            },
          ),
        ),
      ));
    });
  }
}
