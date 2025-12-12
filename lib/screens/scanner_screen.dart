
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  _ScannerScreenState createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  CameraController? _controller;
  bool _isScanning = false;
  List<CameraDescription>? _cameras;
  Timer? _scanTimer;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _controller = CameraController(_cameras![0], ResolutionPreset.high);
      await _controller!.initialize();
      if (!mounted) {
        return;
      }
      setState(() {});
    }
  }

  void _toggleScan() {
    if (_isScanning) {
      _scanTimer?.cancel();
    } else {
      _scanTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
        // Simulate a scan
        print("Scanning...");
      });
    }
    setState(() {
      _isScanning = !_isScanning;
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    _scanTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner'),
      ),
      body: Stack(
        children: [
          CameraPreview(_controller!),
          Center(
            child: CustomPaint(
              size: const Size(200, 200),
              painter: ScannerOverlayPainter(),
            ),
          ),
          if (_isScanning)
            Center(
              child: Container(
                width: 200,
                height: 2,
                color: Colors.red,
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleScan,
        child: Icon(_isScanning ? Icons.stop : Icons.play_arrow),
      ),
    );
  }
}

class ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final path = Path()
      ..moveTo(0, 10)
      ..lineTo(0, 0)
      ..lineTo(10, 0)
      ..moveTo(size.width - 10, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, 10)
      ..moveTo(size.width, size.height - 10)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width - 10, size.height)
      ..moveTo(10, size.height)
      ..lineTo(0, size.height)
      ..lineTo(0, size.height - 10);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
