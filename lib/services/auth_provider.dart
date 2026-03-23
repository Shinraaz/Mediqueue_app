import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/appointment_service.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthProvider extends ChangeNotifier {
  final _svc = AuthService();
  AuthStatus _status = AuthStatus.unknown;
  UserModel? _user;
  bool _loading = false;
  String? _error;

  AuthStatus get status => _status;
  UserModel? get user   => _user;
  bool get isLoading    => _loading;
  String? get error     => _error;
  bool get isAuth       => _status == AuthStatus.authenticated;

  Future<void> init() async {
    final u = await _svc.restore();
    if (u != null) {
      _user = u; _status = AuthStatus.authenticated;
      appointmentService.seedDemo(u.name);
    } else { _status = AuthStatus.unauthenticated; }
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    _set(loading: true, error: null);
    try {
      _user = await _svc.login(username, password);
      _status = AuthStatus.authenticated;
      appointmentService.seedDemo(_user!.name);
      notifyListeners(); return true;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _status = AuthStatus.unauthenticated;
      notifyListeners(); return false;
    } finally { _set(loading: false); }
  }

  Future<bool> register({required String name, required String username,
    required String email, required String password, String phone = ''}) async {
    _set(loading: true, error: null);
    try {
      _user = await _svc.register(name:name, username:username,
        email:email, password:password, phone:phone);
      _status = AuthStatus.authenticated;
      notifyListeners(); return true;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners(); return false;
    } finally { _set(loading: false); }
  }

  Future<void> logout() async {
    await _svc.logout(); _user = null;
    _status = AuthStatus.unauthenticated; notifyListeners();
  }

  void clearError() { _error = null; notifyListeners(); }

  void _set({bool? loading, String? error}) {
    if (loading != null) _loading = loading;
    if (error != null) _error = error;
    notifyListeners();
  }
}
