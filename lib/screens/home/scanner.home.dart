import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:passengercontrol_chaskipass/screens/home/resultScreen.home.dart';

const bgColor = Color(0xfffafafa);

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  bool isScanCompleted = false;

  void closeScreen() {
    isScanCompleted = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Scanner de QR",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Enfoca el codigo QR en la siguiente area",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Se escaneara automaticamente",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: (MobileScanner(
                onDetect: (barcodeCapture) {
                  if (!isScanCompleted) {
                    // Obtenemos el primer código detectado
                    if (barcodeCapture.barcodes.isNotEmpty) {
                      // rawValue contiene el valor del QR escaneado
                      String resultString =
                          barcodeCapture.barcodes.first.rawValue ?? '';
                      isScanCompleted = true;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => ResultScreen(
                                code: resultString,
                                closeScreen: closeScreen,
                              ),
                        ),
                      );
                    }
                  }
                },
              )),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  "Area donde iran los datos",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
