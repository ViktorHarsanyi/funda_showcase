
import 'package:flutter_test/flutter_test.dart';
import 'package:funda_assignment/service/funda_service.dart';

void main() {

  group('call endpoint', () {

    test('load house', () async {
     final response = await FundaService().loadRawHouse();
     expect(response.statusCode, 200);

    });

  test('load house', () async {
    final house = await FundaService().loadHouse();
    expect(house.adres, 'Schepenlaan 49');

    expect(house.hoofdFoto, 'http://cloud.funda.nl/valentina_media/169/035/165_groot.jpg');
  });
});
}
