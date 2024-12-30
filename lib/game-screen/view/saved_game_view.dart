import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/game-screen/view/game_screen_view.dart';

import '../viewmodel/game_screen_viewmodel.dart';

class SavedGameView extends StatefulWidget {
  const SavedGameView({super.key});

  @override
  State<SavedGameView> createState() => _SavedGameViewState();
}

class _SavedGameViewState extends State<SavedGameView> {
  bool isDone = false;
  @override
  void initState() {
    super.initState();
    GameScreenViewmodel viewModel = GameScreenViewmodel();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      viewModel = Provider.of<GameScreenViewmodel>(context, listen: false);
      await viewModel.loadGame("10");
      setState(() {
        isDone = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return isDone ? const GameScreenView() : const BlankView();
  }
}

class BlankView extends StatelessWidget {
  const BlankView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
