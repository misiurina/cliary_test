import 'package:flutter/material.dart';

import 'cliary_sliver_app_bar.dart';

class CliaryScrollView extends StatelessWidget {
  const CliaryScrollView({
    Key? key,
    required this.appBar,
    required this.child,
  }) : super(key: key);

  final CliarySliverAppBar appBar;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        appBar,
        SliverToBoxAdapter(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - (AppBar().preferredSize.height + MediaQuery.of(context).padding.top),
            ),
            child: child,
          ),
        ),
      ],
    );
  }
}
