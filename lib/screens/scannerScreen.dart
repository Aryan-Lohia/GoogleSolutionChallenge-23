import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:first_app/screens/googleApi.dart';
import 'package:first_app/screens/loadingScreen.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/app_style.dart';
import 'package:process_run/shell.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.max,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Text(
            'Scan your Prescription',
            style: Styles.headlineStyle2,
          )),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                SizedBox(
                    height: MediaQuery.of(context).size.height - 0,
                    width: MediaQuery.of(context).size.width,
                    child: CameraPreview(_controller,child: IconButton(
                      color: Colors.orangeAccent,
                        onPressed: ()async{
                          PickedFile? pickedFile = await ImagePicker().getImage(
                            source: ImageSource.gallery,
                            maxWidth: 1800,
                            maxHeight: 1800,
                          );
                          if (pickedFile != null) {
                            CroppedFile? croppedFile = await ImageCropper().cropImage(
                              sourcePath: pickedFile.path,
                              aspectRatioPresets: [
                                CropAspectRatioPreset.square,
                                CropAspectRatioPreset.ratio3x2,
                                CropAspectRatioPreset.original,
                                CropAspectRatioPreset.ratio4x3,
                                CropAspectRatioPreset.ratio16x9
                              ],
                              uiSettings: [
                                AndroidUiSettings(
                                    toolbarTitle: 'Crop Your Prescription',
                                    toolbarColor: Colors.orange,
                                    toolbarWidgetColor: Colors.white,
                                    initAspectRatio: CropAspectRatioPreset.original,
                                    lockAspectRatio: false),
                                IOSUiSettings(
                                  title: 'Cropper',
                                ),
                                WebUiSettings(
                                  context: context,
                                ),
                              ],
                            );
                            if (croppedFile != null) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => LoadingScreen(
                                    imagePath: croppedFile.path,
                                  ),
                                ),
                              );
                            }


                          }

                        },
                        icon:Icon(Icons.upload)
                    ),)),
                // Align(
                //   alignment: Alignment.bottomLeft,
                //   child:
                // )
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final image = await _controller.takePicture();

            if (!mounted) return;
            CroppedFile? croppedFile = await ImageCropper().cropImage(
              sourcePath: image.path,
              aspectRatioPresets: [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ],
              uiSettings: [
                AndroidUiSettings(
                    toolbarTitle: 'Crop Your Prescription',
                    toolbarColor: Colors.orange,
                    toolbarWidgetColor: Colors.white,
                    initAspectRatio: CropAspectRatioPreset.original,
                    lockAspectRatio: false),
                IOSUiSettings(
                  title: 'Cropper',
                ),
                WebUiSettings(
                  context: context,
                ),
              ],
            );
            if (croppedFile != null) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => LoadingScreen(
                    imagePath: croppedFile.path,
                  ),
                ),
              );
            }
          } catch (e) {
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.file(File(imagePath)),
    );
  }
}
