part of 'data_cubit.dart';

@immutable
abstract class DataState {
  const DataState();
}

class DataInitial extends DataState {}

class Loading extends DataState {}

class DataLoaded extends DataState {
  final HouseModel house;
  const DataLoaded(this.house);
}