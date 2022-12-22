import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';


class VideoInstance extends StatefulWidget {
  final String src;
  final VoidCallback cancel;
  const VideoInstance(this.src,{required this.cancel, super.key});

  @override
  VideoInstanceState createState() => VideoInstanceState();
}

class VideoInstanceState extends State<VideoInstance> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      widget.src,)
      ..initialize().then((_) {
        setState(() {});
      })..play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        )
            : const CircularProgressIndicator.adaptive(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
         widget.cancel();
        },
        child: const Icon(
          Icons.cancel,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

