import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:BuStop/CustomBar.dart';
import 'package:BuStop/Puzzle.dart';

class TourPage extends StatelessWidget {
  const TourPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Tour(title: 'Tourist Spot'),
    );
  }
}

class Tour extends StatefulWidget {
  const Tour({super.key, required this.title});

  final String title;

  @override
  State<Tour> createState() => _Tour();
}

class _Tour extends State<Tour> {
  static final List<Image> puzzlePieces = <Image>[
    // ここに各パズルピースの画像を追加
    Image.asset('assets/images/1.png'),
    Image.asset('assets/images/2.png'),
    Image.asset('assets/images/3.png'),
    Image.asset('assets/images/4.png'),
    Image.asset('assets/images/5.png'),
    Image.asset('assets/images/6.png'),
  ];

  // サウンド再生
  void _playSound() {
    final player = AudioPlayer();
    player.play(AssetSource('sounds/Tapping.wav'));
  }

  static const double buttonSpace = 30; // ボタン間スペース
  static const double buttonFontSize = 25; // ボタンテキストサイズ
  static const Size buttonSize = Size(300, 75); // ボタンサイズ
  static const Color buttonForegroundColor = Colors.black; // テキストカラー
  static const Color buttonBackgroundColor = Colors.lightBlue; // ボタンカラー
  final int _selectedIndex = 2;

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: buttonSpace), // スペース
            ElevatedButton(
              onPressed: () {
                // サウンド再生
                _playSound();
                // 1番目のボタンの処理
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Puzzle(puzzlePieces: puzzlePieces)),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: buttonForegroundColor, // テキストカラー
                backgroundColor: buttonBackgroundColor, // ボタンカラー
                fixedSize: buttonSize, // ボタンサイズ
              ),
              child: Text('鶴ヶ城',
                  style: TextStyle(fontSize: buttonFontSize) // テキストサイズ
                  ),
            ),

            SizedBox(height: buttonSpace),

            ElevatedButton(
              onPressed: () {
                // サウンド再生
                _playSound();
                // 2番目のボタンの処理書く
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: buttonForegroundColor,
                backgroundColor: buttonBackgroundColor,
                fixedSize: buttonSize,
              ),
              child: Text('飯盛山', style: TextStyle(fontSize: buttonFontSize)),
            ),

            SizedBox(height: buttonSpace),

            ElevatedButton(
              onPressed: () {
                // サウンド再生
                _playSound();
                // 3番目のボタンの処理書く
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: buttonForegroundColor,
                backgroundColor: buttonBackgroundColor,
                fixedSize: buttonSize,
              ),
              child: Text('七日町通り', style: TextStyle(fontSize: buttonFontSize)),
            ),
          ],
        ),
      ),
    );
  }
}
