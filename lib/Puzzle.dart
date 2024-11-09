import 'package:flutter/material.dart';

class Puzzle extends StatelessWidget {
  final List<Image> puzzlePieces;

  Puzzle({required this.puzzlePieces});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true, // タイトル中央寄せ
        title: Text('Puzzle'),
      ),
      body: Center(
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            mainAxisSpacing: 2.0,
            crossAxisSpacing: 3.0,
          ),
          itemCount: puzzlePieces.length,
          itemBuilder: (context, index) {
            return Draggable(
              data: index,
              feedback: puzzlePieces[index],
              childWhenDragging: Container(color: Colors.grey[200]),
              child: puzzlePieces[index],
            );
          },
        ),
      ),
    );
  }
}
