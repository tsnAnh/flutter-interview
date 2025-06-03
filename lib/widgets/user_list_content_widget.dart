import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/user_list_bloc.dart';
import '../models/users_response.dart';
import '../utils.dart';
import 'user_card_widget.dart';
import 'user_load_more_indicator_widget.dart';

class UserListContentWidget extends StatelessWidget {
  final ScrollController scrollController;
  final VoidCallback? onRefresh;
  final void Function(UserData)? onUserTap;

  const UserListContentWidget({
    super.key,
    required this.scrollController,
    this.onRefresh,
    this.onUserTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserListBloc, UserListState>(
      builder: (context, state) {
        if (state.users.isEmpty && state.isLoading && !state.isRefreshing) {
          return const Center(child: CupertinoActivityIndicator(radius: 16));
        }

        return CustomScrollView(
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            CupertinoSliverRefreshControl(
              refreshTriggerPullDistance: 80,
              builder:
                  Platform.isIOS
                      ? buildAppleRefreshIndicator
                      : buildAndroidRefreshIndicator,
              onRefresh: () async {
                FocusManager.instance.primaryFocus?.unfocus();
                onRefresh?.call();
              },
            ),
            SliverPadding(
              padding: const EdgeInsets.only(bottom: 30),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index >= state.users.length) {
                      return const UserLoadMoreIndicatorWidget();
                    }
                    return UserCardWidget(
                      user: state.users[index],
                      onTap: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        onUserTap?.call(state.users[index]);
                      },
                    );
                  },
                  childCount:
                      state.users.length + (state.hasReachedMax ? 0 : 1),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
