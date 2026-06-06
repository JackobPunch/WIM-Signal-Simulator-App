# WIM Signal Simulator — Desktop Control Panel

A Windows desktop application built with Flutter for controlling the WIM signal simulator hardware described in the engineering thesis:

> **"Signal simulator from the dynamic vehicle weighing system"**
> Jakub Cios, AGH University of Science and Technology, Faculty of Electrical Engineering, Automatics, Computer Science and Biomedical Engineering, 2025
> Supervisor: dr hab. inż. Ryszard Sroka, prof. AGH

The simulator hardware and firmware are in the companion repo: [WIM-Signal-Simulator](https://github.com/jackobpunch/WIM-Signal-Simulator).

---

## What this is

WIM (Weigh-in-Motion) systems measure vehicle weight while the vehicle is moving. They use two types of sensors embedded in the road:

- **Pressure sensors** (strain gauge) — measure axle loads
- **Inductive loop sensors** — detect vehicle presence, speed, and class

The simulator reproduces the electrical signals both sensor types send to the weighing computer (CAT Traffic CLW21), so the computer can be tested in a lab without real vehicles.

This app is the user interface for the simulator. It lets the operator select a vehicle type and speed, then uploads the corresponding firmware to the Arduino microcontroller that drives the simulator hardware.

---

## How the full system works

### Step 1 — Real vehicle data collection (already done)

Real vehicles were driven over the WIM test installation at the AGH research site. For each pass:
- The WIM system's camera captured a photo of the vehicle (see `images/`)
- The weighing computer recorded the raw sensor signals, saved as CSV files

The `images/` folder contains the camera captures from those real measurements. Each image corresponds to one of the vehicle types the simulator can reproduce.

| Image | Vehicle |
|-------|---------|
| image1.png | Articulated truck (semi-trailer) |
| image2.png | Tipper truck |
| image3.png | SUV |
| image4.png | Van with trailer |
| image5.png | Refrigerated truck |
| image6.png | Van |
| image7.png | Flatbed truck |
| image8.png | Car |

### Step 2 — Signal preprocessing (already done)

The raw CSV waveforms were analysed in MATLAB (FFT showed relevant harmonics up to ~80 Hz). The key sample values for each vehicle were extracted and hardcoded as arrays into the Arduino firmware (`semi_trailer_generator.ino` in the SignalTransmitter repo). Every 6th sample was taken, giving a generation rate of ~833 Hz — well above the 240 Hz minimum derived from the sampling theorem.

### Step 3 — Simulation (this app)

The app:
1. Detects the connected Arduino board using `arduino-cli board list`
2. The operator selects speed (50 / 60 / 70 km/h) — this controls signal timing parameters in the firmware
3. On "Send", the app compiles and uploads `semi_trailer_generator.ino` to the Arduino via `arduino-cli`
4. The Arduino generates the sensor signals on its DAC outputs, which are fed into the weighing computer

---

## Hardware required

- Arduino Uno R4 Renesas WiFi
- MCP4728 — 4-channel 12-bit DAC (pressure sensor simulation)
- Relay Shield v3.0 — controls inductive loop coils
- Custom wound inductors (72 µH, to match real inductive loop sensors)
- RC low-pass filters (150 Ω, 10 µF, fc = 106 Hz) on DAC outputs
- Voltage dividers (100 kΩ / 100 Ω) — scales DAC output down to the 0–5 mV range expected by the weighing computer

Full hardware description and build photos: [WIM-Signal-Simulator](https://github.com/jackobpunch/WIM-Signal-Simulator)

---

## Prerequisites

- Windows (the app uses `serial_port_win32`)
- [Flutter SDK](https://docs.flutter.dev/get-started/install/windows/desktop)
- [arduino-cli](https://arduino.github.io/arduino-cli/latest/installation/) — must be on your `PATH`
- [WIM-Signal-Simulator](https://github.com/jackobpunch/WIM-Signal-Simulator) repo cloned locally

---

## Setup

### 1. Configure the path

Open `lib/MainScreen/main_screen_view_model.dart` and update the constant at the top:

```dart
const String kSignalTransmitterRoot =
    r'C:\Users\rolni\kody\Dziekan\SignalTransmitter';
```

Set it to wherever you cloned the SignalTransmitter repo on your machine.

### 2. Install Arduino core

```
arduino-cli core install arduino:renesas_uno
```

### 3. Install required libraries

```
arduino-cli lib install "Adafruit MCP4728"
arduino-cli lib install "Wire"
```

### 4. Run the app

```
flutter run -d windows
```

---

## Current state

This is a prototype built as part of the engineering thesis. The vehicle type selector (`VehicleOption` enum) exists in the code but is not yet wired up in the UI — currently only speed selection is functional, and all three speeds upload the same `semi_trailer_generator.ino`. The intended next step is per-vehicle-type firmware files and full UI integration.

See the thesis for test results and recommendations for future development.

---

## Related

- [WIM-Signal-Simulator](https://github.com/jackobpunch/WIM-Signal-Simulator) — Arduino firmware and real sensor CSV data
- [WIM-Signal-Simulator-Thesis](https://github.com/jackobpunch/WIM-Signal-Simulator-Thesis) — Full thesis (LaTeX source + compiled PDF)
