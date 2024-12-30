import 'player_model.dart';

class XPlayer extends Player {
  XPlayer(
      {super.markPath = "assets/letters/x_letter.json",
      super.name = "X",
      super.userName = "X",
      super.counter = 0,
      List<dynamic>? markList})
      : super(markList: markList ?? []);

  factory XPlayer.fromJson(Map<String, dynamic> json) {
    return XPlayer(
        name: json['name'],
        markPath: json['markPath'],
        userName: json['userName'],
        counter: json['counter'],
        markList: json['markList']);
  }
}
