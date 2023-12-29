import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<FlSpot> data =
      List.generate(50, (index) => FlSpot(index.toDouble(), 0.0));
  bool isRunning = false;
  late Timer timer;
  int currentIndex = 49; // Starting index

  double speed = 1.0; // Initial speed value

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Scope'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLineChart(),
          _buildButtons(),
        ],
      ),
    );
  }

  Widget _buildLineChart() {
    return Container(
      height: 300,
      padding: EdgeInsets.all(16),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: SideTitles(showTitles: true),
            rightTitles: SideTitles(showTitles: false),
            bottomTitles: SideTitles(showTitles: true, reservedSize: 30),
            topTitles: SideTitles(showTitles: false),
          ),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: data,
              isCurved: true,
              colors: [Colors.blue],
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtons() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => _startPlotting(),
              child: Text('START'),
            ),
            ElevatedButton(
              onPressed: () => _stopPlotting(),
              child: Text('STOP'),
            ),
            ElevatedButton(
              onPressed: () => _clearData(),
              child: Text('CLEAR'),
            ),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Speed:'),
            SizedBox(width: 10),
            Slider(
              value: speed,
              min: 0.1,
              max: 2.0,
              onChanged: (value) {
                setState(() {
                  speed = value;
                });
              },
            ),
            SizedBox(width: 10),
            Text('${speed.toStringAsFixed(2)}x'),
          ],
        ),
      ],
    );
  }

  void _startPlotting() {
    setState(() {
      isRunning = true;
    });
    timer =
        Timer.periodic(Duration(milliseconds: (1000 / speed).round()), (timer) {
      if (!isRunning) {
        timer.cancel();
      } else {
        _updateData();
      }
    });
  }

  void _stopPlotting() {
    setState(() {
      isRunning = false;
    });
  }

  void _updateData() {
    setState(() {
      // Generate a random value between 20 and 80
      double randomValue = 20 + Random().nextDouble() * 60;

      // Update data for the next point
      data = List.of(data)..add(FlSpot(currentIndex.toDouble(), randomValue));
      currentIndex++;

      // Remove the first point if the data size exceeds 100
      if (data.length > 50) {
        data.removeAt(0);
      }
    });
  }

  void _clearData() {
    setState(() {
      data = List.generate(50, (index) => FlSpot(index.toDouble(), 0.0));
      currentIndex = 49;
    });
  }
}
