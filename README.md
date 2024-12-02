# Sensor Data Dashboard

A Flutter application for fetching, displaying, and visualizing data from multiple device sensors in real-time.

## Key Features

- **Fetches data from multiple sensors:**
  - Accelerometer
  - Gyroscope
  - Magnetometer
  - User Accelerometer
  - Linear Accelerometer
  - Gravity
- **Real-time graphing** using the `fl_chart` package.
- **Scrollable dashboard** with individual sensor charts.
- **Configurable chart data points** (currently set to 50 most recent readings).

## Dependencies

This app uses the following key packages:
- [`sensors_plus`](https://pub.dev/packages/sensors_plus): For accessing device sensors.
- [`fl_chart`](https://pub.dev/packages/fl_chart): For creating interactive charts.

## Implementation Notes

### Sensor Data Collection
- Uses stream listeners to continuously collect sensor data.
- Maintains a rolling buffer of sensor events (`MAX_CHART_POINTS`).
- Automatically removes the oldest data points to prevent memory overflow.

### Visualization
- Each sensor has a dedicated chart.
- Charts display X-axis values by default (can be modified to show Y or Z-axis values).
- Color-coded for easy differentiation.
- Supports dynamic updates for real-time data representation.

## How to Run
1. Ensure you have Flutter installed on your system.
2. Add the dependencies listed above in your `pubspec.yaml` file.
3. Run the application on a device with the required sensors.
4. Interact with the dashboard to view real-time sensor data.

Enjoy visualizing sensor data effortlessly!
