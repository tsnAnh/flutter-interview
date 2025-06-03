import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

/// ConnectionStatus is a simple enum representing the internet connection status
enum ConnectionStatus { initial, connected, disconnected }

@lazySingleton
/// Cubit for tracking internet connectivity
class InternetConnectionCubit extends Cubit<ConnectionStatus> {
  final Connectivity _connectivity = Connectivity();
  final InternetConnectionChecker _connectionChecker =
      InternetConnectionChecker.createInstance();

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  Timer? _debounceTimer;

  /// Creates a new instance of [InternetConnectionCubit]
  InternetConnectionCubit() : super(ConnectionStatus.initial) {
    _initConnectivity();
  }

  /// Initializes connectivity monitoring
  Future<void> _initConnectivity() async {
    // Listen for connectivity changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      List<ConnectivityResult> result,
    ) {
      _debounceTimer?.cancel();
      _debounceTimer = Timer(const Duration(milliseconds: 100), () {
        if (!isClosed) {
          if (result.contains(ConnectivityResult.none)) {
            emit(ConnectionStatus.disconnected);
          } else {
            _checkInternetConnection();
          }
        }
      });
    });

    // Check connection status immediately
    await _checkInternetConnection();
  }

  /// Checks if there is actual internet connectivity
  Future<void> _checkInternetConnection() async {
    try {
      final bool hasConnection = await _connectionChecker.hasConnection;

      // Only emit if the cubit is still active
      if (!isClosed) {
        emit(
          hasConnection
              ? ConnectionStatus.connected
              : ConnectionStatus.disconnected,
        );
      }
    } catch (e) {
      // Only emit if the cubit is still active
      if (!isClosed) {
        emit(ConnectionStatus.disconnected);
      }
    }
  }

  /// Manually check the current connection status
  Future<void> checkConnection() async {
    await _checkInternetConnection();
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    _debounceTimer?.cancel();
    return super.close();
  }
}
