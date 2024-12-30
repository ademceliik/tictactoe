import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/game-screen/viewmodel/game_screen_viewmodel.dart';
import 'widgets/draw_line_custom_paint.dart';
import '../model/player_model.dart';

class GameScreenView extends StatefulWidget {
  const GameScreenView({super.key});

  @override
  State<GameScreenView> createState() => _GameScreenViewState();
}

class _GameScreenViewState extends State<GameScreenView>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  Map<int, AnimationController> controllers = {};
  @override
  void initState() {
    super.initState();
    createGame();
    GameScreenViewmodel viewModel = GameScreenViewmodel();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      viewModel = Provider.of<GameScreenViewmodel>(context, listen: false);
      viewModel.createGame(controllers);
    });
  }

  @override
  void dispose() {
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        controllers[3 * i + j]!.dispose();
      }
    }
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<GameScreenViewmodel>(context);

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Tic Tac Toe"),
        actions: [
          IconButton(
              onPressed: () {
                viewModel.saveGame();
              },
              icon: const Icon(Icons.save_outlined))
        ],
      ),
      body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fitHeight,
                  image: AssetImage("assets/backgrounds/background.png"))),
          // margin: EdgeInsets.only(top: width * 0.05),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: height * 0.10),
                height: height * 0.25,
                width: width * 0.7,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/backgrounds/scorboard.png"))),
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        buildChangeNameDialog(
                            context: context, player: viewModel.xPlayer);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: width * 0.1),
                            child: Text(
                              maxLines: 1,
                              "${viewModel.xPlayer.userName}:",
                              style: const TextStyle(fontSize: 22),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: width * 0.1),
                            child: Text(
                              maxLines: 1,
                              "${viewModel.xPlayer.counter}",
                              style: const TextStyle(fontSize: 22),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    GestureDetector(
                      onTap: () {
                        buildChangeNameDialog(
                            context: context, player: viewModel.oPlayer);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: width * 0.1),
                            child: Text(
                              maxLines: 1,
                              "${viewModel.oPlayer.userName}:",
                              style: const TextStyle(fontSize: 22),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: width * 0.1),
                            child: Text(
                              maxLines: 1,
                              "${viewModel.oPlayer.counter}",
                              style: const TextStyle(fontSize: 22),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    left: width * 0.095,
                    top: height / 180,
                    right: width * 0.095),
                child: CustomPaint(
                  foregroundPainter: DrawLineCustomPaint(
                      direction: viewModel.direction,
                      moveTo: viewModel.moveTo,
                      lineTo: viewModel.lineTo,
                      heightProps: viewModel.curve
                          .transform(_animationController.value)),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          buildItem(
                              index: 0, width: width, viewModel: viewModel),
                          buildItem(
                              index: 1, width: width, viewModel: viewModel),
                          buildItem(
                              index: 2, width: width, viewModel: viewModel)
                        ],
                      ),
                      Row(
                        children: [
                          buildItem(
                              index: 3, width: width, viewModel: viewModel),
                          buildItem(
                              index: 4, width: width, viewModel: viewModel),
                          buildItem(
                              index: 5, width: width, viewModel: viewModel)
                        ],
                      ),
                      Row(
                        children: [
                          buildItem(
                              index: 6, width: width, viewModel: viewModel),
                          buildItem(
                              index: 7, width: width, viewModel: viewModel),
                          buildItem(
                              index: 8, width: width, viewModel: viewModel)
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: width * 0.05, top: width * 0.0),
                width: width * 0.7,
                height: width * 0.15,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image:
                            AssetImage("assets/backgrounds/next_player.png"))),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Sıradaki Hamle: ${viewModel.isFirstPlayer ? viewModel.xPlayer.userName : viewModel.oPlayer.userName}",
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  void createGame() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _animationController.addListener(() => setState(() {}));
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        controllers[3 * i + j] = AnimationController(
            vsync: this, duration: const Duration(milliseconds: 500));
      }
    }
  }

  void clearGame(GameScreenViewmodel viewModel) {
    _animationController.reset();
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        controllers[3 * i + j]!.reset();
      }
    }
    viewModel.clearGame();
  }

  Widget buildItem(
      {required int index,
      required double width,
      required GameScreenViewmodel viewModel}) {
    Player player =
        viewModel.isFirstPlayer ? viewModel.xPlayer : viewModel.oPlayer;
    return GestureDetector(
      onTap: viewModel.canTappable
          ? () {
              if (!viewModel.isPositionFill[index]!) {
                viewModel.playerMoved(index, controllers[index]!);
                if (viewModel.checkXOX(player.markList, index)) {
                  viewModel.setCanTappable();
                  buildAlertDialog(
                      viewModel: viewModel,
                      context: context,
                      player: player,
                      animationController: _animationController);
                } else if (player.markList.length > 3) {
                  viewModel.deleteFirstMove(
                      player, controllers[player.markList[0]]!);
                }
                viewModel.nextPlayer();
              }
            }
          : null,
      child: Container(
          margin: EdgeInsets.only(left: width * 0.020, bottom: width * 0.020),
          color: Colors.white,
          width: width * 0.25,
          height: width * 0.25,
          child: viewModel.widgets[index]),
    );
  }

  Future<dynamic> buildChangeNameDialog(
      {required BuildContext context, required Player player}) {
    TextEditingController controller = TextEditingController();
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              title: Text("${player.userName}  Ad Güncelle"),
              actions: [
                TextField(
                  controller: controller,
                  style: const TextStyle(fontSize: 20),
                  decoration: const InputDecoration(hintText: "Yeni Ad"),
                ),
                TextButton(
                    onPressed: () {
                      setState(() {
                        if (controller.text.isNotEmpty) {
                          player.userName = controller.text;
                        }
                      });

                      Navigator.pop(context);
                    },
                    child: const Text("Kaydet"))
              ],
            ));
  }

  Future<dynamic> buildAlertDialog(
      {required BuildContext context,
      required Player player,
      required AnimationController animationController,
      required GameScreenViewmodel viewModel}) async {
    await animationController.forward();
    await Future.delayed(const Duration(seconds: 1), () {});
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Oyun Bitti"),
              content: Text(
                "Kazanan ${player.userName}",
                style: const TextStyle(fontSize: 28),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      viewModel.roundIsDone(player);
                      clearGame(viewModel);
                      Navigator.pop(context);
                    },
                    child: const Text("Tamam"))
              ],
            ));
  }
}
