import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/user_model.dart';

class AuthService {
  static const _tokenKey = 'mq_token';
  static const _userKey = 'mq_user';
  static const _uuid = Uuid();

  static final Map<String, Map<String, String>> _db = {
    'admin': {
      'id': 'u001',
      'name': 'Admin',
      'username': 'admin',
      'email': 'admin@mediqueue.ph',
      'password': 'admin123',
      'phone': '09123456789'
    },
  };

  Future<UserModel> login(String username, String password) async {
    await Future.delayed(const Duration(milliseconds: 1100));
    final key = username.trim().toLowerCase();
    final row = _db[key];
    if (row == null) throw Exception('No account found for that username.');
    if (row['password'] != password)
      throw Exception('Incorrect password. Please try again.');
    final token = _makeToken(row['id']!);
    final user = UserModel(
        id: row['id']!,
        name: row['name']!,
        username: row['username']!,
        email: row['email']!,
        phone: row['phone'] ?? '',
        token: token,
        createdAt: DateTime.now());
    await _persist(user);
    return user;
  }

  Future<UserModel> register(
      {required String name,
      required String username,
      required String email,
      required String password,
      String phone = ''}) async {
    await Future.delayed(const Duration(milliseconds: 900));
    final key = username.trim().toLowerCase();
    if (_db.containsKey(key)) throw Exception('Username already taken.');
    final id = _uuid.v4().substring(0, 8);
    _db[key] = {
      'id': id,
      'name': name.trim(),
      'username': key,
      'email': email.trim(),
      'password': password,
      'phone': phone
    };
    final token = _makeToken(id);
    final user = UserModel(
        id: id,
        name: name.trim(),
        username: key,
        email: email.trim(),
        phone: phone,
        token: token,
        createdAt: DateTime.now());
    await _persist(user);
    return user;
  }

  Future<void> logout() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(_tokenKey);
    await p.remove(_userKey);
  }

  Future<UserModel?> restore() async {
    final p = await SharedPreferences.getInstance();
    final raw = p.getString(_userKey);
    if (raw == null) return null;
    try {
      return UserModel.fromJson(jsonDecode(raw));
    } catch (_) {
      return null;
    }
  }

  String _makeToken(String id) =>
      'mq_${id}_${DateTime.now().millisecondsSinceEpoch}_${_uuid.v4().replaceAll('-', '')}';

  Future<void> _persist(UserModel u) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_tokenKey, u.token);
    await p.setString(_userKey, jsonEncode(u.toJson()));
  }
}
