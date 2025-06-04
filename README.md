# User Management App

A Flutter application for managing and viewing user data with offline support, search functionality, and modern UI/UX design.

## Overview

This app demonstrates modern Flutter development practices including:
- Clean Architecture with BLoC pattern
- Dependency Injection with GetIt
- Network API integration with Dio
- Offline data persistence with HydratedBloc
- State management with flutter_bloc
- Navigation with GoRouter
- Responsive UI with Cupertino design

## Features

- **User List View**: Browse users with pagination support
- **User Search**: Real-time search functionality with debouncing
- **User Details**: Detailed view for individual users
- **Offline Support**: App works without internet connection using cached data
- **Pull-to-Refresh**: Refresh user data with swipe gesture
- **Error Handling**: Comprehensive error states and retry mechanisms
- **Loading States**: Smooth loading indicators and skeleton screens
- **Infinite Scroll**: Automatic loading of more users as you scroll

## Architecture

### Project Structure

```
lib/
├── blocs/                 # BLoC state management
│   ├── user_list_bloc.dart
│   ├── user_list_event.dart
│   ├── user_list_state.dart
│   └── internet_connection_cubit.dart
├── data/                  # Data layer
│   └── apis/
│       ├── base/          # Base API classes and error handling
│       └── user/          # User-specific API calls
├── di/                    # Dependency injection setup
├── models/                # Data models with JSON serialization
│   └── users_response.dart
├── screens/               # UI screens
│   ├── user_list_screen.dart
│   └── user_detail_screen.dart
├── widgets/               # Reusable UI components
├── utils/                 # Utility functions and helpers
├── router.dart           # Navigation setup
└── main.dart             # App entry point
```

### State Management

The app uses the **BLoC pattern** for state management:

- `UserListBloc`: Manages user list state, pagination, search, and API calls
- `InternetConnectionCubit`: Monitors internet connectivity
- `HydratedBloc`: Provides automatic state persistence for offline support

### Data Flow

1. **API Layer**: `UserApi` handles HTTP requests using Dio
2. **BLoC Layer**: Business logic and state management
3. **UI Layer**: Reactive widgets that rebuild based on state changes
4. **Persistence**: HydratedBloc automatically saves/restores state

## Dependencies

### Core Dependencies

- `flutter_bloc: ^9.1.1` - State management
- `dio: ^5.8.0+1` - HTTP client
- `go_router: ^15.1.2` - Navigation
- `hydrated_bloc: ^10.0.0` - State persistence
- `get_it: ^8.0.3` - Dependency injection
- `injectable: ^2.5.0` - DI code generation

### Development Dependencies

- `freezed: 3.0.6` - Immutable data classes
- `json_serializable: 6.9.5` - JSON serialization
- `build_runner: 2.4.15` - Code generation
- `injectable_generator: 2.7.0` - DI code generation

### Utility Dependencies

- `connectivity_plus: ^6.0.5` - Network connectivity monitoring
- `internet_connection_checker: ^3.0.1` - Internet connection validation
- `diacritic: ^0.1.5` - Text search normalization
- `dart3z: ^0.11.1` - Functional programming utilities

## Getting Started

### Prerequisites

- Flutter SDK 3.7.2 or later
- Dart SDK 3.7.2 or later
- Android Studio / VS Code with Flutter extensions

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd user_management_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code (for models and DI)**
   ```bash
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Development Setup

For development with hot reload and debugging:

```bash
# Run in debug mode
flutter run --debug

# Run with specific device
flutter run -d <device-id>

# Run on web
flutter run -d chrome
```

## API Integration

The app integrates with [JSONPlaceholder](https://reqres.in/) API for user data:

- **Base URL**: `https://reqres.in/api`
- **Endpoints**:
  - `GET /users` - Fetch paginated user list
  - Query parameters: `page`, `per_page`, `delay`

### API Response Format

```json
{
  "page": 1,
  "per_page": 6,
  "total": 12,
  "total_pages": 2,
  "data": [
    {
      "id": 1,
      "email": "george.bluth@reqres.in",
      "first_name": "George",
      "last_name": "Bluth",
      "avatar": "https://reqres.in/img/faces/1-image.jpg"
    }
  ],
  "support": {
    "url": "https://reqres.in/#support-heading",
    "text": "To keep ReqRes free, contributions towards server costs are appreciated!"
  }
}
```

## Code Generation

The project uses code generation for:

- **Freezed**: Immutable data classes and unions
- **JSON Serializable**: JSON serialization/deserialization
- **Injectable**: Dependency injection setup

Run code generation:
```bash
flutter packages pub run build_runner build
```

Watch for changes during development:
```bash
flutter packages pub run build_runner watch
```

## Testing

### Running Tests

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run integration tests
flutter test integration_test/
```

### Test Structure

- `test/` - Unit and widget tests
- `integration_test/` - Integration tests
- `test_driver/` - Driver tests for automated testing

## Deployment

### Android

1. Build APK:
   ```bash
   flutter build apk --release
   ```

2. Build App Bundle (recommended for Play Store):
   ```bash
   flutter build appbundle --release
   ```

### iOS

1. Build for iOS:
   ```bash
   flutter build ios --release
   ```

2. Archive in Xcode for App Store distribution

### Web

1. Build for web:
   ```bash
   flutter build web --release
   ```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Style

- Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use `flutter analyze` to check for issues
- Format code with `dart format`

### Development Guidelines

- Write unit tests for business logic
- Use BLoC pattern for state management
- Follow the established project structure
- Add proper error handling
- Document complex functionality

## Troubleshooting

### Common Issues

1. **Build errors after pulling changes**
   ```bash
   flutter clean
   flutter pub get
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

2. **Dependency conflicts**
   ```bash
   flutter pub deps
   flutter pub upgrade
   ```

3. **Code generation issues**
   ```bash
   flutter packages pub run build_runner clean
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

### Performance

- Use `flutter run --profile` for performance profiling
- Monitor network calls in debug mode
- Check memory usage with Flutter Inspector

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [ReqRes API](https://reqres.in/) for providing the test API
- Flutter team for the amazing framework
- BLoC library contributors for excellent state management
- All open-source contributors whose packages made this project possible
