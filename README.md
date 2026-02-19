# PLC Relay Controller

A Flutter app to control a 4-channel relay module via a Raspberry Pi using the **Modbus TCP** protocol. Built with Flutter + Rust (via `flutter_rust_bridge`) and MobX for state management.

## Architecture

```
Flutter App (iOS / macOS / Android)
        │
        │  flutter_rust_bridge (FFI)
        ▼
   Rust Library
   (tokio-modbus client)
        │
        │  Modbus TCP (port 502)
        ▼
Raspberry Pi 4
(Python Modbus server + RPi.GPIO)
        │
        │  GPIO
        ▼
4-Channel Relay Module
```

## Tech Stack

| Layer | Technology |
|-------|------------|
| Mobile App | Flutter + MobX |
| FFI Bridge | flutter_rust_bridge 2.11.1 |
| Modbus Client | Rust (tokio-modbus 0.17) |
| Modbus Server | Python (custom socket server) |
| GPIO Control | RPi.GPIO |
| Hardware | 4-Channel Relay Module |
| Protocol | Modbus TCP (Port 502) |

## Features

- Toggle individual relays ON/OFF
- All ON / All OFF controls
- Real-time connection status
- Works on iOS, macOS, and Android

## GPIO Pin Mapping

| Relay | Coil | GPIO (BCM) | Physical Pin |
|-------|------|------------|--------------|
| 1 | 0 | GPIO17 | Pin 11 |
| 2 | 1 | GPIO27 | Pin 13 |
| 3 | 2 | GPIO22 | Pin 15 |
| 4 | 3 | GPIO4 | Pin 7 |

## Setup

### Raspberry Pi
```bash
# Start the Modbus server
sudo systemctl start modbus-relay

# Check status
sudo systemctl status modbus-relay
```

### Flutter App
```bash
flutter pub get
flutter run -d macos        # macOS
flutter run -d <device-id>  # iOS / Android
```

Enter the Pi's IP and port (e.g. `192.168.0.103:502`) in the app to connect.

## Project Structure

```
lib/
├── main.dart
├── screens/       # UI screens
├── services/      # PlcService (Modbus calls)
├── stores/        # MobX state (PlcStore)
├── widgets/       # RelayCard widget
└── src/rust/      # flutter_rust_bridge generated code

rust/
└── src/api/
    └── simple.rs  # set_coil, read_coils (tokio-modbus)
```
