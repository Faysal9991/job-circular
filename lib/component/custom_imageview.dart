
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:shimmer/shimmer.dart';

Widget customNetworkImage(BuildContext context, String imageUrl,
    {double? height, BoxFit boxFit = BoxFit.cover}) {
  return CachedNetworkImage(
    imageUrl: imageUrl,
    fit: boxFit,
    width: MediaQuery.of(context).size.width,
    height: height == 0 ? MediaQuery.of(context).size.height : height,
    cacheKey: imageUrl,
    cacheManager:
        CacheManager(Config(imageUrl, stalePeriod: const Duration(hours: 5))),
    errorWidget: (context, url, error) => const Icon(Icons.error),
    placeholder: ((context, url) => Center(
          child: Stack(
            children: [
              Shimmer.fromColors(
                  baseColor: Colors.black.withOpacity(.1),
                  highlightColor: Colors.grey.withOpacity(.1),
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                  )),
              Opacity(
                  opacity: 0.2,
                  child: Image.asset("assets/background/not_found.png", height: 100, width: 100))
            ],
          ),
        )),
  );
}
