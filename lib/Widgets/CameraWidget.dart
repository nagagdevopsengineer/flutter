import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:gpapp/Controllers/CommonController.dart';
import 'package:gpapp/Screens/ProfileScreen.dart';

class CameraApp extends StatefulWidget {
  CameraApp({required this.cameras});
  final cameras;
  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  late CameraController controller;
  var cameraIndex = 1;

  void _toggleCameraLens(_controller) {
    // get current lens direction (front / rear)
    final lensDirection = _controller.description.lensDirection;
    CameraDescription newDescription;
    if (lensDirection == CameraLensDirection.front) {
      newDescription = widget.cameras.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.back);
    } else {
      newDescription = widget.cameras.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.front);
    }

    if (newDescription != null) {
      _initCamera(newDescription);
    } else {
    }
  }

  Future<void> _initCamera(CameraDescription description) async {
    controller =
        CameraController(description, ResolutionPreset.max, enableAudio: true);

    try {
      await controller.initialize();
      // to notify the widgets that camera has been initialized and now camera preview can be done
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _initCamera(widget.cameras[cameraIndex]);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
        backgroundColor: Colors.black54,
        body: Column(
          children: [
            Container(
              width: Get.width,
              child: CameraPreview(controller),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 70,
                ),
                GestureDetector(
                  onTap: () async {
                    try {
                      XFile image = await controller.takePicture();
                      Get.to(() => ShowPic(image: image));
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                        color: Colors.grey[350],
                        border: Border.all(color: Colors.white, width: 3),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50))),
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                GestureDetector(
                  onTap: () {
                    _toggleCameraLens(controller);
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    // margin: const EdgeInsets.only(top: 750),
                    child: Icon(
                      Icons.change_circle_outlined,
                      color: Colors.white,
                      size: 35,
                    ),
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50))),
                  ),
                ),
              ],
            )
          ],
        ));
  }
}

class ShowPic extends StatefulWidget {
  const ShowPic({Key? key, required this.image}) : super(key: key);
  final image;
  @override
  State<ShowPic> createState() => _ShowPicState();
}

class _ShowPicState extends State<ShowPic> {
  var c = Get.find<CommonController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: Get.height * 0.7,
            child: Image.file(File(widget.image.path)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Text(
                  "Retake",
                  style: TextStyle(
                      // fontWeight: FontWeight.w600,
                      fontSize: 22,
                      color: Colors.white),
                ),
              ),
              GestureDetector(
                onTap: () {
                  c.imageFile = widget.image;
                  Get.offAll(() => ProfileScreen());
                },
                child: Text(
                  "Done",
                  style: TextStyle(
                      // fontWeight: FontWeight.w600,
                      fontSize: 22,
                      color: Colors.white),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
