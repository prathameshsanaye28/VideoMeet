import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StylishTimeDisplay extends StatefulWidget {
  const StylishTimeDisplay({Key? key}) : super(key: key);

  @override
  _StylishTimeDisplayState createState() => _StylishTimeDisplayState();
}

class _StylishTimeDisplayState extends State<StylishTimeDisplay> {
  late Timer _timer;
  late List<String> _timeUnits;
  late String _currentDate;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => _updateTime());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTime() {
    final DateTime now = DateTime.now();
    final List<String> formattedTime = [
      DateFormat('HH').format(now),
      DateFormat('mm').format(now),
      DateFormat('ss').format(now)
    ];
    setState(() {
      _timeUnits = formattedTime;
      _currentDate = DateFormat('EEEE, MMMM d').format(now);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 250,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.grey[300]!,
            Colors.amber[100]!,
            Colors.yellow[200]!,
            Colors.orange[200]!,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (int i = 0; i < _timeUnits.length; i++)
                _buildTimeUnit(_timeUnits[i], i == _timeUnits.length - 1)
            ],
          ),
          Text(
            _currentDate,
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeUnit(String unit, bool isLast) {
    return Container(
      width: 80,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          isLast ? unit : "$unit:",
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: 47,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}