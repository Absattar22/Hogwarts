import 'package:flutter/material.dart';
import 'presentation/views/characters_view.dart';

void main() {
  runApp(const Hogwarts());
}

class Hogwarts extends StatelessWidget {
  const Hogwarts({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        CharactersView.id: (context) => const CharactersView(),
      },
      initialRoute: CharactersView.id,
    );
  }
}
