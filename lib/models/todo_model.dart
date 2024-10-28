// ignore_for_file: public_member_api_docs, sort_constructors_first
class TodoModel {
  final String name;
  final DateTime createdAt;

  TodoModel({required this.name, required this.createdAt});


  @override
  String toString() => 'TodoModel(name: $name, createdAt: $createdAt)';
}
