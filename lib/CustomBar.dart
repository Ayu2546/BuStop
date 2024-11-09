import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:BuStop/TourPage.dart';
import 'package:BuStop/main.dart';
import 'package:BuStop/scanner.dart';

class CustomBar extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const CustomBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  State<CustomBar> createState() => _CustomBarState();
}

class _CustomBarState extends State<CustomBar> {
  // 各ページ
  static final List<Widget> _pages = <Widget>[
    const MyApp(),
    const Scanner(),
    const TourPage(),
  ];

  // サウンド再生
  void _playSound() {
    final player = AudioPlayer();
    player.play(AssetSource('sounds/Tapping.wav'));
  }

  // ページ遷移
  void _onItemTapped(int index) {
    // サウンド
    _playSound();

    // 同じボタンはスキップ
    if (widget.selectedIndex == index) {
      return;
    }
    setState(() {
      widget.onTap(index); // 選択されているインデックスを更新
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => _pages[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.selectedIndex,
      onTap: _onItemTapped,
      selectedItemColor: Colors.amber[800],
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          label: 'Map',
          icon: Icon(Icons.place),
        ),
        BottomNavigationBarItem(
          label: 'QRCode',
          icon: Icon(Icons.qr_code_scanner),
        ),
        BottomNavigationBarItem(
          label: 'Tour',
          icon: Icon(Icons.tour),
        ),
      ],
    );
  }
}
