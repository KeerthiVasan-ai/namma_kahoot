import 'dart:async';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

class CountdownTimer extends StatefulComponent {
  final int seconds;
  final void Function() onFinished;

  const CountdownTimer({
    super.key,
    required this.seconds,
    required this.onFinished,
  });

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late int _currentSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _currentSeconds = component.seconds;
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentSeconds > 0) {
        setState(() {
          _currentSeconds--;
        });
      } else {
        _timer?.cancel();
        component.onFinished();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Component build(BuildContext context) {
    return span([Component.text('$_currentSeconds')]);
  }
}
