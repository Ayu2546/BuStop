import 'package:flutter/material.dart';
import '../scanner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'コードスキャナー',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'コードスキャナー'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: ElevatedButton(
          // 押したらスキャンの画面に入るボタン
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ScannerWidget(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            elevation: 20, // ボタンが画面から浮かぶ高さ（影で現す）
            fixedSize: const Size.fromHeight(300), // ボタンの大きさ
            backgroundColor: const Color(0xFFAADDCC), // ボタンの背景の色
            side:
                const BorderSide(color: Color(0xFF44AA66), width: 6), // ボタンの枠線
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.qr_code_scanner_sharp, // QRスキャンのアイコン
                size: 120,
              ),
              Text(
                'スキャンを始める',
                style: TextStyle(fontSize: 36),
              )
            ],
          ),
        ),
      ),
    );
  }
}