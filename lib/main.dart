import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File pickedImage;

  List<TextBlock> blocks;

  bool isImageLoaded = false;

  Future pickImage() async {
    var tempStore = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      pickedImage = tempStore;
      isImageLoaded = true;
    });
  }

  Future readText() async {
    FirebaseVisionImage image = FirebaseVisionImage.fromFile(pickedImage);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();

    VisionText readText = await recognizeText.processImage(image);

    setState(() {
      blocks = readText.blocks;
      print(blocks);
    });
  }

  @override
  void initState() {
    super.initState();

    blocks = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: <Widget>[
            SizedBox(height: 100.0),
            isImageLoaded
                ? Center(
              child: Container(
                  height: 200.0,
                  width: 200.0,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: FileImage(pickedImage), fit: BoxFit.cover))),
            )
                : Container(),
            SizedBox(height: 10.0),
            RaisedButton(
              child: Text('Pick an image'),
              onPressed: pickImage,
            ),
            SizedBox(height: 10.0),
            RaisedButton(
              child: Text('Read Text'),
              onPressed: readText,
            ),
            Expanded(
              child: blocks.length > 0 ? ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return Text(blocks[index].text);
                },
                itemCount: blocks.length,
              ) : Container(),
            )
          ],
        )
    );
  }
}