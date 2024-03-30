import 'package:flutter/material.dart';
import 'package:serial_port_win32/serial_port_win32.dart';
import 'dart:io';

enum Option {
  speed50(description: '50 km/h'),
  speed60(description: '60 km/h'),
  speed70(description: '70 km/h');

  const Option({required this.description});

  final String description;
}

class MainScreenViewModel extends ChangeNotifier {
  MainScreenViewModel() {
    // Initialize serial communication when the MainScreenViewModel is created
    initializeSerialCommunication();
  }
  String ARDUINO_DEVICE_VID = "VID_2341";
  String ARDUINO_DEVICE_PID = "PID_1002";

  Option? _selectedOption;
  bool _isSendButtonEnabled = false;

  var ports = <String>[];

  late SerialPort serialPort;

  Option? get selectedOption => _selectedOption;
  bool get isSendButtonEnabled => _isSendButtonEnabled;

  void onButtonPressed() {
    print('Button pressed');
    String inoFilePath;
    switch (selectedOption) {
      case Option.speed50:
        inoFilePath =
            'C:\\Users\\rolni\\kody\\Dziekan\\SignalTransmitter\\codes\\ArduinUno\\firstBoss\\firstBoss.ino';
        break;
      case Option.speed60:
        inoFilePath =
            'C:\\Users\\rolni\\kody\\Dziekan\\SignalTransmitter\\codes\\ArduinUno\\firstBoss\\firstBoss.ino';
        break;
      case Option.speed70:
        inoFilePath =
            'C:\\Users\\rolni\\kody\\Dziekan\\SignalTransmitter\\codes\\ArduinUno\\firstBoss\\firstBoss.ino';
        break;
      default:
        inoFilePath =
            'C:\\Users\\rolni\\kody\\Dziekan\\SignalTransmitter\\codes\\ArduinUno\\firstBoss\\firstBoss.ino';
    }
    uploadInoFile(inoFilePath);
  }

  void uploadInoFile(String filePath) {
    Process.run('arduino-cli', [
      'upload',
      '-p',
      'COM16',
      '-b',
      'arduino:renesas_uno:unor4wifi',
      filePath
    ]).then((ProcessResult results) {
      print('Upload completed with results: ${results.stdout}');
    });
  }

  void updateSelectedOption(Option? newOption) {
    _selectedOption = newOption;
    _isSendButtonEnabled = true;
    notifyListeners();
  }

  void initializeSerialCommunication() {
    /*final List<PortInfo> portList = SerialPort.getPortsWithFullMessages();
    ports = SerialPort.getAvailablePorts();
    PortInfo? arduinoPort;
    arduinoPort = portList.firstWhereOrNull((port) =>
        port.hardwareID.contains(ARDUINO_DEVICE_VID) &&
        port.hardwareID.contains(ARDUINO_DEVICE_PID));

    if (ports.isNotEmpty && arduinoPort != null) {
      serialPort = SerialPort(arduinoPort.portName,
          openNow: false, ReadIntervalTimeout: 1, ReadTotalTimeoutConstant: 2);
      serialPort.openWithSettings(BaudRate: CBR_115200);
      print('Module found');
    } else {
      print('No module');
    }
    print(portList);
    print(arduinoPort);
    print(ports);*/
  }
}
