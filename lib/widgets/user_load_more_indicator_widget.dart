import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/user_list_bloc.dart';

class UserLoadMoreIndicatorWidget extends StatelessWidget {
  const UserLoadMoreIndicatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserListBloc, UserListState>(
      builder: (context, state) {
        if (state.isLoadingMore) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CupertinoActivityIndicator()),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
