import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const SalahTimesApp());
}

class SalahTimesApp extends StatelessWidget {
  const SalahTimesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Salah Times',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1B5E20),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1B5E20),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const PrayerTimesScreen(),
    );
  }
}

class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  State<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  late Timer _timer;
  DateTime _currentTime = DateTime.now();

  // Prayer times for Astana, Kazakhstan (approximate)
  final Map<String, TimeOfDay> prayerTimes = {
    'Fajr': const TimeOfDay(hour: 5, minute: 30),
    'Sunrise': const TimeOfDay(hour: 7, minute: 15),
    'Dhuhr': const TimeOfDay(hour: 13, minute: 0),
    'Asr': const TimeOfDay(hour: 15, minute: 45),
    'Maghrib': const TimeOfDay(hour: 18, minute: 30),
    'Isha': const TimeOfDay(hour: 20, minute: 0),
  };

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _getNextPrayer() {
    final now = TimeOfDay.fromDateTime(_currentTime);
    final nowMinutes = now.hour * 60 + now.minute;

    for (var entry in prayerTimes.entries) {
      if (entry.key == 'Sunrise') continue; // Skip sunrise
      final prayerMinutes = entry.value.hour * 60 + entry.value.minute;
      if (prayerMinutes > nowMinutes) {
        return entry.key;
      }
    }
    return 'Fajr'; // Next day's Fajr
  }

  String _getTimeUntilNext() {
    final next = _getNextPrayer();
    final nextTime = prayerTimes[next]!;
    var nextDateTime = DateTime(
      _currentTime.year,
      _currentTime.month,
      _currentTime.day,
      nextTime.hour,
      nextTime.minute,
    );

    if (nextDateTime.isBefore(_currentTime)) {
      nextDateTime = nextDateTime.add(const Duration(days: 1));
    }

    final difference = nextDateTime.difference(_currentTime);
    final hours = difference.inHours;
    final minutes = difference.inMinutes.remainder(60);

    return '${hours}h ${minutes}m';
  }

  @override
  Widget build(BuildContext context) {
    final nextPrayer = _getNextPrayer();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.primaryContainer,
              colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  'Astana, Kazakhstan',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  _formatDate(_currentTime),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 32),

                // Current Time
                Center(
                  child: Text(
                    _formatTime(_currentTime),
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                  ),
                ),
                const SizedBox(height: 16),

                // Next Prayer
                Center(
                  child: Card(
                    color: colorScheme.primaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Next Prayer',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  color: colorScheme.onPrimaryContainer,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            nextPrayer,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onPrimaryContainer,
                                ),
                          ),
                          Text(
                            'in ${_getTimeUntilNext()}',
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: colorScheme.onPrimaryContainer,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Prayer Times List
                Expanded(
                  child: ListView(
                    children: prayerTimes.entries.map((entry) {
                      final isNext = entry.key == nextPrayer;
                      final isSunrise = entry.key == 'Sunrise';

                      return Card(
                        color: isNext
                            ? colorScheme.secondaryContainer
                            : colorScheme.surfaceContainerHighest,
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: Icon(
                            _getPrayerIcon(entry.key),
                            color: isNext
                                ? colorScheme.onSecondaryContainer
                                : colorScheme.onSurfaceVariant,
                            size: 28,
                          ),
                          title: Text(
                            entry.key,
                            style: TextStyle(
                              fontWeight:
                                  isNext ? FontWeight.bold : FontWeight.normal,
                              fontSize: isSunrise ? 14 : 18,
                              color: isSunrise
                                  ? colorScheme.onSurfaceVariant
                                  : (isNext
                                      ? colorScheme.onSecondaryContainer
                                      : colorScheme.onSurface),
                            ),
                          ),
                          trailing: Text(
                            entry.value.format(context),
                            style: TextStyle(
                              fontSize: isSunrise ? 14 : 20,
                              fontWeight:
                                  isNext ? FontWeight.bold : FontWeight.normal,
                              color: isSunrise
                                  ? colorScheme.onSurfaceVariant
                                  : (isNext
                                      ? colorScheme.onSecondaryContainer
                                      : colorScheme.onSurface),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getPrayerIcon(String prayer) {
    switch (prayer) {
      case 'Fajr':
        return Icons.wb_twilight;
      case 'Sunrise':
        return Icons.wb_sunny_outlined;
      case 'Dhuhr':
        return Icons.wb_sunny;
      case 'Asr':
        return Icons.wb_cloudy;
      case 'Maghrib':
        return Icons.wb_twilight;
      case 'Isha':
        return Icons.nightlight;
      default:
        return Icons.access_time;
    }
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}';
  }

  String _formatDate(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];

    return '${days[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
