import 'package:flutter/cupertino.dart';

class CachedNetworkImageWidget extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final BorderRadius? borderRadius;

  const CachedNetworkImageWidget({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return _buildErrorWidget(context);
    }

    Widget imageWidget = Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _buildLoadingWidget(context);
      },
      errorBuilder: (context, error, stackTrace) {
        return _buildErrorWidget(context);
      },
    );

    if (borderRadius != null) {
      imageWidget = ClipRRect(borderRadius: borderRadius!, child: imageWidget);
    }

    return imageWidget;
  }

  Widget _buildLoadingWidget(BuildContext context) {
    return placeholder ??
        Container(
          width: width,
          height: height,
          color: CupertinoColors.systemGrey6.resolveFrom(context),
          child: const Center(child: CupertinoActivityIndicator()),
        );
  }

  Widget _buildErrorWidget(BuildContext context) {
    return errorWidget ??
        Container(
          width: width,
          height: height,
          color: CupertinoColors.systemGrey5.resolveFrom(context),
          child: Icon(
            CupertinoIcons.person_circle,
            size:
                (width != null && height != null)
                    ? (width! < height! ? width! * 0.6 : height! * 0.6)
                    : 40,
            color: CupertinoColors.systemGrey.resolveFrom(context),
          ),
        );
  }
}
