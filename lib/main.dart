import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/game-screen/view/game_screen_view.dart';
import 'package:tictactoe/game-screen/view/saved_game_view.dart';
import 'package:tictactoe/game-screen/viewmodel/game_screen_viewmodel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey.shade400),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Tic Tac Toe'),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              child: const Text(
                'Yeni Oyun Başlat',
                style: TextStyle(fontSize: 35),
              ),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider(
                      create: (context) => GameScreenViewmodel(),
                      child: const GameScreenView(),
                    ),
                  )),
            ),
            TextButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider(
                      create: (context) => GameScreenViewmodel(),
                      child: const SavedGameView(),
                    ),
                  )),
              child: Text(
                'Eski Oyun Yükle',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
