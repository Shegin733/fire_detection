# Forest Fire Detection System

[![License: CC0 1.0](https://img.shields.io/badge/License-CC0%201.0-lightgrey)](LICENSE.md)
[![Dart](https://img.shields.io/badge/Dart-00B4AB?logo=dart&logoColor=white)](https://dart.dev)
[![Python](https://img.shields.io/badge/Python-3.10%2B-3776AB?logo=python&logoColor=white)](https://www.python.org)

## About

This project is an end-to-end forest fire monitoring and alert system designed to detect fire conditions early using a combination of camera-based computer vision, environmental sensors, and a user-friendly monitoring dashboard.



https://github.com/user-attachments/assets/025c98ab-a28c-46e0-88b0-54e0981d429d



The system integrates:

- a Python backend that processes live video and runs fire detection logic,
- an ESP8266-based IoT module that reads temperature and smoke data,
- a Flutter application used by forest officers to monitor live detections, sensor values, and alerts.

The goal is to provide a practical early-warning solution for field teams who need fast, nearby awareness of fire risk in forests and remote areas.

## Features

- Real-time fire detection from a live camera stream using OpenCV and a Haar cascade model
- Automatic alerting when smoke or fire conditions are detected
- Temperature and smoke monitoring from an IoT sensor node
- Cloud sensor publishing to ThingSpeak for remote observation
- Flutter dashboard for operator login, statistics, location info, and system status
- Live video streaming and event status updates over WebSocket communication
- Audio alert support for fire warnings

## Architecture overview

The repository is organized into three main parts:

- `fire_detection_python_backend/` - Python + FastAPI service that performs detection and exposes HTTP/WebSocket endpoints
- `fire_detection_app/` - Flutter app for the forest monitoring dashboard
- `firedetect_iot/firedetect/` - ESP8266 firmware for reading sensor data and sending it to ThingSpeak

### Data flow

1. The IoT node reads smoke and temperature values from sensors and uploads them to ThingSpeak.
2. The Python backend reads an IP camera stream and runs fire detection logic.
3. When fire is detected, the backend publishes a detection result through a WebSocket connection.
4. The Flutter dashboard receives these updates and displays the detection status and live frames.
5. Alerts may trigger audio warnings and operator notifications.

## Project structure

```text
fire_detection/
├── LICENSE.md
├── README.md
├── fire_detection_app/
│   ├── lib/
│   ├── assets/
│   ├── pubspec.yaml
│   └── README.md
├── fire_detection_python_backend/
│   ├── main.py
│   ├── detection_utils.py
│   ├── requirements.txt
│   ├── fire_detection_cascade_model.xml
│   └── README.md
├── firedetect_iot/
│   └── firedetect/
│       └── firedetect.ino
└── .idea/
```

## Setup and usage

### 1) Python backend

Navigate to the backend folder:

```bash
cd fire_detection_python_backend
```

Create and activate a virtual environment:

```bash
python3 -m venv .venv
source .venv/bin/activate
```

Install dependencies:

```bash
pip install -r requirements.txt
```

Start the detection service:

```bash
python main.py
```

The backend exposes the following endpoints:

- `POST /start_detection`
- `POST /stop_detection`
- WebSocket connection at `/`

Example:

```bash
curl -X POST http://localhost:8000/start_detection
```

Notes:

- The service expects a live video source via `cap_url` in `main.py`.
- The current configuration uses an IP camera URL and may need to be updated for your environment.
- Ensure the OpenCV cascade file `fire_detection_cascade_model.xml` remains in the same folder as the backend code.

### 2) Flutter application

Open the app directory:

```bash
cd fire_detection_app
```

Install Flutter dependencies:

```bash
flutter pub get
```

Run the app:

```bash
flutter run
```

For web:

```bash
flutter run -d chrome
```

The app includes:

- login flow,
- device and sensor status,
- statistics dashboard,
- location view,
- live detection display.

### 3) IoT sensor node

Open the Arduino sketch:

```text
firedetect_iot/firedetect/firedetect.ino
```

Before flashing the firmware, update the following values:

- Wi-Fi SSID and password
- ThingSpeak API key
- sensor configuration if required

Example values located in the sketch:

```cpp
const char *ssid = "wifi-username";
const char *pass = "wifi-password";
String apiKey = "Thingspeak-api-key";
```

Upload the sketch to the ESP8266 or compatible device, then power it on and verify it connects to the configured Wi-Fi network.

## Usage workflow

A typical end-to-end workflow is:

1. Power on the sensor node.
2. Start the Python backend service.
3. Start the Flutter app.
4. Log in to the dashboard.
5. Ask the backend to begin detection.
6. Monitor the live feed and sensor readings for fire events.

## Support and documentation

For help with the project, use the following resources:

- Repository issues: [GitHub Issues](https://github.com/Shegin733/fire_detection/issues)
- Backend guide: [fire_detection_python_backend/README.md](fire_detection_python_backend/README.md)
- App guide: [fire_detection_app/README.md](fire_detection_app/README.md)
- License: [LICENSE.md](LICENSE.md)

## Maintainers and contribution

This project is maintained by the repository owner, [Shegin733](https://github.com/Shegin733).

Contributions are welcome. If you would like to improve the project:

1. Fork the repository.
2. Create a feature branch.
3. Make your changes and test them.
4. Open a pull request with a clear explanation of the update.

Please keep changes focused and document any new configuration requirements in your PR.

## License

This project uses the [Creative Commons Zero v1.0 Universal](LICENSE.md) license.

