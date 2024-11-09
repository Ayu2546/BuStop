import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter/material.dart';
import 'package:BuStop/CustomBar.dart';
import 'package:BuStop/scandata.dart';

class Scanner extends StatelessWidget {
  const Scanner({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scan(title: 'QR scan'),
    );
  }
}

class Scan extends StatefulWidget {
  const Scan({super.key, required this.title});

  final String title;

  @override
  State<Scan> createState() => _Scan();
}

class _Scan extends State<Scan> with SingleTickerProviderStateMixin {
  MobileScannerController controller = MobileScannerController();
  final int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        centerTitle: true, // タイトル中央寄せ
        title: Text(widget.title),
      ),
      bottomNavigationBar: CustomBar(
        selectedIndex: _selectedIndex,
        onTap: (index) {},
      ),
      body: Builder(
        builder: (context) {
          return MobileScanner(
            controller: controller,
            fit: BoxFit.contain,
            onDetect: (scandata) {
              setState(() {
                controller.stop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) {
                      return ScanDataWidget(scandata: scandata);
                    },
                  ),
                );
              });
            },
          );
        },
      ),
    );
  }
}
