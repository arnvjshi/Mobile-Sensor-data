import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(SensorApp());
}

class SensorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sensor Visualization',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SensorDashboard(),
    );
  }
}

class SensorDashboard extends StatefulWidget {
  @override
  _SensorDashboardState createState() => _SensorDashboardState();
}

class _SensorDashboardState extends State<SensorDashboard> {
  // Sensor data streams
  final List<StreamSubscription> _sensorSubscriptions = [];

  // Sensor data storage
  final _sensorData = {
    'Accelerometer': <AccelerometerEvent>[],
    'Gyroscope': <GyroscopeEvent>[],
    'Magnetometer': <MagnetometerEvent>[],
    'UserAccelerometer': <UserAccelerometerEvent>[],
  };

  // Chart configuration
  static const int _maxDataPoints = 50;
  bool _isSensorActive = false;

  @override
  void initState() {
    super.initState();
    _startSensorMonitoring();
  }

  void _startSensorMonitoring() {
    setState(() {
      _isSensorActive = true;
    });

    // Accelerometer
    _sensorSubscriptions.add(
        accelerometerEvents.listen((AccelerometerEvent event) {
          _updateSensorData('Accelerometer', event);
        }, onError: _handleSensorError)
    );

    // Gyroscope
    _sensorSubscriptions.add(
        gyroscopeEvents.listen((GyroscopeEvent event) {
          _updateSensorData('Gyroscope', event);
        }, onError: _handleSensorError)
    );

    // Magnetometer
    _sensorSubscriptions.add(
        magnetometerEvents.listen((MagnetometerEvent event) {
          _updateSensorData('Magnetometer', event);
        }, onError: _handleSensorError)
    );

    // User Accelerometer
    _sensorSubscriptions.add(
        userAccelerometerEvents.listen((UserAccelerometerEvent event) {
          _updateSensorData('UserAccelerometer', event);
        }, onError: _handleSensorError)
    );
  }

  void _updateSensorData(String sensorName, dynamic event) {
    setState(() {
      _sensorData[sensorName]?.add(event);

      // Maintain max data points
      if (_sensorData[sensorName]!.length > _maxDataPoints) {
        _sensorData[sensorName]?.removeAt(0);
      }
    });
  }

  void _handleSensorError(error) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sensor Error: $error'),
          backgroundColor: Colors.red,
        )
    );
    setState(() {
      _isSensorActive = false;
    });
  }

  @override
  void dispose() {
    // Cancel all sensor subscriptions
    for (var subscription in _sensorSubscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }

  // Create chart for a specific sensor
  Widget _buildSensorChart(
      String sensorName,
      Color chartColor,
      double Function(dynamic) getValue
      ) {
    final sensorEvents = _sensorData[sensorName] ?? [];

    return Card(
      elevation: 4,
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
                sensorName,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                )
            ),
            SizedBox(height: 10),
            sensorEvents.isNotEmpty
                ? _renderLineChart(sensorEvents, chartColor, getValue)
                : _buildNoDataWidget(),
          ],
        ),
      ),
    );
  }

  // Render line chart for sensor data
  Widget _renderLineChart(
      List<dynamic> events,
      Color chartColor,
      double Function(dynamic) getValue
      ) {
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: events.asMap().entries.map((entry) {
                return FlSpot(
                    entry.key.toDouble(),
                    getValue(entry.value)
                );
              }).toList(),
              isCurved: true,
              color: chartColor,
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
            )
          ],
        ),
      ),
    );
  }

  // Widget to show when no sensor data is available
  Widget _buildNoDataWidget() {
    return Container(
      height: 200,
      child: Center(
        child: Text(
          'No sensor data available',
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sensor Dashboard'),
        actions: [
          IconButton(
            icon: Icon(_isSensorActive ? Icons.pause : Icons.play_arrow),
            onPressed: () {
              if (_isSensorActive) {
                // Pause sensors
                for (var subscription in _sensorSubscriptions) {
                  subscription.cancel();
                }
                setState(() {
                  _isSensorActive = false;
                });
              } else {
                // Resume sensors
                _startSensorMonitoring();
              }
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Reset and restart sensor monitoring
          for (var subscription in _sensorSubscriptions) {
            subscription.cancel();
          }
          _sensorData.forEach((key, value) => value.clear());
          _startSensorMonitoring();
        },
        child: ListView(
          children: [
            _buildSensorChart('Accelerometer', Colors.blue, (e) => e.x),
            _buildSensorChart('Gyroscope', Colors.green, (e) => e.x),
            _buildSensorChart('Magnetometer', Colors.red, (e) => e.x),
            _buildSensorChart('UserAccelerometer', Colors.purple, (e) => e.x),
          ],
        ),
      ),
    );
  }
}