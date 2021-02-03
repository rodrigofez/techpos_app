import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences with ChangeNotifier {
  double _totalModifier;

  Future<void> loadBusinessPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.getString('businessPreferences');
    } catch (error) {
      throw error;
    }
  }

  Future<void> setModifier(double modifier) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final modifierData = json.encode({'totalModifier': modifier});
      prefs.setString('businessPreferences', modifierData);

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
