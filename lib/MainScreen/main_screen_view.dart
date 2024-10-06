import 'package:flutter/material.dart';
import 'main_screen_view_model.dart';

class MainScreenView extends StatefulWidget {
  const MainScreenView({super.key});

  @override
  MainScreenViewState createState() => MainScreenViewState();
}

class MainScreenViewState extends State<MainScreenView> {
  final viewModel = MainScreenViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(),
      body: MainBody(viewModel: viewModel),
    );
  }
}

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ColorScheme.fromSeed(seedColor: Colors.blue).primary,
      title: const Text(
        'Sender Control Panel v. 0.1',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class MainBody extends StatelessWidget {
  final MainScreenViewModel viewModel;

  const MainBody({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const DescriptionText(),
          const VehicleChoosing(),
          SpeedDropdown(viewModel: viewModel),
          const SizedBox(height: 40),
          SendButton(viewModel: viewModel),
        ],
      ),
    );
  }
}

class DescriptionText extends StatelessWidget {
  const DescriptionText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          "Application to control the signal transmitter. Allows selection of vehicle and travel speed.",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}

class VehicleChoosing extends StatefulWidget {
  const VehicleChoosing({super.key});

  @override
  VehicleChoosingState createState() => VehicleChoosingState();
}

class VehicleChoosingState extends State<VehicleChoosing> {
  int _currentIndex = 0;
  final List<String> _images = [
    'images/image1.png',
    'images/image2.png',
    'images/image3.png',
    'images/image4.png',
    'images/image5.png',
    'images/image6.png',
    'images/image7.png',
    'images/image8.png',
  ];

  void _previousImage() {
    setState(() {
      _currentIndex = (_currentIndex - 1) % _images.length;
    });
  }

  void _nextImage() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _images.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0.0), // Optional: Add padding if needed
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _previousImage,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Image.asset(
              _images[_currentIndex],
              width: 400,
              height: 400,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: _nextImage,
          ),
        ],
      ),
    );
  }
}

class SpeedDropdown extends StatefulWidget {
  final MainScreenViewModel viewModel;

  const SpeedDropdown({super.key, required this.viewModel});

  @override
  SpeedDropdownState createState() => SpeedDropdownState();
}

class SpeedDropdownState extends State<SpeedDropdown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Option>(
          isExpanded: true,
          value: widget.viewModel.selectedOption,
          hint: const Text('Select Speed'),
          onChanged: (Option? newValue) {
            setState(() {
              widget.viewModel.updateSelectedOption(newValue);
            });
            print('Selected speed: ${newValue?.description}');
          },
          items: Option.values.map<DropdownMenuItem<Option>>((Option value) {
            return DropdownMenuItem<Option>(
              value: value,
              child: Text(value.description.toString().split('.').last),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class SendButton extends StatelessWidget {
  final MainScreenViewModel viewModel;

  const SendButton({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        viewModel.onButtonPressed();
      },
      child: const Text("Send"),
    );
  }
}
