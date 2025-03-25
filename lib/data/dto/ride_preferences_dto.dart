import 'package:week_3_blabla_project/data/dto/location_dto.dart';
import 'package:week_3_blabla_project/model/ride/ride_pref.dart';

class RidePreferenceDto {
  // convert model to json
  static Map<String, dynamic> toJson(RidePreference ridePreference) {
    return {
      'departure': {
        'name': ridePreference.departure.name,
        'country': ridePreference.departure.country.name,
      },
      'departureDate': ridePreference.departureDate.toIso8601String(),
      'arrival': {
        'name': ridePreference.arrival.name,
        'country': ridePreference.arrival.country.name,
      },
      'requestedSeats': ridePreference.requestedSeats,
    };
  }

  // convert json to model
  static RidePreference fromJson(Map<String, dynamic> json) {
    return RidePreference(
      departure: LocationDto.fromJson(json['departure']),
      departureDate: DateTime.parse(json['departureDate']),
      arrival: LocationDto.fromJson(json['arrival']),
      requestedSeats: json['requestedSeats'],
    );
  }
}