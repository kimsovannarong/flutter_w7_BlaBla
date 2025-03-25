import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week_3_blabla_project/ui/provider/async_value.dart';
import 'package:week_3_blabla_project/ui/provider/rides_preprefs_provider.dart';
import 'package:week_3_blabla_project/ui/screens/ride_pref/bla_error_screen.dart';

import '../../../model/ride/ride_pref.dart';
import '../../theme/theme.dart';

import '../../../utils/animations_util.dart';
import '../rides/rides_screen.dart';
import 'widgets/ride_pref_form.dart';
import 'widgets/ride_pref_history_tile.dart';

const String blablaHomeImagePath = 'assets/images/blabla_home.png';

///
/// This screen allows user to:
/// - Enter his/her ride preference and launch a search on it
/// - Or select a last entered ride preferences and launch a search on it
///
class RidePrefScreen extends StatelessWidget {
  const RidePrefScreen({super.key});

  // function onRidePrefSelected
  void onRidePrefSelected(
      BuildContext context, RidePreference newPreference) async {
    // declare provider variable for reading RidesPreferencesProvider
    var readProvider =
        Provider.of<RidesPreferencesProvider>(context, listen: false);
    readProvider.setCurrentPreferrence(newPreference);
    // Navigate to the rides screen (with a buttom to top animation)
    await Navigator.of(context)
        .push(AnimationUtils.createBottomToTopRoute(RidesScreen()));

    // 3 - After wait  - Update the state   -- TODO MAKE IT WITH STATE MANAGEMENT
  }

  @override
  Widget build(BuildContext context) {
    var rideProvider = Provider.of<RidesPreferencesProvider>(context);
    // get currentRidePreference and pastPreferences from RidesPreferencesProvider
    RidePreference? currentRidePreference = rideProvider.currentPreference;

    // List<RidePreference> pastPreferences = rideProvider.preferencesHistory;

    return Stack(
      children: [
        // 1 - Background  Image
        BlaBackground(),

        // 2 - Foreground content
        Column(
          children: [
            SizedBox(height: BlaSpacings.m),
            Text(
              "Your pick of rides at low price",
              style: BlaTextStyles.heading.copyWith(color: Colors.white),
            ),
            SizedBox(height: 100),
            Container(
              margin: EdgeInsets.symmetric(horizontal: BlaSpacings.xxl),
              decoration: BoxDecoration(
                color: Colors.white, // White background
                borderRadius: BorderRadius.circular(16), // Rounded corners
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 2.1 Display the Form to input the ride preferences
                  RidePrefForm(
                      initialPreference: currentRidePreference,
                      onSubmit: (newPreference) =>
                          onRidePrefSelected(context, newPreference)),
                  SizedBox(height: BlaSpacings.m),

                  // 2.2 Optionally display a list of past preferences
                  _buildPreferencesList(rideProvider, context)
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // function _buildPreferencesList which return list of past preferences
  Widget _buildPreferencesList(
      RidesPreferencesProvider ridesPrefsProvider, BuildContext context) {
    final pastPrefs = ridesPrefsProvider.pastPreferences;
    // get list of past preferences from RidesPreferencesProvider
    List<RidePreference> pastPreferences =ridesPrefsProvider.preferencesHistory;
    // switch case for pastPrefs.state
    switch (pastPrefs.state) {
      case AsyncValueState.loading:
        return const Center(child: CircularProgressIndicator());

      case AsyncValueState.error:
        return const BlaError(message: 'No connection. Try later');

      case AsyncValueState.success:
        if (pastPrefs.data == null) {
          return const Center(
              child: Text('No past preference yet!')); // display an empty state
        }
        return SizedBox(
          height: 95,
          child: ListView.builder(
            shrinkWrap: true, // Fix ListView height issue
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: pastPreferences.length,
            itemBuilder: (context, index) => RidePrefHistoryTile(
              ridePref: pastPreferences[index],
              onPressed: () =>
                  onRidePrefSelected(context, pastPreferences[index]),
            ),
          ),
        );
    }
  }
}

class BlaBackground extends StatelessWidget {
  const BlaBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 340,
      child: Image.asset(
        blablaHomeImagePath,
        fit: BoxFit.cover, // Adjust image fit to cover the container
      ),
    );
  }
}
