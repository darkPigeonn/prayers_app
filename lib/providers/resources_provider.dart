import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayers_app/model/resource_model.dart';
import 'package:prayers_app/services/resources_services.dart';

final prayersProvider = FutureProvider<List<ResourceModel>>((ref) async {
  return ref.read(resourceProvider).getPrayers();
});

final todayPrayerProvider = FutureProvider<ResourceModel>((ref) async {
  return ref.watch(resourceProvider).getPrayersToday();
});

final eventsTodaysProvider = FutureProvider<dynamic>((ref) async {
  return ref.watch(resourceProvider).getEventsToday();
});
