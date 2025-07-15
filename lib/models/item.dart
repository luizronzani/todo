class Item {
  String title;
  bool isDone;

  Item({required this.title, required this.isDone});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(title: json['title'] as String, isDone: json['isDone'] as bool);
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'isDone': isDone};
  }
}
