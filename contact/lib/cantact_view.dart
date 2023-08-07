import 'dart:io';

import 'package:contact/contact_edit.dart';
import 'package:contact/sharepefrence.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'HiddenContact.dart';
import 'firstscreen.dart';

class ContactView extends StatefulWidget {
  final indexValue;
  final Map userDetails;
   ContactView({super.key, required this.userDetails, this.indexValue});

  @override
  State<ContactView> createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView> {



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
                      widget.indexValue==1?  Text("Hide"):Text("Show")
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

                  if(widget.indexValue==1)
                    {
                      for(int i=0;i<contactData.length;i++)
                      {
                        if(contactData[i]['phone']==widget.userDetails['phone'])
                        {

                          hiddenData.add(contactData[i]);
                          contactData.remove(contactData[i]);
                        }
                      }
                    }
                  else
                    {
                      for(int i=0;i<hiddenData.length;i++)
                      {
                        if(hiddenData[i]['phone']==widget.userDetails['phone'])
                        {

                          contactData.add(hiddenData[i]);
                          hiddenData.remove(hiddenData[i]);
                        }
                      }
                    }



                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                      builder: (context) => HomeScreen()), (Route route) => false);


                  // if value 2 show dialog
                }},
            ),




            // Icon(Icons.more_vert)
          ],
        ),
        body: Center(
            child: Container(
              margin: EdgeInsets.all(20),
              height: 450,
              child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(width: 70,),
                  widget.userDetails['image']!=""?
                  Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: FileImage(File('${widget.userDetails['image']}',),
                            ),
                            fit: BoxFit.cover
                        )
                    ),
                   )
                      : Image.asset("assets/images/person.png",width: 150,height: 150,),


                                 SizedBox(
                    width: 20,
                  ),
                  InkWell(

                      onTap: ()
                      {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text("Delete "),
                            content: const Text("You want to delete this Contact"),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  for(int i=0;i<contactData.length;i++)
                                    {
                                      if(contactData[i]['phone']==widget.userDetails['phone'])
                                        {
                                          contactData.removeAt(i);
                                        }
                                    }

// Navigator.pop(context);
                                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                                      builder: (context) => HomeScreen()), (Route route) => false);
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) => Firstscreen()),
                                  // );
                                },
                                child: Container(

                                  decoration:BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(10),
                                  ),

                                  padding: const EdgeInsets.all(14),
                                  child: const Text("Yes",style: TextStyle(
                                    color:Colors.black,
                                  ),),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                },
                                child: Container(
                                  decoration:BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(10),
                                  ),

                                  padding: const EdgeInsets.all(14),
                                  child: const Text("No",style:TextStyle(color:Colors.black)),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Icon(Icons.delete, size: 30)),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: ()
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ContactEdit(contactData: widget.userDetails),),
                      );
                    },
                    child: Icon(
                      Icons.edit,
                      size: 30,
                    ),
                  ),
                ],
              ),
              Text(
                "${widget.userDetails['firstname']} ${widget.userDetails['Secondname']}",
                style: TextStyle(fontSize: 25,fontWeight: FontWeight.w700),
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '+91 ${widget.userDetails['phone']}',
                    style: TextStyle(fontSize: 20),
                  )),
              Divider(
                thickness: 1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: (){
                      _makePhoneCall(widget.userDetails['phone']);
                    },
                      child: Image.asset("assets/images/phone-call.png",width: 50,height: 50,)),
                  InkWell(
                      onTap: (){
                        _openSms(widget.userDetails['phone']);
                      },


                      child: Image.asset("assets/images/comment.png",width: 50,height: 50,)),
                  InkWell(
                    onTap: (){
                      _openEmail(widget.userDetails['email']);
                    },
                      child: Image.asset("assets/images/email.png",width: 50,height: 50,)),
                  InkWell(
                    onTap: () async {
                      final box = context.findRenderObject() as RenderBox?;

                      await Share.share(
                        widget.userDetails['phone'],
                        subject: widget.userDetails['firstname']+widget.userDetails['Secondname'],
                        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
                      );
                    },
                      child: Image.asset("assets/images/sharing.png",width: 50,height: 50,)),
                ],
              ),
              Divider(
                thickness: 1,
              ),
          ],
        ),
            )),
      ));
    });
  }

  Future<void> _makePhoneCall(String phoneNumber) async {

    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber,

    );
    await launchUrl(launchUri);
  }

_openEmail(String email) async {
  final Uri _url = Uri.parse('mailto:$email?subject=News&body=New%20plugin');
  await launchUrl(_url);

}


  _openSms(String msg) async {
    final Uri _url = Uri.parse('sms:$msg');
    await launchUrl(_url);

  }





}