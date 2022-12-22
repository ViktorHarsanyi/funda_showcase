import 'package:flutter/material.dart';
import 'package:funda_assignment/data/house_model.dart';
import 'package:funda_assignment/ui/views/single_overlay.dart';
import 'package:funda_assignment/ui/views/video_instance.dart';
import 'package:url_launcher/url_launcher.dart';

class BackPage extends StatefulWidget {
  final VoidCallback showMap;
  final HouseModel house;
  const BackPage({required this.house, required this.showMap, super.key});

  @override
  State<BackPage> createState() => _BackPageState();
}

class _BackPageState extends State<BackPage> with SingleOverlayMixin {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
            alignment: Alignment.center,
            child: Thumbnail(
              showVideo: () => insertOverlay(
                context,
                (remove) => VideoInstance(
                  widget.house.video.source.cdn.url,
                  cancel: remove,
                ),
              ),
              url: widget.house.video.imageUrl,
            )),
        Align(
            alignment: Alignment.topCenter,
            child: Image.asset(
              'assets/lamp.png',
              scale: 8,
            )),
        Align(
          alignment: Alignment.bottomCenter,
          child: Panel(
            widget.house,
            widget.showMap,
          ),
        )
      ],
    );
  }

  @override
  void didUpdateWidget(BackPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    remove();

  }

  @override
  void dispose() {
    remove();
    super.dispose();


  }
}

class Thumbnail extends StatelessWidget {
  final String url;
  final VoidCallback showVideo;
  const Thumbnail({
    super.key,
    required this.showVideo,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .75,
      height: MediaQuery.of(context).size.width * .75 / 2,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(url),
          fit: BoxFit.cover,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(24)),
      ),
      alignment: Alignment.topRight,
      child: IconButton(
        color: Colors.white70,
        onPressed: () {
          print('object');
          showVideo();},
        icon: const Icon(Icons.play_circle),
      ),
    );
  }
}

class Panel extends StatelessWidget {
  final VoidCallback showMap;
  final HouseModel house;
  const Panel(this.house, this.showMap, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .75,
      margin: const EdgeInsets.all(32.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.indigo[300]?.withOpacity(.5),
        borderRadius: const BorderRadius.all(Radius.circular(24)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
              onPressed: () {
                call(house.phone);
              },
              icon: const Icon(Icons.call)),
          IconButton(
              onPressed: () {
                showMap();
              },
              icon: const Icon(Icons.map)),
          IconButton(
              onPressed: () {
                openSite(house.shortUrl);
              },
              icon: const Icon(Icons.web)),
        ],
      ),
    );
  }

  void openSite(String url) async {
    if (!await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    )) {
      throw url;
    }
  }

  void call(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }
}
