# 🏥 MediQueue — Medical Appointment App

Flutter mobile app with personalized welcome, and full appointment management.

## Quick Start
```bash
cd mediqueue
flutter pub get
flutter run
```

## Demo Account
| Username | Password | Name |
|---|---|---|
| `admin` | `admin123` | Admin |

## Features
- ✅ Token-based auth (stored in SharedPreferences)
- ✅ Personalized "Good Morning, User!" welcome (blue gradient hero)
- ✅ Register new accounts
- ✅ 4-step appointment booking wizard
- ✅ Doctor browser with search & specialty filter
- ✅ Cancel appointments
- ✅ Session persistence across app restarts
- ✅ Blue & white Material 3 theme

## Project Structure (matches requirements)
```
lib/
├── main.dart
├── theme/app_theme.dart
├── models/ → user_model.dart, appointment_model.dart
├── services/ → auth_service.dart, auth_provider.dart, appointment_service.dart
├── screens/ → splash, login, register, main_shell, home, appointments, doctors, book_appointment, profile
└── widgets/ → gradient_button, status_badge, animated_logo
```
