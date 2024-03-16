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
    sendMessage("1");
  }

  void updateSelectedOption(Option? newOption) {
    _selectedOption = newOption;
    _isSendButtonEnabled = true;
    notifyListeners();
  }

  void initializeSerialCommunication() {}

  void sendMessage(String message) async {
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
      serialPort.writeBytesFromString(message);
    } else {
      print('No ports available');
    }
    print(portList);
    print(arduinoPort);
    print(ports);
  }
}
