import 'dart:io';

import 'package:contact/firstscreen.dart';
import 'package:contact/sharepefrence.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'main.dart';
class ContactEdit extends StatefulWidget {
final Map contactData;


  ContactEdit({Key? key, required this.contactData}) : super(key: key);

  @override

  State<ContactEdit> createState() => _ContactEditState();
}
class _ContactEditState extends State<ContactEdit> {

  File? imageFile;
String? imagePath;
  getFromGallery() async {
    var pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        imagePath=imageFile!.path;
      });
    }
  }

  /// Get from Camera
  _getFromCamera() async {
    var pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        imagePath=imageFile!.path;
      });
    }
  }
  final firstController = TextEditingController();
  final lastController = TextEditingController();

  final emailControler = TextEditingController();

  final phoneController = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    imagePath=widget.contactData['image'];
    firstController.text =widget.contactData['firstname'];
      lastController.text =widget.contactData['Secondname'];
    emailControler.text =widget.contactData['email'];
    phoneController.text =widget.contactData['phone'];

    super.initState();
  }
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {

      return Scaffold(
      appBar: AppBar(
        title: Text("Edit"),
        actions: [
          InkWell(
            child: Icon(Icons.circle_rounded),
            onTap: ()
            {
              setState(() {

                themeNotifier.isDark
                    ? themeNotifier.isDark = false
                    : themeNotifier.isDark = true;
              });
            },

          ),


          InkWell(
            onTap: ()
            {
              if(_formKey.currentState!.validate())
                {
                   _formKey.currentState?.save();

                  widget.contactData['image']=imagePath;
                  widget.contactData['firstname']=firstController.text;
                  widget.contactData['Secondname']=lastController.text;
                  widget.contactData['phone']=phoneController.text;
                  widget.contactData['email']=emailControler.text;

                   Navigator.push(
                     context,
                     MaterialPageRoute(builder: (context) =>  HomeScreen()),
                   );
                }
            },
            child: Icon(Icons.check,size: 30,) ),SizedBox(width: 25,)],
        leading: InkWell(
          onTap: ()
          {
            // print(indexvalue);
            Navigator.pop(context);


          },
          child: Icon(Icons.arrow_back,size: 30,),

        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(

          child: Container(
            margin: EdgeInsets.only(right: 20,left: 20,top: 30,bottom: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                imagePath== ""
                    ?  Align(
                  child: Container(
                    margin: EdgeInsets.all(30),
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.7),
                      shape: BoxShape.circle,
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Text(
                            "Edit",
                            style:
                            TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text("Select Image"),
                                  content: const Text(
                                      "Add Your Profile Image from Mention Below"),
                                  actions: <Widget>[
                                    ElevatedButton(
                                      onPressed: () async {
                                        await getFromGallery();
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("PICK FROM GALLERY"),
                                    ),
                                    Container(
                                      height: 20.0,
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        await _getFromCamera();
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("PICK FROM CAMERA"),
                                    )
                                  ],
                                ),
                              );
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.blue),
                                height: 30,
                                width: 30,
                                child: Center(
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ))),
                          ),
                        )
                      ],
                    ),
                  ),
                )

                    : Align(
                      child: Container(
                        margin: EdgeInsets.all(30),
                        child: Container(

                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: FileImage(File(imagePath!),
                                    ),
                                    fit: BoxFit.cover
                                ),),

                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text("Select Image"),
                                    content: const Text(
                                        "Add Your Profile Image from Mention Below"),
                                    actions: <Widget>[
                                      ElevatedButton(
                                        onPressed: () async {
                                          await getFromGallery();
                                          Navigator.of(context).pop();
                                        },
                                        child:
                                        Text("PICK FROM GALLERY"),
                                      ),
                                      Container(
                                        height: 20.0,
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          await _getFromCamera();
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("PICK FROM CAMERA"),
                                      )
                                    ],
                                  ),
                                );
                              },
                              child:

                              Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.blue),
                                  height: 30,
                                  width: 30,
                                  child: Center(
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ))),
                            ),
                          ),
                        ),
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.7),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                Text("First Name"),
                TextFormField(
                  controller: firstController,
validator: (value) {
  if(value!.isEmpty)
    {
      return 'enter the First Name';
    }

},
                  decoration: InputDecoration(

                      focusedBorder:  OutlineInputBorder(

                        borderSide: const BorderSide(width: 1, color: Colors.black),
                        //   borderRadius: BorderRadius.circular(5),
                      ),
                      enabledBorder: OutlineInputBorder(

                        borderSide: const BorderSide(width: 1, color: Colors.black),
                     //   borderRadius: BorderRadius.circular(5),
                      ),
                    hintText: 'Enter the First Name'
                  ),
                ),
                SizedBox(height: 10,),
                Text("Last Name"),

                TextFormField(
                  controller: lastController,
                  validator: (value) {
                    if(value!.isEmpty)
                    {
                      return 'enter the Last Name';
                    }
                    return null;
                  },
                  decoration: InputDecoration(

                      focusedBorder:  OutlineInputBorder(

                        borderSide: const BorderSide(width: 1, color: Colors.black),
                        //   borderRadius: BorderRadius.circular(5),
                      ),
                      enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 1, color: Colors.black),
                  //  borderRadius: BorderRadius.circular(5),
                  ),
                      hintText: 'Enter the Last Name'
                  ),
                ),
                SizedBox(height: 10,),
                Text("Phone"),
                TextFormField(
                  controller:phoneController,
                  validator: (phonevalue)
                  {
                    String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                    RegExp regExp = new RegExp(patttern);
                    if (phonevalue?.length == 0) {
                      return 'Please enter mobile number';
                    }
                    else if (!regExp.hasMatch(phonevalue!)) {
                      return 'Please enter valid mobile number';
                    }
                    else if(phonevalue?.length==11)
                    {
                      return 'Mobile Number must be 10 digits';
                    }

                  },
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(

                      borderSide: const BorderSide(width: 1, color: Colors.black),
                      //   borderRadius: BorderRadius.circular(5),
                    ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 1, color: Colors.black),
                      //  borderRadius: BorderRadius.circular(5),
                      ),
                      hintText: 'Enter the Phone Number'
                  ),
                ),
                SizedBox(height: 10,),
                Text("Email"),
                TextFormField(
                  controller:emailControler,
                  validator: (emailvalue) {
                    bool emailValid = RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$').hasMatch(emailvalue!);
                    if(emailvalue!.isEmpty)
                    {
                      return 'Enter The Email Address ';
                    }
                    if(emailValid!=true)
                    {
                      return "Enter Valid Email Address";
                    }


                  },
                  decoration: InputDecoration(

                      focusedBorder:  OutlineInputBorder(

                        borderSide: const BorderSide(width: 1, color: Colors.black),
                        //   borderRadius: BorderRadius.circular(5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 1, color: Colors.black),
                       // borderRadius: BorderRadius.circular(5),
                      ),
                      hintText: 'Enter the Email'
                  ),
                )
              ],
            ),
          ),
        ),
      ),

    );});
  }
}
