import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:week_3_blabla_project/data/dto/ride_preferences_dto.dart';
import 'package:week_3_blabla_project/data/repository/ride_preferences_repository.dart';
import 'package:week_3_blabla_project/model/ride/ride_pref.dart';

class LocalRidesPreferencesRepository extends RidePreferencesRepository {
  static const String _preferencesKey = "ride_preferences";
  @override
  Future<void> addPreference(RidePreference preference) async {
    // call getPastPreferece
    final List<RidePreference> preferences = await getPastPreferences();
    // add new preference
    preferences.add(preference);
    // Save the new list as string list
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _preferencesKey,
      preferences
          .map((pref) => jsonEncode(RidePreferenceDto.toJson(pref)))
          .toList(),
    );
  }

  @override
  Future<List<RidePreference>> getPastPreferences() async {
    // Get SharedPreferences instance
    final prefs = await SharedPreferences.getInstance();
    // Get the string list form the key
    final prefsList = prefs.getStringList(_preferencesKey) ?? [];
    // Convert the string list to a list of RidePreferences – Using map()
    return prefsList
        .map((json) => RidePreferenceDto.fromJson(jsonDecode(json)))
        .toList();
  }
}
