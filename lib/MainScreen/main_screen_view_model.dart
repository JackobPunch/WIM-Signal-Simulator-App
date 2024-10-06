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

  String? _comPort;
  String? _fqbn;

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
    if (_comPort == null || _fqbn == null) {
      print(
          'Error: Serial communication has not been initialized. Please call initializeSerialCommunication() first.');
      return;
    }

    print(
        'Uploading file: $filePath to port: ${_comPort!} with fqbn: ${_fqbn!}');
    Process.run(
            'arduino-cli', ['upload', '-p', _comPort!, '-b', _fqbn!, filePath])
        .then((ProcessResult results) {
      print('Upload completed with results: ${results.stdout}');
    });
  }

  void updateSelectedOption(Option? newOption) {
    _selectedOption = newOption;
    _isSendButtonEnabled = true;
    notifyListeners();
  }

  void initializeSerialCommunication() async {
    // Run the command and get the output
    ProcessResult result = await Process.run('arduino-cli', ['board', 'list']);

    // Parse the output to get the FQBN
    List<String> lines = result.stdout.toString().split('\n');
    for (String line in lines) {
      if (line.contains('Arduino')) {
        List<String> parts =
            line.split(RegExp(r'\s+')); // Split by one or more spaces
        _comPort = parts[0].trim();
        _fqbn = parts[9].trim(); // FQBN is the fifth part
        break;
      }
    }

    if (_comPort == null || _fqbn == null) {
      print('No Arduino board found.');
    } else {
      print('Detected Arduino board on $_comPort with fqbn $_fqbn');
    }
  }
}
