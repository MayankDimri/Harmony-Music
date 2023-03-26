import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../models/album.dart';
import '../../models/playlist.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget(
      {super.key,
      this.song,
      this.playlist,
      this.album,
      this.isLargeImage = false,
      this.isMediumImage = false});
  final MediaItem? song;
  final Playlist? playlist;
  final Album? album;
  final bool isLargeImage;
  final bool isMediumImage;

  @override
  Widget build(BuildContext context) {
    String imageUrl = song != null
        ? song!.artUri.toString()
        : playlist != null
            ? playlist!.thumbnailUrl
            : album != null
                ? album!.thumbnailUrl
                : "";
    String cacheKey = song != null
        ? "${song!.id}_song"
        : playlist != null
            ? "${playlist!.playlistId}_playlist"
            : album != null
                ? "${album!.browseId}_album"
                : "";
    return GetPlatform.isWeb
        ? Image.network(
            imageUrl,
            fit: BoxFit.fitHeight,
          )
        : ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: CachedNetworkImage(
              memCacheHeight: isLargeImage
                  ? 500
                  : isMediumImage
                      ? 300
                      : 150,
              cacheKey: cacheKey,
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              progressIndicatorBuilder: ((_, __, ___) => Shimmer.fromColors(
                  baseColor: Colors.grey[500]!,
                  highlightColor: Colors.grey[300]!,
                  enabled: true,
                  direction: ShimmerDirection.ltr,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white54,
                    ),
                  ))),
            ),
          );
  }
}
