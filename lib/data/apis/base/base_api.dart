import 'dart:async';

import 'package:dart3z/dartz.dart';
import 'package:dio/dio.dart';

import 'error.dart';
import 'error_response.dart';
import 'network_error_code.dart';

abstract interface class ApiPath {
  static const userList = 'users';
  static String getUserDetail(String id) => 'users/$id';
}

abstract base class Api {
  const Api(this.dio);
  final Dio dio;

  static const defaultConnectTimeout = 30000;
  static const defaultReceiveTimeout = 30000;
  static const defaultSendTimeout = 30000;
  static const baseUrl = 'https://reqres.in/api/';
  static const apiKey = 'reqres-free-v1';

  Future<Either<NetworkError, T>> withTimeoutRequest<T>(
    Future<T> Function() request,
  ) async {
    try {
      final either = await catchAsync(
        () => request(),
      ).timeout(Duration(milliseconds: defaultConnectTimeout));
      return either.leftMap(mapErrorToNetworkError);
    } on TimeoutException catch (timeoutException) {
      return Left<NetworkError, T>(Timeout(exception: timeoutException));
    }
  }

  Future<Option<T>> withTimeoutRequestOption<T>(
    Future<T> Function() request,
  ) async {
    try {
      final either = await catchAsync(
        () => request(),
      ).timeout(Duration(milliseconds: defaultConnectTimeout));
      return either.toOption();
    } on TimeoutException {
      return const None();
    }
  }

  NetworkError mapErrorToNetworkError(Object? error) {
    if (error is DioException) {
      final code = error.response?.statusCode;
      if (code == null) {
        return UnknownNetworkError();
      }

      switch (code) {
        case NetworkStatusCode.notFound:
          return NotFound(
            exception: error,
            message: const ErrorResponse(
              statusCode: NetworkStatusCode.notFound,
              message:
                  'The requested resource was not found. Please check and try again.',
            ),
          );
        case NetworkStatusCode.badRequest:
          return BadRequest(
            exception: error,
            message: const ErrorResponse(
              statusCode: NetworkStatusCode.badRequest,
              message:
                  'Invalid request. Please check your input and try again.',
            ),
          );
        case NetworkStatusCode.forbidden:
          return Forbidden(
            exception: error,
            message: const ErrorResponse(
              statusCode: NetworkStatusCode.forbidden,
              message:
                  'Access denied. You don\'t have permission to access this resource.',
            ),
          );

        case NetworkStatusCode.internalServerError:
          return InternalServerError(
            exception: error,
            message: const ErrorResponse(
              statusCode: NetworkStatusCode.internalServerError,
              message: 'Server error occurred. Please try again later.',
            ),
          );

        case NetworkStatusCode.unauthorized:
          return Unauthorized(
            exception: error,
            message: const ErrorResponse(
              statusCode: NetworkStatusCode.unauthorized,
              message: 'Authentication required. Please log in and try again.',
            ),
          );
        default:
          return UnknownNetworkError();
      }
    } else if (error is TimeoutException) {
      return Timeout(
        exception: error,
        message: const ErrorResponse(
          message:
              'Request timed out due to network or server issues. Please try again..',
        ),
      );
    }

    return UnknownNetworkError();
  }
}
