import 'package:freezed_annotation/freezed_annotation.dart';

part 'error_response.freezed.dart';

@freezed
abstract class ErrorResponse with _$ErrorResponse {
  const factory ErrorResponse({
    @Default(0) int? statusCode,
    @Default('An error occurred') String? message,
  }) = _ErrorResponse;

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    // Safe parsing with fallback values
    return ErrorResponse(
      statusCode: _parseStatusCode(json),
      message: _parseMessage(json),
    );
  }

  static int _parseStatusCode(Map<String, dynamic> json) {
    final dynamic statusCode =
        json['statusCode'] ?? json['status_code'] ?? json['code'];
    if (statusCode is int) return statusCode;
    if (statusCode is String) {
      final parsed = int.tryParse(statusCode);
      if (parsed != null) return parsed;
    }
    return 0;
  }

  static String _parseMessage(Map<String, dynamic> json) {
    final dynamic message =
        json['message'] ??
        json['error'] ??
        json['detail'] ??
        json['description'];
    if (message is String && message.isNotEmpty) return message;
    if (message is Map) {
      // Sometimes error messages are nested
      final nested =
          message['message'] ?? message['error'] ?? message['detail'];
      if (nested is String && nested.isNotEmpty) return nested;
    }
    return 'An error occurred';
  }
}
