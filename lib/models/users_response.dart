import 'package:freezed_annotation/freezed_annotation.dart';

part 'users_response.freezed.dart';
part 'users_response.g.dart';

@freezed
abstract class UsersResponse with _$UsersResponse {
  const factory UsersResponse({
    required int page,
    @JsonKey(name: 'per_page') required int perPage,
    required int total,
    @JsonKey(name: 'total_pages') required int totalPages,
    required List<UserData> data,
    required Support support,
  }) = _UsersResponse;

  factory UsersResponse.fromJson(Map<String, dynamic> json) =>
      _$UsersResponseFromJson(json);
}

@freezed
abstract class UserData with _$UserData {
  const factory UserData({
    required int id,
    required String email,
    @JsonKey(name: 'first_name') required String firstName,
    @JsonKey(name: 'last_name') required String lastName,
    required String avatar,
  }) = _UserData;

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);
}

@freezed
abstract class Support with _$Support {
  const factory Support({
    required String url,
    required String text,
  }) = _Support;

  factory Support.fromJson(Map<String, dynamic> json) =>
      _$SupportFromJson(json);
}
