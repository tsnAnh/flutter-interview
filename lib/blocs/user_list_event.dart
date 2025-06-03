part of 'user_list_bloc.dart';

@freezed
abstract class UserListEvent with _$UserListEvent {
  const factory UserListEvent.started() = _Started;
  const factory UserListEvent.loadMore() = _LoadMore;
  const factory UserListEvent.refresh() = _Refresh;
  const factory UserListEvent.retry() = _Retry;
  const factory UserListEvent.search(String query) = _Search;
  const factory UserListEvent.clearSearch() = _ClearSearch;
}
