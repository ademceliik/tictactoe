abstract class Player {
  String name;
  String userName;
  String markPath;
  List<dynamic> markList = [];
  int counter;
  Player(
      {required this.markPath,
      required this.name,
      required this.userName,
      required this.markList,
      required this.counter});
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'userName': userName,
      'markPath': markPath,
      'markList': markList,
      'counter': counter,
    };
  }
}
