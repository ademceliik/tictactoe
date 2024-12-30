import 'player_model.dart';

class OPlayer extends Player {
  OPlayer(
      {super.markPath = "assets/letters/o_letter.json",
      super.name = "O",
      super.userName = "O",
      super.counter = 0,
      List<dynamic>? markList})
      : super(markList: markList ?? []);
  factory OPlayer.fromJson(Map<String, dynamic> json) {
    return OPlayer(
        name: json['name'],
        markPath: json['markPath'],
        userName: json['userName'],
        counter: json['counter'],
        markList: json['markList']);
  }
}
