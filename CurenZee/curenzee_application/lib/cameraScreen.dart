import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'summaryScreen.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  List<CameraDescription>? cameras;
  bool isProcessing = false;
  Timer? _timer;
  File? _image;
  final picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      // setState(() {
      //   _image = File(pickedFile.path);
      // });

      String response = await sendImageToAPI(File(pickedFile.path));

      print("Detection Result: $response");
    }
  }

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    if (cameras != null && cameras!.isNotEmpty) {
      _controller = CameraController(
        cameras![0], // Back camera
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _controller!.initialize();

      if (mounted) {
        setState(() {});
        startAutoCapture();
      }
    }
  }

  void startAutoCapture() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (!isProcessing) {
        captureAndSendImage();
      }
    });
  }

  Future<void> captureAndSendImage() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    setState(() => isProcessing = true);

    try {
      XFile file = await _controller!.takePicture();
      File imageFile = File(file.path);

      String response = await sendImageToAPI(imageFile);

      print("Detection Result: $response");
    } catch (e) {
      print("Error: $e");
    } finally {
      setState(() => isProcessing = false);
    }
  }

  Future<String> sendImageToAPI(File image) async {
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://276c-112-134-156-143.ngrok-free.app/detect'));
    request.files.add(await http.MultipartFile.fromPath('image', image.path));

    var response = await request.send();
    if (response.statusCode == 200) {
      var responseData = jsonDecode(await response.stream.bytesToString());
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => SummaryScreen(responseData)));
      _controller?.dispose();
      _timer?.cancel();
      super.dispose();
      return await response.stream.bytesToString();
    } else {
      return jsonEncode({
        "light_condition": "low_light",
        "detections": [
          {"value": 100, "count": 0},
          {"value": 500, "count": 0}
        ]
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detect Currency")),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _controller == null || !_controller!.value.isInitialized
                  ? Center(child: CircularProgressIndicator())
                  : CameraPreview(_controller!),
              SizedBox(height: 20),
              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 209, 68, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  onPressed: () {
                    dispose();
                    _pickImage(ImageSource.gallery);
                  },
                  child: Text("Select from Gallery"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    _timer?.cancel();
    super.dispose();
  }
}
