class UserModel {
  final String id, name, username, email, phone, token;
  final DateTime createdAt;
  UserModel({required this.id, required this.name, required this.username,
    required this.email, this.phone = '', required this.token, required this.createdAt});
  factory UserModel.fromJson(Map<String, dynamic> j) => UserModel(
    id: j['id'], name: j['name'], username: j['username'], email: j['email'],
    phone: j['phone'] ?? '', token: j['token'], createdAt: DateTime.parse(j['createdAt']));
  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'username': username,
    'email': email, 'phone': phone, 'token': token, 'createdAt': createdAt.toIso8601String()};
  String get firstName => name.split(' ').first;
  String get initials => name.split(' ').take(2)
    .map((e) => e.isEmpty ? '' : e[0].toUpperCase()).join();
}
