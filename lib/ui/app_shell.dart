import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:funda_assignment/ui/pages/back_page.dart';
import 'package:funda_assignment/ui/pages/front_page.dart';
import 'package:funda_assignment/ui/views/brick_box.dart';
import 'package:funda_assignment/ui/views/single_overlay.dart';
import 'package:funda_assignment/ui/views/street_sign.dart';
import 'package:latlong2/latlong.dart';

import '../logic/data_cubit.dart';

const url =
    'https://media.istockphoto.com/id/1189847414/vector/seamless-brick-wall.jpg?s=170667a&w=0&k=20&c=77CvQmJO54rL-FV9l3D7f24ZmGshxQtaFpB-2vqnfj0=';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell>
    with SingleTickerProviderStateMixin, SingleOverlayMixin {
  late final BoxWidgetController boxController;
  late final AnimationController modalController;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataCubit, DataState>(

      builder: (context, state) {
        return state is DataLoaded
            ?  Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: CircleAvatar(backgroundImage: NetworkImage(state.house.video.thumbnailUrl), child: IconButton(
                color: Colors.white,
                splashColor: Theme.of(context).primaryColor,
                onPressed: boxController.rotate,
                icon: const Icon(Icons.rotate_90_degrees_ccw),
              ),),
            ),
          ),
          body: Stack(
                  alignment: Alignment.bottomCenter,
                  fit: StackFit.expand,
                  children: [
                    ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 10),
                        child: ShaderMask(
                          shaderCallback: (rect) {
                            return LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.orange,
                                  Colors.orangeAccent.withOpacity(0)
                                ],
                                stops: const [
                                  0.1,
                                  0.75
                                ]).createShader(rect);
                          },
                          blendMode: BlendMode.dstOut,
                          child: Image.network(state.house.hoofdFoto,
                              fit: BoxFit.cover,
                              alignment: Alignment.bottomCenter),
                        )),
                    Center(
                        child: AspectRatio(
                      aspectRatio: MediaQuery.of(context).aspectRatio,
                      child: BoxWidget(
                        onFinished: () {
                          showMap(context, state.house.coordinates?.latLng, state.house.adres,);
                        },
                        controller: boxController,
                        back: BackPage(
                          showMap: () {
                            showMap(context, state.house.coordinates?.latLng, state.house.adres);
                          }, house: state.house,
                        ),
                        child: FrontPage(state.house,),
                      ),
                    )),
                  ],
                ),

        ): const Center(child: CircularProgressIndicator.adaptive());
      },
    );
  }

  void showMap(BuildContext context, LatLng? latLng, String address, ) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => Stack(
        children: [
          MapWidget(latLng),
          Align(
            alignment: Alignment.topCenter,
            child: Column(

              children: [
                StreetSign(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(address.split(' ').first, style: const TextStyle(color: Colors.white,),),
                  ),
                ),
                StreetSign(
                  type: StreetSignType.houseNumber,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(address.split(' ').last, style: const TextStyle(color: Colors.white,),),
                  ),
                ),
              ],
            ),
          ),


        ],
      ),
      transitionAnimationController: modalController,
    );
  }

  @override
  void initState() {
    super.initState();
    // underlying state takes care of dispose.
    boxController = BoxWidgetController();
    modalController = BottomSheet.createAnimationController(this)
      ..duration = const Duration(seconds: 3);
  }

  @override
  void dispose() {
    modalController.dispose();
    super.dispose();
  }
}

class MapWidget extends StatelessWidget {
  final LatLng? latLng;
  const MapWidget(this.latLng, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),

      child: FlutterMap(
        options: MapOptions(
          center: latLng ?? LatLng(51.509364, -0.128928),
          zoom: 13,
        ),
        children: [
          TileLayer(
            backgroundColor: Colors.red,
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: latLng ?? LatLng(51.509364, -0.128928),
                builder: (ctx) => Image.network(
                    'https://assets.fstatic.nl/master_4015/assets/favicon-32x32.png'),
                anchorPos: AnchorPos.align(AnchorAlign.center),
              ),
            ],
          )
        ],
      ),
    );
  }
}

extension on MediaQueryData {
  double get aspectRatio => size.width / size.height;
}
