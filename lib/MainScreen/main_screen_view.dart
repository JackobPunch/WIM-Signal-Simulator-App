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
        'Panel Sterowania Zadajnikiem v. 0.1',
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
          const SizedBox(height: 20),
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
            "Application to control the test signal transmitter. Allows selection of travel speed."),
        Text('Select the speed of the sender:'),
      ],
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
