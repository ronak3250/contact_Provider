import 'dart:io';

import 'package:contact/sharepefrence.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'cantact_view.dart';
import 'firstscreen.dart';

class HideContactPage extends StatefulWidget {
  const HideContactPage({super.key});

  @override
  State<HideContactPage> createState() => _HideContactPageState();
}

class _HideContactPageState extends State<HideContactPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {
          return SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  elevation: 0.0,
                  title: Text(
                    "Hidden Contact",
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

                  ],
                ),
                body: Center(
                    child: hiddenData.isEmpty
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
                      itemCount: hiddenData.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ContactView(userDetails: hiddenData[index],indexValue: 2,)),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 20, right: 20, top: 40),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                hiddenData[index]['image']!="" ?
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: FileImage(File('${hiddenData[index]['image']}',),
                                          ),
                                          fit: BoxFit.cover
                                      )
                                  ),
                                  /*  child: Image.file(
                                  File('${hiddenData[index]['image']}'),
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
                                        "${hiddenData[index]['firstname']} ${hiddenData[index]['Secondname']}",
                                        style: TextStyle(
                                          fontSize: 20,
                                        )),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text("+91 ${hiddenData[index]['phone']}",
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

              ));
        });

  }
}