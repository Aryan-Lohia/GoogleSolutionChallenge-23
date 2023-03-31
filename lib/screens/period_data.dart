import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'peroid.dart';

class PeriodData {
  final List<Period> _periods = [];

  List<Period> get periods => List.unmodifiable(_periods);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList('periods') ?? [];
    _periods.clear();
    for (final jsonString in jsonList) {
      final jsonMap = json.decode(jsonString);
      final period = Period.fromJson(jsonMap);
      _periods.add(period);
    }
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _periods.map((p) => json.encode(p.toJson())).toList();
    prefs.setStringList('periods', jsonList);
  }

  void addPeriod(Period period) {
    _periods.add(period);
    save();
  }

  void removePeriod(Period period) {
    _periods.remove(period);
    save();
  }
}
