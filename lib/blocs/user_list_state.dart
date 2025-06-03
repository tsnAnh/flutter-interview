part of 'user_list_bloc.dart';

@freezed
abstract class UserListState with _$UserListState {
  factory UserListState({
    @Default([]) List<UserData> users,
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingMore,
    @Default(false) bool isRefreshing,
    @Default(false) bool hasReachedMax,
    @Default(1) int currentPage,
    @Default(10) int perPage,
    @Default(0) int totalPages,
    @Default(0) int totalUsers,
    String? errorMessage,
    String? searchQuery,
    @Default(false) bool isSearching,
    @Default(UserListStatus.initial) UserListStatus status,
    // Cache-related fields
    DateTime? cacheTimestamp,
    @Default(false) bool isFromCache,
    @Default([]) List<UserData> cachedFirstPageUsers,
    // Local search fields
    @Default([])
    List<UserData> allLoadedUsers, // All users loaded so far (for local search)
  }) = _UserListState;

  // Add factory constructor for JSON serialization
  factory UserListState.fromJson(Map<String, dynamic> json) =>
      _$UserListStateFromJson(json);
}

enum UserListStatus { initial, loading, success, error, noConnection, empty }
