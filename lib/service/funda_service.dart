import 'package:funda_assignment/data/coordinate_model.dart';
import 'package:http/http.dart' as http;

import '../data/house_model.dart';

const _url =
    'https://partnerapi.funda.nl/feeds/Aanbod.svc/json/detail/ac1b0b1572524640a0ecc54de453ea9f/koop/c8167628-0c8e-488b-9033-c81ae2679256/';
const _geoUrlBase = 'https://nominatim.openstreetmap.org/search.php?country=Netherlands&'; //city=Amsterdam&postalcode=1034JP&street=Schepenlaan%2049&format=jsonv2

class FundaService {
  Future<http.Response> loadRawHouse() async {
    final response = await http.get(Uri.parse(_url));
    return response;
  }

  Future<HouseCoordinate> loadCoordinates(HouseModel house) async {
    final response = await http.get(Uri.parse('${_geoUrlBase}postalcode=${house.postcode}&street=${house.adres}&format=jsonv2'));
    return houseCoordinateFromJson(response.body).first;
  }

  Future<HouseModel> loadHouse() async {
    final response = await loadRawHouse();

    if (response.statusCode == 200) {
      final house = houseModelFromJson(response.body);
      final coord = await loadCoordinates(house);
      return house.copyWithCoord(coord);
    } else {
      throw Exception('${response.statusCode}');
    }
  }
}
