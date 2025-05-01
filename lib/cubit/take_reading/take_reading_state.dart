part of 'take_reading_cubit.dart';

@immutable
sealed class TakeReadingState {}

final class TakeReadingInitial extends TakeReadingState {}
final class TakeReadingAfterQrcode extends TakeReadingState {


  final String reslut;

  TakeReadingAfterQrcode({required this.reslut});
}

final class TakeReadingLoadin extends TakeReadingState {}
final class TakeReadingNoDataFound extends TakeReadingState {}
final class TakeReadingNoPermission extends TakeReadingState {}
final class TakeReadingHasBeenRead extends TakeReadingState {}
final class TakeReadingSuccessfully extends TakeReadingState {
  final String customerName;
  final  String currentReading;

  TakeReadingSuccessfully({required this.customerName, required this.currentReading});
}
final class TakeReadingNoInternt extends TakeReadingState {}
final class TakeReadingerror extends TakeReadingState {
  final String erroMessage;

  TakeReadingerror({required this.erroMessage});
  
}
