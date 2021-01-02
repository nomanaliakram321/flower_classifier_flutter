import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:tflite/tflite.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _loading = true;
  File _image;
  List _output;
  final picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 5,
        threshold: 0.5,
        imageMean: 127.5,
        imageStd: 127.5);
    setState(() {
      _output = output;
      _loading = false;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
        model: 'assets/model.tflite', labels: 'assets/labels.txt');
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  pickImage() async {
    var image = await picker.getImage(source: ImageSource.camera);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });
    classifyImage(_image);
  }

  pickGellaryImage() async {
    var image = await picker.getImage(source: ImageSource.gallery);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });
    classifyImage(_image);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title:
              Text('Machine Learning', style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: Color(0xFFa8e063),
        ),
        backgroundColor: Color(0xFFa8e063),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.004, 1],
                colors: [Color(0xFFa8e063), Color(0xFF56ab2f)]),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30.0,
                ),
                Text('Detect Flowers',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28.0,
                        fontWeight: FontWeight.w800)),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  padding: EdgeInsets.all(30.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                        )
                      ]),
                  child: Column(
                    children: [
                      Container(
                        child: Center(
                          child: _loading
                              ? Container(
                                  width: 300.0,
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        'assets/flower.png',
                                      ),
                                      SizedBox(
                                        height: 60.0,
                                      )
                                    ],
                                  ),
                                )
                              : Container(
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 300,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.file(_image),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                      _output != null
                                          ? Text(
                                              'Prediction is : ${_output[0]['label']}',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20.0),
                                            )
                                          : Container(),
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: pickImage,
                              child: Container(
                                width: MediaQuery.of(context).size.width - 180,
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 17),
                                decoration: BoxDecoration(
                                    color: Color(0xFF56ab2f),
                                    borderRadius: BorderRadius.circular(6)),
                                child: Text(
                                  'Take a Photo',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18.0),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            GestureDetector(
                              onTap: pickGellaryImage,
                              child: Container(
                                width: MediaQuery.of(context).size.width - 180,
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 17),
                                decoration: BoxDecoration(
                                    color: Color(0xFF56ab2f),
                                    borderRadius: BorderRadius.circular(6)),
                                child: Text(
                                  'From Gellary',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
