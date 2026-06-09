import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../outing/data/outing_service.dart';
import '../../../outing/domain/outing_model.dart';

class OutingTab extends StatefulWidget {
  const OutingTab({super.key});

  @override
  State<OutingTab> createState() => _OutingTabState();
}

class _OutingTabState extends State<OutingTab> {
  final OutingService _outingService = OutingService();
  Timer? _timer;
  Duration _elapsed = Duration.zero;
  Duration? _latestDuration;
  OutingModel? _activeOuting;
  Stream<List<OutingModel>>? _outingsStream;
  String? _cachedUserId;
  StreamSubscription<User?>? _authSubscription;

  bool get _isActive => _timer != null && _timer!.isActive;

  @override
  void initState() {
    super.initState();
    debugPrint(
      'OutingTab.initState: currentUser=${FirebaseAuth.instance.currentUser?.uid}',
    );
    _initializeStream();
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      debugPrint('OutingTab.authStateChanges: user=${user?.uid}');
      _initializeStream();
    });
  }

  void _initializeStream() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    debugPrint(
      'OutingTab._initializeStream: currentUser=$userId cached=$_cachedUserId',
    );
    if (userId != null && userId != _cachedUserId) {
      _cachedUserId = userId;
      if (!mounted) {
        _outingsStream = _outingService.getUserOutings(userId);
        return;
      }
      setState(() {
        _outingsStream = _outingService.getUserOutings(userId);
      });
      return;
    }

    if (userId == null && _cachedUserId != null) {
      // user signed out
      _cachedUserId = null;
      if (!mounted) {
        _outingsStream = null;
        return;
      }
      setState(() {
        _outingsStream = null;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeStream();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _startOuting() async {
    if (_isActive) return;

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw StateError('No signed-in user found.');
      }

      final activeOuting = await _outingService.startOuting(user.uid);
      if (!mounted) return;

      setState(() {
        _activeOuting = activeOuting;
        _elapsed = Duration.zero;
        _timer = Timer.periodic(const Duration(seconds: 1), (_) {
          setState(() {
            _elapsed += const Duration(seconds: 1);
          });
        });
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Outing started successfully.')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to start outing: $error')));
    }
  }

  Future<void> _endOuting() async {
    if (!_isActive || _activeOuting == null) return;

    try {
      final outingId = _activeOuting!.id;
      await _outingService.endOuting(outingId, DateTime.now());
      if (!mounted) return;

      _timer?.cancel();

      setState(() {
        _latestDuration = _elapsed;
        _activeOuting = null;
        _timer = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Outing ended successfully.')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to end outing: $error')));
    }
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  String _formatDate(DateTime date) {
    return '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatTime(DateTime date) {
    final local = date.toLocal();
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _formatStatTime(int totalMinutes) {
    if (totalMinutes < 60) {
      return '$totalMinutes min';
    }

    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    return '$hours h ${minutes.toString().padLeft(2, '0')} min';
  }

  Widget _buildAnalyticsTile(String title, String value, String subtitle) {
    return Expanded(
      child: Card(
        elevation: 0,
        surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 8),
              Text(
                value,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOutingAnalytics(String? userId) {
    if (userId == null) {
      return Card(
        elevation: 0,
        surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            'Sign in to view outing analytics.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
    }

    return Card(
      elevation: 0,
      surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Outing analytics',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            StreamBuilder<List<OutingModel>>(
              stream: _outingsStream,
              builder: (context, snapshot) {
                debugPrint(
                  'OutingTab._buildOutingAnalytics snapshot: state=${snapshot.connectionState} hasData=${snapshot.hasData} hasError=${snapshot.hasError}',
                );
                if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'ERROR: ${snapshot.error}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  );
                }

                if (!snapshot.hasData) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: SizedBox(
                      height: 40,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  );
                }

                final outings = snapshot.data!;
                debugPrint(
                  'OutingTab._buildOutingAnalytics: outings.length=${outings.length} for user=$userId',
                );
                if (outings.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'No outings yet',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  );
                }

                final endedOutings = outings
                    .where(
                      (outing) =>
                          outing.endTime != null && outing.durationMinutes > 0,
                    )
                    .toList();
                final totalOutings = outings.length;
                final totalMinutes = endedOutings.fold<int>(
                  0,
                  (sum, outing) => sum + outing.durationMinutes,
                );
                final longestMinutes = endedOutings.fold<int>(
                  0,
                  (previousValue, outing) =>
                      outing.durationMinutes > previousValue
                      ? outing.durationMinutes
                      : previousValue,
                );
                final averageMinutes = endedOutings.isEmpty
                    ? 0
                    : (totalMinutes / endedOutings.length).round();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        _buildAnalyticsTile(
                          'Total outings',
                          '$totalOutings',
                          'Recorded sessions',
                        ),
                        const SizedBox(width: 12),
                        _buildAnalyticsTile(
                          'Time outside',
                          _formatStatTime(totalMinutes),
                          'Total duration',
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildAnalyticsTile(
                          'Longest outing',
                          longestMinutes > 0
                              ? _formatStatTime(longestMinutes)
                              : '0 min',
                          'Best run',
                        ),
                        const SizedBox(width: 12),
                        _buildAnalyticsTile(
                          'Average outing',
                          averageMinutes > 0
                              ? _formatStatTime(averageMinutes)
                              : '0 min',
                          'Per session',
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOutingHistory(String? userId) {
    if (userId == null) {
      return Card(
        elevation: 0,
        surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            'Sign in to view outing history.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
    }

    return Card(
      elevation: 0,
      surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Outing history',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            StreamBuilder<List<OutingModel>>(
              stream: _outingsStream,
              builder: (context, snapshot) {
                debugPrint(
                  'OutingTab._buildOutingHistory snapshot: state=${snapshot.connectionState} hasData=${snapshot.hasData} hasError=${snapshot.hasError}',
                );
                if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'ERROR: ${snapshot.error}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  );
                }

                if (!snapshot.hasData) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: SizedBox(
                      height: 40,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  );
                }

                final outings = snapshot.data!;
                debugPrint(
                  'OutingTab._buildOutingHistory: outings.length=${outings.length} for user=$userId',
                );
                if (outings.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'No outings yet',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: outings.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final outing = outings[index];
                    final endTime = outing.endTime;
                    final durationText = outing.durationMinutes > 0
                        ? '${outing.durationMinutes} min'
                        : endTime == null
                        ? 'In progress'
                        : _formatDuration(endTime.difference(outing.startTime));

                    return Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              _formatDate(outing.startTime),
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Start',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _formatTime(outing.startTime),
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'End',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      endTime == null
                                          ? '-'
                                          : _formatTime(endTime),
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Duration',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      durationText,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isActive = _isActive;
    final statusLabel = isActive ? 'Outing Active' : 'Ready to Start';
    final statusColor = isActive
        ? colorScheme.primary
        : colorScheme.onSurfaceVariant;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.directions_walk,
                    size: 28,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Outing Tracker', style: theme.textTheme.titleLarge),
                      const SizedBox(height: 6),
                      Text(
                        'Track your campus outing time with a clean timer and quick controls.',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 0,
              surfaceTintColor: colorScheme.surfaceTint,
              shadowColor: Colors.black12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Text(
                          statusLabel,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: statusColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isActive
                                ? colorScheme.primary.withAlpha(31)
                                : colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isActive
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_off,
                                size: 16,
                                color: isActive
                                    ? colorScheme.primary
                                    : colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                isActive ? 'Active' : 'Idle',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: isActive
                                      ? colorScheme.primary
                                      : colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text(
                      _formatDuration(_elapsed),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Current outing duration',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 28),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton(
                            onPressed: isActive ? null : _startOuting,
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text('Start Outing'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: isActive ? _endOuting : null,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text('End Outing'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 0,
              surfaceTintColor: colorScheme.surfaceTint,
              shadowColor: Colors.black12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Latest outing', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 12),
                    if (_latestDuration != null) ...[
                      Text(
                        _formatDuration(_latestDuration!),
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Final duration stored locally. Start again to log a new outing.',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ] else ...[
                      Text(
                        'No completed outing yet. Tap Start Outing to begin tracking your next campus walk.',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildOutingAnalytics(FirebaseAuth.instance.currentUser?.uid),
            const SizedBox(height: 24),
            _buildOutingHistory(FirebaseAuth.instance.currentUser?.uid),
            const SizedBox(height: 16),
            Text(
              'Your outings are synced with Firestore and accessible across devices.',
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
