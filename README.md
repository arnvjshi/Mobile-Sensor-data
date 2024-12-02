Sensor Monitoring Dashboard
A Flutter application for real-time visualization of sensor data.

Key Features
Sensor Data Acquisition:
#Accelerometer
#Gyroscope
#Magnetometer
#UserAccelerometer
#LinearAccelerometer
#Gravity
Real-time Visualization:
#fl_chart for interactive charts
Scrollable dashboard with individual sensor charts
Configurable chart data points (currently 50)
Dynamic Updates:
Real-time chart updates
Dependencies
sensors_plus: For accessing device sensors
fl_chart: For creating interactive charts
Implementation Notes
Sensor Data Collection:
Stream listeners for continuous data collection
Rolling buffer for efficient data handling
Visualization:
Dedicated chart for each sensor
X-axis values by default (configurable for Y or Z)
Color-coded charts for clarity
Dynamic updates for real-time visualization
