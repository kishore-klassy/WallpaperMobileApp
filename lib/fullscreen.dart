import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';

class FullScreen extends StatefulWidget {
  final String imageUrl;
  FullScreen({Key? key, required this.imageUrl}) : super(key: key);

  @override
  _FullScreenState createState() => _FullScreenState();
}

class _FullScreenState extends State<FullScreen> {
  Future<void> setWallpaper() async {
    int location = WallpaperManager.HOME_SCREEN;
    var file = await DefaultCacheManager().getSingleFile(widget.imageUrl);

    if (file != null) {
      try {
        final result = await WallpaperManager.setWallpaperFromFile(
          file.path,
          location,
        );
        if (result) {
          print("Wallpaper set successfully!");
        } else {
          print("Failed to set wallpaper.");
        }
      } catch (e) {
        print("Error setting wallpaper: $e");
      }
    } else {
      print("Failed to get the image file from cache.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: Image.network(
                widget.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              // Execute setWallpaper in a background isolate
              await Future.delayed(Duration.zero);
              await setWallpaper();
            },
            child: Container(
              width: double.infinity,
              height: 60,
              color: Colors.black,
              child: Center(
                child: Text(
                  "Set Wallpaper",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
