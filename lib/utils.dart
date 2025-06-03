import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildAppleRefreshIndicator(
  BuildContext context,
  RefreshIndicatorMode refreshState,
  double pulledExtent,
  double refreshTriggerPullDistance,
  double refreshIndicatorExtent,
) {
  const Curve opacityCurve = Interval(0.4, 0.8, curve: Curves.easeInOut);
  return Align(
    alignment: Alignment.bottomCenter,
    child: Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child:
          refreshState == RefreshIndicatorMode.drag
              ? Opacity(
                opacity: opacityCurve.transform(
                  min(pulledExtent / refreshTriggerPullDistance, 1.0),
                ),
                child: const Icon(
                  CupertinoIcons.down_arrow,
                  color: CupertinoColors.inactiveGray,
                  size: 24.0,
                ),
              )
              : (refreshState == RefreshIndicatorMode.refresh ||
                  refreshState == RefreshIndicatorMode.armed)
              ? const CupertinoActivityIndicator(radius: 14)
              : const SizedBox.shrink(),
    ),
  );
}

Widget buildAndroidRefreshIndicator(
  BuildContext context,
  RefreshIndicatorMode refreshState,
  double pulledExtent,
  double refreshTriggerPullDistance,
  double refreshIndicatorExtent,
) {
  const Curve opacityCurve = Interval(0.4, 0.8, curve: Curves.easeInOut);
  return Align(
    alignment: Alignment.bottomCenter,
    child: Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child:
          refreshState == RefreshIndicatorMode.drag
              ? Opacity(
                opacity: opacityCurve.transform(
                  min(pulledExtent / refreshTriggerPullDistance, 1.0),
                ),
                child: const Icon(
                  Icons.arrow_downward,
                  color: CupertinoColors.inactiveGray,
                  size: 24.0,
                ),
              )
              : (refreshState == RefreshIndicatorMode.refresh ||
                  refreshState == RefreshIndicatorMode.armed)
              ? const CupertinoActivityIndicator(radius: 14)
              : const SizedBox.shrink(),
    ),
  );
}
