import 'package:flutter/material.dart';
import 'package:week_3_blabla_project/model/ride/ride_pref.dart';
import 'package:week_3_blabla_project/data/repository/ride_preferences_repository.dart';
import 'package:week_3_blabla_project/ui/provider/async_value.dart';

class RidesPreferencesProvider extends ChangeNotifier {
  RidePreference? _currentPreference;
  List<RidePreference> _pastPreferences = [];
  late AsyncValue<List<RidePreference>> pastPreferences;

  final RidePreferencesRepository repository;

  RidesPreferencesProvider({required this.repository}){
    pastPreferences = AsyncValue.loading();
    fetchPastPreferences();
  }

  RidePreference? get currentPreference => _currentPreference;
  
  Future<void> fetchPastPreferences() async {
    // 1- Handle loading
    pastPreferences = AsyncValue.loading();
    notifyListeners();

    try {
    // 2 Fetch data
      List<RidePreference> pastPrefs = await repository.getPastPreferences();
      
    // 3 Handle success
      pastPreferences = AsyncValue.success(pastPrefs);
      _pastPreferences = pastPrefs;
    } catch (error) {
      // 4 Handle error
      pastPreferences = AsyncValue.error(error);
    }
  
    notifyListeners();
  }

  Future<void> setCurrentPreferrence(RidePreference pref) async{
    if (_currentPreference != pref) {
      _currentPreference = pref;
      await _addPreference(pref);
      notifyListeners();
    }
  }

  Future<void> _addPreference(RidePreference preference) async{
    try{
      await repository.addPreference(preference);
      _pastPreferences.removeWhere((pref) => pref == preference);
      _pastPreferences.add(preference);
      pastPreferences = AsyncValue.success(_pastPreferences);
      notifyListeners();
    } catch (error) {
      // to Handle error
      pastPreferences = AsyncValue.error(error);
      notifyListeners();
    }
  }

  // History is returned from newest to oldest preference
  List<RidePreference> get preferencesHistory =>
      _pastPreferences.reversed.toList();
}
