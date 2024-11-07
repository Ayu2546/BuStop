import 'package:flutter/material.dart';
import 'package:hackathon_app/Puzzle.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Tourist spot'),
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
  void _incrementCounter() {
    setState(() {});
  }
  final puzzlePieces = [
    // ここに各パズルピースの画像を追加
    Image.asset('assets/images/1.png'),
    Image.asset('assets/images/2.png'),
    Image.asset('assets/images/3.png'),
    Image.asset('assets/images/4.png'),
    Image.asset('assets/images/5.png'),
    Image.asset('assets/images/6.png'),
  ];

  static const double buttonSpace = 20; // ボタン間スペース
  static const double buttonFontSize = 25; // ボタンテキストサイズ
  static const Size buttonSize = Size(300, 75); // ボタンサイズ
  static const Color buttonForegroundColor = Colors.black; // テキストカラー
  static const Color buttonBackgroundColor = Colors.lightBlue; // ボタンカラー

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true, // タイトル中央寄せ
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: buttonSpace), // スペース
            ElevatedButton(
              onPressed: () {
                // 1番目のボタンの処理
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Puzzle(puzzlePieces: puzzlePieces)
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: buttonForegroundColor, // テキストカラー
                backgroundColor: buttonBackgroundColor, // ボタンカラー
                fixedSize: buttonSize, // ボタンサイズ
              ),
              child: Text('鶴ヶ城', style: TextStyle(fontSize: buttonFontSize) // テキストサイズ
              ),
            ),

            SizedBox(height: buttonSpace),

            ElevatedButton(
              onPressed: () {
                // 2番目のボタンの処理書く
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: buttonForegroundColor,
                backgroundColor: buttonBackgroundColor,
                fixedSize: buttonSize,
              ),
              child: Text('飯盛山', style: TextStyle(fontSize: buttonFontSize)
              ),
            ),

            SizedBox(height: buttonSpace),

            ElevatedButton(
              onPressed: () {
                // 2番目のボタンの処理書く
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: buttonForegroundColor,
                backgroundColor: buttonBackgroundColor,
                fixedSize: buttonSize,
              ),
              child: Text('七日町通り', style: TextStyle(fontSize: buttonFontSize)
              ),
            ),
          ],
        ),
      ),
    );
  }
}