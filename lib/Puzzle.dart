import 'package:flutter/material.dart';

class Puzzle extends StatelessWidget {
  final List<Image> puzzlePieces;

  Puzzle({required this.puzzlePieces});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('2x3 パズル'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 横2分割
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
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
    );
  }
}