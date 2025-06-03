
import 'error_response.dart';


sealed class NetworkError {
  const NetworkError({
    required this.exception,
    this.message,
  });

  final Exception exception;
  final ErrorResponse? message;
}


// Unknown error singleton
final class UnknownNetworkError extends NetworkError {
  factory UnknownNetworkError() => _instance;

  const UnknownNetworkError._({required super.exception, super.message});

  static final UnknownNetworkError _instance = UnknownNetworkError._(
    exception: Exception('Unknown error'),
    message:
    const ErrorResponse(message: 'Something went wrong! Please try again.'),
  );
}

final class NotFound extends NetworkError {
  const NotFound({required super.exception, super.message});
}

final class InternalServerError extends NetworkError {
  const InternalServerError({required super.exception, super.message});
}

final class Unauthorized extends NetworkError {
  const Unauthorized({required super.exception, super.message});
}

final class BadRequest extends NetworkError {
  const BadRequest({required super.exception, super.message});
}

final class Timeout extends NetworkError {
  const Timeout({
    required super.exception,
    super.message,
  });
}

final class Forbidden extends NetworkError {
  const Forbidden({required super.exception, super.message});
}
