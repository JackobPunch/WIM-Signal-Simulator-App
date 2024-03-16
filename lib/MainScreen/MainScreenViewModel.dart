import 'package:flutter/material.dart';
import 'package:serial_port_win32/serial_port_win32.dart';
import 'package:collection/collection.dart';
import 'package:win32/win32.dart';

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
    String message;
    switch (selectedOption) {
      case Option.speed50:
        message = "1";
        break;
      case Option.speed60:
        message = "2";
        break;
      case Option.speed70:
        message = "3";
        break;
      default:
        message = "0"; // Default message if none of the options match
    }
    sendMessage(message);
  }

  void updateSelectedOption(Option? newOption) {
    _selectedOption = newOption;
    _isSendButtonEnabled = true;
    notifyListeners();
  }

  void initializeSerialCommunication() {
    final List<PortInfo> portList = SerialPort.getPortsWithFullMessages();
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
    print(ports);
  }

  void sendMessage(String message) async {
    // Check if serialPort is initialized before using it
    if (!serialPort.isOpened) {
      // Initialize serial communication if it's not already initialized
      initializeSerialCommunication();
    }

    // Send the message via the serial port
    serialPort.writeBytesFromString(message);
  }
}
