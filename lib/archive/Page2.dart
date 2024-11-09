import 'package:hackathon_app/Puzzle.dart';
import 'package:hackathon_app/archive/StarPuzzle.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  final List<Image> puzzlePieces = [
    // ここに各パズルピースの画像を追加
    Image.asset('assets/images/1.png'),
    Image.asset('assets/images/2.png'),
    Image.asset('assets/images/3.png'),
    Image.asset('assets/images/4.png'),
    Image.asset('assets/images/5.png'),
    Image.asset('assets/images/6.png'),
  ];

  // サウンド再生のメソッド
  void _playSound() {
    final player = AudioPlayer();
    player.play(AssetSource('sounds/Tapping.wav'));
  }

  void _incrementCounter() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Next'),
          onPressed: () {
            // サウンド再生
            _playSound();

            // ボタンを押された時の動作
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Puzzle(puzzlePieces: puzzlePieces)),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
