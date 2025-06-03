import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_management_app/blocs/user_list_bloc.dart';
import 'package:user_management_app/di/get_it.dart';
import 'package:user_management_app/models/users_response.dart';
import 'package:user_management_app/screens/user_detail_screen.dart';
import 'package:user_management_app/widgets/user_list_content_widget.dart';
import 'package:user_management_app/widgets/user_search_bar_widget.dart';
import 'package:user_management_app/widgets/user_loading_widget.dart';
import 'package:user_management_app/widgets/user_empty_state_widget.dart';
import 'package:user_management_app/widgets/user_error_state_widget.dart';
import 'package:user_management_app/widgets/user_no_connection_widget.dart';

import '../blocs/internet_connection_cubit.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => getIt<UserListBloc>(
            param1: context.read<InternetConnectionCubit>(),
          )..add(const UserListEvent.started()),
      child: const UserListView(),
    );
  }
}

class UserListView extends StatefulWidget {
  const UserListView({super.key});

  @override
  State<UserListView> createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<UserListBloc>().add(const UserListEvent.loadMore());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.95);
  }

  void _onClearSearch() {
    FocusManager.instance.primaryFocus?.unfocus();
    _searchController.clear();
    context.read<UserListBloc>().add(const UserListEvent.clearSearch());
  }

  void _onRefresh() {
    context.read<UserListBloc>().add(const UserListEvent.refresh());
  }

  void _onRetry() {
    FocusManager.instance.primaryFocus?.unfocus();
    context.read<UserListBloc>().add(const UserListEvent.retry());
  }

  void _onUserTap(UserData user) {
    Navigator.of(context).push(
      CupertinoPageRoute(builder: (context) => UserDetailScreen(user: user)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: const Text('Users'),
          backgroundColor: CupertinoColors.systemBackground.resolveFrom(
            context,
          ),
        ),
        child: Column(
          children: [
            UserSearchBarWidget(
              controller: _searchController,
              onClear: _onClearSearch,
              onChanged: (value) {
                if (value.trim().isEmpty) {
                  context.read<UserListBloc>().add(
                    const UserListEvent.clearSearch(),
                  );
                  return;
                }
                context.read<UserListBloc>().add(UserListEvent.search(value));
              },
            ),
            Expanded(
              child: BlocBuilder<UserListBloc, UserListState>(
                builder: (context, state) {
                  return _buildBody(state);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(UserListState state) {
    // Show content with overlay loading during refresh
    if (state.isRefreshing && state.users.isNotEmpty) {
      return Stack(
        children: [
          UserListContentWidget(
            scrollController: _scrollController,
            onRefresh: _onRefresh,
            onUserTap: _onUserTap,
          ),
          Positioned.fill(
            child: Container(
              color: CupertinoColors.systemBackground
                  .resolveFrom(context)
                  .withOpacity(0.3),
              child: const Center(
                child: CupertinoActivityIndicator(radius: 16),
              ),
            ),
          ),
        ],
      );
    }

    switch (state.status) {
      case UserListStatus.loading:
        return const UserLoadingWidget();
      case UserListStatus.empty:
        return UserEmptyStateWidget(
          onClearSearch: _onClearSearch,
          onRefresh: _onRefresh,
        );
      case UserListStatus.error:
        return UserErrorStateWidget(
          message: state.errorMessage ?? 'An error occurred',
          onRetry: _onRetry,
        );
      case UserListStatus.noConnection:
        return UserNoConnectionWidget(
          message: state.errorMessage ?? 'No internet connection',
          onTryAgain: _onRetry,
        );
      case UserListStatus.success:
      case UserListStatus.initial:
        return UserListContentWidget(
          scrollController: _scrollController,
          onRefresh: _onRefresh,
          onUserTap: _onUserTap,
        );
    }
  }
}
