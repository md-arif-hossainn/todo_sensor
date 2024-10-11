import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';

class SensorTrackingScreen extends StatefulWidget {
  const SensorTrackingScreen({super.key});

  @override
  SensorTrackingScreenState createState() => SensorTrackingScreenState();
}

class SensorTrackingScreenState extends State<SensorTrackingScreen> {
  List<_SensorData> _gyroData = [];
  List<_SensorData> _accelData = [];
  final double _gyroThreshold = 2.0;
  final double _accelThreshold = 10.0;
  String _alertMessage = '';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startSensorTracking();
  }

  void _startSensorTracking() {
    gyroscopeEventStream().listen((GyroscopeEvent event) {
      // Collect the data
      _gyroData.add(_SensorData(
        time: DateTime.now(),
        x: event.x,
        y: event.y,
        z: event.z,
      ));
      if (_gyroData.length > 100) {
        _gyroData.removeAt(0);
      }


      _checkForAlert(event.x, event.y, event.z, _gyroThreshold, 'Gyroscope');
    });

    accelerometerEventStream().listen((AccelerometerEvent event) {
      // Collect the data
      _accelData.add(_SensorData(
        time: DateTime.now(),
        x: event.x,
        y: event.y,
        z: event.z,
      ));
      if (_accelData.length > 100) {
        _accelData.removeAt(0); // Limit the data points in the list
      }

      // Check for alerts with accelerometer data
      _checkForAlert(event.x, event.y, event.z, _accelThreshold, 'Accelerometer');
    });

    // Timer to update the graph every second
    _timer = Timer.periodic(const Duration(seconds: 0), (Timer timer) {
      setState(() {
        // Force the chart to rebuild and display the most recent data
        _gyroData = _gyroData.toList();
        _accelData = _accelData.toList();
      });
    });
  }

  void _checkForAlert(double x, double y, double z, double threshold, String sensorType) {
    // Check for simultaneous movement on any two axes
    bool isXHigh = x.abs() > threshold;
    bool isYHigh = y.abs() > threshold;
    bool isZHigh = z.abs() > threshold;

    if ((isXHigh && isYHigh) || (isXHigh && isZHigh) || (isYHigh && isZHigh)) {
      setState(() {
        _alertMessage = 'ALERT: Significant movement detected on multiple axes!';
      });
    } else {
      setState(() {
        _alertMessage = ''; // Clear the alert if conditions are not met
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sensor Tracking')),
      body: Column(
        children: [
          if (_alertMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _alertMessage,
                style: const TextStyle(color: Colors.red, fontSize: 20),
              ),
            ),
          Expanded(
            child: _buildGyroChart(),
          ),
          Expanded(
            child: _buildAccelChart(),
          ),
        ],
      ),
    );
  }

  Widget _buildGyroChart() {
    return SfCartesianChart(
      title: const ChartTitle(text: 'Gyroscope Data'),
      legend: const Legend(isVisible: true),
      primaryXAxis: const DateTimeAxis(),
      series: <LineSeries<_SensorData, DateTime>>[
        LineSeries<_SensorData, DateTime>(
          name: 'X',
          dataSource: _gyroData,
          color: Colors.blue,
          xValueMapper: (_SensorData data, _) => data.time,
          yValueMapper: (_SensorData data, _) => data.x,
        ),
        LineSeries<_SensorData, DateTime>(
          name: 'Y',
          dataSource: _gyroData,
          color: Colors.green,
          xValueMapper: (_SensorData data, _) => data.time,
          yValueMapper: (_SensorData data, _) => data.y,
        ),
        LineSeries<_SensorData, DateTime>(
          name: 'Z',
          dataSource: _gyroData,
          color: Colors.red,
          xValueMapper: (_SensorData data, _) => data.time,
          yValueMapper: (_SensorData data, _) => data.z,
        ),
      ],
    );
  }

  Widget _buildAccelChart() {
    return SfCartesianChart(
      title: const ChartTitle(text: 'Accelerometer Data'),
      legend: const Legend(isVisible: true),
      primaryXAxis: const DateTimeAxis(),
      series: <LineSeries<_SensorData, DateTime>>[
        LineSeries<_SensorData, DateTime>(
          name: 'X',
          dataSource: _accelData,
          xValueMapper: (_SensorData data, _) => data.time,
          yValueMapper: (_SensorData data, _) => data.x,
        ),
        LineSeries<_SensorData, DateTime>(
          name: 'Y',
          dataSource: _accelData,
          xValueMapper: (_SensorData data, _) => data.time,
          yValueMapper: (_SensorData data, _) => data.y,
        ),
        LineSeries<_SensorData, DateTime>(
          name: 'Z',
          dataSource: _accelData,
          xValueMapper: (_SensorData data, _) => data.time,
          yValueMapper: (_SensorData data, _) => data.z,
        ),
      ],
    );
  }
}

class _SensorData {
  final DateTime time;
  final double x;
  final double y;
  final double z;

  _SensorData({
    required this.time,
    required this.x,
    required this.y,
    required this.z,
  });
}