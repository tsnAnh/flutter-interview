import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:user_management_app/blocs/internet_connection_cubit.dart';
import 'package:user_management_app/data/apis/user/user_api.dart';
import 'package:user_management_app/models/users_response.dart';
import 'package:user_management_app/utils/local_search_utils.dart';

part 'user_list_event.dart';
part 'user_list_state.dart';
part 'user_list_bloc.freezed.dart';
part 'user_list_bloc.g.dart';

@injectable
class UserListBloc extends HydratedBloc<UserListEvent, UserListState> {
  UserListBloc(this.userApi, @factoryParam this.internetConnectionCubit)
    : super(UserListState()) {
    on<_Started>(_onStarted);
    on<_LoadMore>(_onLoadMore);
    on<_Refresh>(_onRefresh);
    on<_Retry>(_onRetry);
    on<_Search>(_onSearch);
    on<_ClearSearch>(_onClearSearch);
  }

  final UserApi userApi;
  final InternetConnectionCubit internetConnectionCubit;
  static const Duration cacheExpiration = Duration(minutes: 1);

  bool get _hasConnection {
    return internetConnectionCubit.state != ConnectionStatus.disconnected;
  }

  void _emitNoConnectionState(Emitter<UserListState> emit) {
    emit(
      state.copyWith(
        status: UserListStatus.noConnection,
        isLoading: false,
        isLoadingMore: false,
        isRefreshing: false,
        errorMessage:
            'No internet connection. Please check your network settings and try again.',
        isFromCache: false,
      ),
    );
  }

  @override
  UserListState? fromJson(Map<String, dynamic> json) {
    try {
      final state = UserListState.fromJson(json);

      if (state.cacheTimestamp != null) {
        final now = DateTime.now();
        final cacheAge = now.difference(state.cacheTimestamp!);

        if (cacheAge > cacheExpiration) {
          return UserListState();
        }

        final restoredState = state.copyWith(
          users: state.cachedFirstPageUsers,
          allLoadedUsers: state.cachedFirstPageUsers,
          isFromCache: true,
          status: UserListStatus.success,
          isLoading: false,
          isRefreshing: false,
          currentPage: 1,
          hasReachedMax: false,
          isSearching: false,
          searchQuery: null,
          isLoadingMore: false,
          errorMessage: null,
          perPage: 10,
        );

        return restoredState;
      }

      return UserListState();
    } catch (e) {
      return UserListState();
    }
  }

  @override
  Map<String, dynamic>? toJson(UserListState state) {
    if (_shouldCacheState(state)) {
      final cacheState = state.copyWith(
        cachedFirstPageUsers:
            state.allLoadedUsers.isNotEmpty
                ? state.allLoadedUsers
                : state.users,
        cacheTimestamp:
            state.isFromCache ? state.cacheTimestamp : DateTime.now(),
        isLoading: false,
        isLoadingMore: false,
        isRefreshing: false,
        errorMessage: null,
      );

      return cacheState.toJson();
    }

    return null;
  }

  bool _shouldCacheState(UserListState state) {
    return state.currentPage == 1 &&
        !state.isSearching &&
        (state.users.isNotEmpty || state.allLoadedUsers.isNotEmpty) &&
        state.status == UserListStatus.success;
  }

  void _emitLoadingState(
    Emitter<UserListState> emit, {
    bool isSearching = false,
  }) {
    emit(
      state.copyWith(
        status: UserListStatus.loading,
        isLoading: true,
        errorMessage: null,
        isFromCache: false,
        isSearching: isSearching,
      ),
    );
  }

  Future<void> _onStarted(_Started event, Emitter<UserListState> emit) async {
    if (state.isFromCache && state.users.isNotEmpty) {
      return;
    }

    _emitLoadingState(emit);
    await _fetchUsers(emit);
  }

  Future<void> _onLoadMore(_LoadMore event, Emitter<UserListState> emit) async {
    if (state.isSearching) {
      return;
    }

    if (state.hasReachedMax || state.isLoadingMore) return;

    emit(state.copyWith(isLoadingMore: true));
    await _fetchUsers(emit, isLoadMore: true);
  }

  Future<void> _onRefresh(_Refresh event, Emitter<UserListState> emit) async {
    emit(
      state.copyWith(
        isRefreshing: true,
        isSearching: false,
        searchQuery: null,
        currentPage: 1,
        hasReachedMax: false,
        errorMessage: null,
      ),
    );

    await _fetchUsers(emit, isRefresh: true);
  }

  Future<void> _onRetry(_Retry event, Emitter<UserListState> emit) async {
    _emitLoadingState(emit);
    await _fetchUsers(emit);
  }

  Future<void> _onSearch(_Search event, Emitter<UserListState> emit) async {
    final query = event.query.trim();

    if (!LocalSearchUtils.isValidSearchQuery(query)) {
      return;
    }

    if (query.isEmpty) {
      add(const UserListEvent.clearSearch());
      return;
    }

    emit(
      state.copyWith(
        status: UserListStatus.loading,
        isLoading: true,
        isSearching: true,
        searchQuery: query,
      ),
    );

    final searchData =
        state.allLoadedUsers.isNotEmpty ? state.allLoadedUsers : state.users;

    await Future.delayed(const Duration(milliseconds: 100));

    final searchResults = LocalSearchUtils.searchUsers(searchData, query);

    if (searchResults.isEmpty) {
      _emitSearchEmptyState(emit, query);
    } else {
      emit(
        state.copyWith(
          status: UserListStatus.success,
          isLoading: false,
          users: searchResults,
          errorMessage: null,
        ),
      );
    }
  }

  Future<void> _onClearSearch(
    _ClearSearch event,
    Emitter<UserListState> emit,
  ) async {
    final usersToShow = _calculatePaginatedUsers(state.allLoadedUsers);

    emit(
      state.copyWith(
        status: UserListStatus.success,
        isLoading: false,
        isSearching: false,
        searchQuery: null,
        users: usersToShow,
        errorMessage: null,
        hasReachedMax:
            usersToShow.length < state.perPage ||
            state.allLoadedUsers.length <= state.currentPage * state.perPage,
      ),
    );
  }

  List<UserData> _calculatePaginatedUsers(List<UserData> allUsers) {
    if (allUsers.isEmpty) return [];

    final startIndex = (state.currentPage - 1) * state.perPage;

    if (startIndex >= allUsers.length) {
      final lastPageStart =
          ((allUsers.length - 1) ~/ state.perPage) * state.perPage;
      return allUsers.skip(lastPageStart).take(state.perPage).toList();
    }

    return allUsers.skip(startIndex).take(state.perPage).toList();
  }

  void _emitSearchEmptyState(Emitter<UserListState> emit, String query) {
    final searchEmptyMessage =
        'No users found matching "$query".\nTry adjusting your search criteria or check the spelling.';

    emit(
      state.copyWith(
        status: UserListStatus.empty,
        isLoading: false,
        users: [],
        errorMessage: searchEmptyMessage,
        isSearching: true,
        searchQuery: query,
      ),
    );
  }

  Future<void> _fetchUsers(
    Emitter<UserListState> emit, {
    bool isLoadMore = false,
    bool isRefresh = false,
  }) async {
    try {
      if (!_hasConnection) {
        _emitNoConnectionState(emit);
        return;
      }

      final page = isLoadMore ? state.currentPage + 1 : state.currentPage;
      final response = await userApi.getUserList(
        page: page,
        perPage: state.perPage,
      );

      response.fold(
        (error) => _handleApiError(emit, error),
        (data) => _handleApiSuccess(emit, data, isLoadMore, isRefresh),
      );
    } catch (e) {
      _handleUnexpectedError(emit, e);
    }
  }

  void _handleApiError(Emitter<UserListState> emit, dynamic error) {
    if (internetConnectionCubit.state == ConnectionStatus.disconnected) {
      _emitNoConnectionState(emit);
      return;
    }

    emit(
      state.copyWith(
        status: UserListStatus.error,
        isLoading: false,
        isLoadingMore: false,
        isRefreshing: false,
        errorMessage: error.message?.message ?? 'An unexpected error occurred',
        isFromCache: false,
      ),
    );
  }

  void _handleApiSuccess(
    Emitter<UserListState> emit,
    UsersResponse data,
    bool isLoadMore,
    bool isRefresh,
  ) {
    if (data.data.isEmpty && !isLoadMore) {
      _emitEmptyState(emit, data);
      return;
    }

    if (data.total == 0 && !isLoadMore) {
      _emitEmptyState(emit, data);
      return;
    }

    final newUsers = _calculateNewUsersList(data.data, isLoadMore, isRefresh);
    final hasReachedMax = data.page >= data.totalPages;

    final allLoadedUsers = _calculateAllLoadedUsers(
      data.data,
      isLoadMore,
      isRefresh,
    );

    emit(
      state.copyWith(
        status: UserListStatus.success,
        isLoading: false,
        isLoadingMore: false,
        isRefreshing: false,
        users: newUsers,
        allLoadedUsers: allLoadedUsers,
        hasReachedMax: hasReachedMax,
        totalPages: data.totalPages,
        totalUsers: data.total,
        currentPage: data.page,
        errorMessage: null,
        isFromCache: false,
      ),
    );
  }

  void _emitEmptyState(Emitter<UserListState> emit, UsersResponse data) {
    String emptyMessage;
    bool isSearching = state.isSearching;
    String? searchQuery = state.searchQuery;

    if (isSearching && searchQuery != null && searchQuery.isNotEmpty) {
      emptyMessage =
          'No users found matching "$searchQuery".\nTry adjusting your search criteria or check the spelling.';
    } else {
      emptyMessage =
          'No users available at the moment.\nPlease check back later or try refreshing the page.';
    }

    emit(
      state.copyWith(
        status: UserListStatus.empty,
        isLoading: false,
        isLoadingMore: false,
        isRefreshing: false,
        users: [],
        totalPages: data.totalPages,
        totalUsers: data.total,
        currentPage: data.page,
        isFromCache: false,
        errorMessage: emptyMessage,
        isSearching: isSearching,
        searchQuery: searchQuery,
      ),
    );
  }

  List<UserData> _calculateNewUsersList(
    List<UserData> newData,
    bool isLoadMore,
    bool isRefresh,
  ) {
    if (isRefresh) return newData;
    if (isLoadMore) return [...state.users, ...newData];
    return newData;
  }

  List<UserData> _calculateAllLoadedUsers(
    List<UserData> newData,
    bool isLoadMore,
    bool isRefresh,
  ) {
    if (isRefresh) return newData;
    if (isLoadMore) return [...state.allLoadedUsers, ...newData];
    return newData;
  }

  void _handleUnexpectedError(Emitter<UserListState> emit, Object error) {
    final errorString = error.toString().toLowerCase();
    final isNetworkError =
        errorString.contains('network') ||
        errorString.contains('connection') ||
        errorString.contains('timeout') ||
        errorString.contains('socket');

    if (isNetworkError &&
        internetConnectionCubit.state == ConnectionStatus.disconnected) {
      _emitNoConnectionState(emit);
      return;
    }

    emit(
      state.copyWith(
        status: UserListStatus.error,
        isLoading: false,
        isLoadingMore: false,
        isRefreshing: false,
        errorMessage: 'An unexpected error occurred: ${error.toString()}',
        isFromCache: false,
      ),
    );
  }
}
