import 'package:flutter_driver/flutter_driver.dart';

import 'package:trufi_core/keys.dart' as keys;

import 'robot.dart';
import 'search_robot.dart';

class HomeRobot extends Robot {
  HomeRobot(FlutterDriver driver, Future<void> work) : super(driver, work);

  HomeRobot seesFromPlacesField() {
    work = work.then((_) async => seesKey(keys.homePageFromPlaceField));
    return this;
  }

  HomeRobot seesToPlacesField() {
    work = work.then((_) async => seesKey(keys.homePageToPlaceField));
    return this;
  }

  HomeRobot seesSwapButton() {
    work = work.then((_) async => seesKey(keys.homePageSwapButton));
    return this;
  }

  HomeRobot seesNotSwapButton() {
    work = work.then((_) async => seesNotKey(keys.homePageSwapButton));
    return this;
  }

  SearchRobot tapsOnFromPlacesField() {
    work = work.then((_) async => tapsOnKey(keys.homePageFromPlaceField));
    return SearchRobot(driver, work);
  }
}
