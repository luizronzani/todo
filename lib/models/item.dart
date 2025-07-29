class Item {
  String title;
  bool done;

  Item({required this.title, required this.done});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(title: json['title'] ?? '', done: json['done'] ?? false);
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'done': done};
  }
}
