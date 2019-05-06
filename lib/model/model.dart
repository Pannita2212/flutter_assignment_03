import 'dart:convert';

Todo todoFromJson(String str) {
    final jsonData = json.decode(str);
    return Todo.fromMap(jsonData);
}

String todoToJson(Todo data) {
    final dyn = data.toMap();
    return json.encode(dyn);
}

class Todo {
    String id; //id Document
    String title;
    int done;

    Todo({
        this.id, this.title, this.done
    });

    factory Todo.fromMap(Map<String, dynamic> json) => new Todo(
        id: json["id"],
        title: json["title"],
        done: json["done"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "done": done,
    };

    @override
  String toString() {
    return title;
  }
}