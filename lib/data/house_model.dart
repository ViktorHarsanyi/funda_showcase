import 'dart:convert';

import 'package:funda_assignment/data/coordinate_model.dart';

HouseModel houseModelFromJson(String str) =>
    HouseModel.fromJson(
        json.decode(
            str
        )
    );

class HouseModel {
  HouseModel({
    this.coordinates,
    required this.phone,
    required this.aangebodenSindsTekst,
    required this.aantalBadkamers,
    required this.aantalKamers,
    required this.adres,
    required this.hoofdFoto,
    required this.hoofdFotoSecure,
    required this.hoofdTuinType,
    required this.mediaFoto,
    required this.mobileUrl,
    required this.plaats,
    required this.postcode,
    required this.video,
    required this.koopprijs,
    required this.shortUrl,
    required this.tuin,
  });

  final HouseCoordinate? coordinates;
  final String aangebodenSindsTekst;
  final int aantalBadkamers;
  final int aantalKamers;
  final String adres;
  final String hoofdFoto;
  final String hoofdFotoSecure;
  final String hoofdTuinType;
  final List<String> mediaFoto;
  final String mobileUrl;
  final String plaats;
  final String postcode;
  final Thumbnails video;
  final int koopprijs;
  final String phone;
  final String shortUrl;
  final String tuin;

  factory HouseModel.fromJson(Map<String, dynamic> json) => HouseModel(
        aangebodenSindsTekst: json["AangebodenSindsTekst"],
        aantalBadkamers: json["AantalBadkamers"],
        aantalKamers: json["AantalKamers"],
        adres: json["Adres"],
        hoofdFoto: json["HoofdFoto"],
        hoofdFotoSecure: json["HoofdFotoSecure"],
        hoofdTuinType: json["HoofdTuinType"],
        mediaFoto: List<String>.from(json["Media-Foto"].map((x) => x)),
        mobileUrl: json["MobileURL"],
        plaats: json["Plaats"],
        postcode: json["Postcode"],
        video: Thumbnails.fromJson(json["Video"]),
        koopprijs: json["Koopprijs"],
        shortUrl: json["ShortURL"],
        tuin: json["Tuin"],
        phone: json["MakelaarTelefoon"],
      );

HouseModel copyWithCoord(HouseCoordinate coordinate) =>
    HouseModel(
      coordinates: coordinate,
      aangebodenSindsTekst: aangebodenSindsTekst,
      aantalBadkamers: aantalBadkamers,
      aantalKamers: aantalKamers,
      adres:adres,
      hoofdFoto: hoofdFoto,
      hoofdFotoSecure: hoofdFotoSecure,
      hoofdTuinType: hoofdTuinType,
      mediaFoto: mediaFoto,
      mobileUrl:mobileUrl,
      plaats: plaats,
      postcode: postcode,
      video: video,
      koopprijs: koopprijs,
      shortUrl: shortUrl,
      tuin: tuin,
      phone: phone,
    );
}

class Thumbnails {
  Thumbnails({
    required this.imageUrl,
    required this.thumbnailUrl,
    required this.source,
  });

  final String imageUrl;
  final String thumbnailUrl;
  final VideoSource source;

  factory Thumbnails.fromJson(Map<String, dynamic> json) =>
      Thumbnails(
        imageUrl: json["ImageUrl"],
        thumbnailUrl: json["ThumbnailUrl"],
        source: VideoSource.fromJson(json["Videos"].first),
      );
}
List<VideoSource> videoSourceFromJson(String str) => List<VideoSource>.from(json.decode(str).map((x) => VideoSource.fromJson(x)));
class VideoSource {
  VideoSource(
    this.cdn,
  );

  final Cdn cdn;


  factory VideoSource.fromJson(Map<String, dynamic> json) => VideoSource(
   List<Cdn>.from(json["Cdns"].map((x) => Cdn.fromJson(x))).first,
  );

}


class Cdn {
  Cdn(
    this.url,
  );

  final String url;

  factory Cdn.fromJson(Map<String, dynamic> json) => Cdn(
    json["Url"],
  );

  Map<String, dynamic> toJson() => {
    "Url": url,
  };
}