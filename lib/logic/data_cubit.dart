import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:funda_assignment/data/house_model.dart';
import 'package:funda_assignment/service/funda_service.dart';


part 'data_state.dart';

class DataCubit extends Cubit<DataState> {

  final FundaService service;
  DataCubit(this.service,) : super(DataInitial()){
    loadHouse();
  }

  void loadHouse() async{
    emit(Loading());
    final house = await service.loadHouse();
    emit(DataLoaded(house));
  }

}
