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
      appBar: AppBar(
        backgroundColor: ColorScheme.fromSeed(seedColor: Colors.blue).primary,
        title: const Text(
          'Panel Sterowania Zadajnikiem v. 0.1',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
                "Aplikacja do sterowania zadajnikiem sygnału testowego. Pozwala na wybór prędkości jazdy."),
            const Text('Wybierz prędkość zadajnika:'),
            const SizedBox(height: 20),
            Container(
              width: 200,
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.blue, width: 1), // this adds border
                borderRadius:
                    BorderRadius.circular(5), // this makes the border rounded
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: DropdownButtonHideUnderline(
                // add this line
                child: DropdownButton<Option>(
                  focusColor: Theme.of(context).scaffoldBackgroundColor,
                  isExpanded: true,
                  value: viewModel.selectedOption,
                  onChanged: (Option? newValue) {
                    setState(() {
                      viewModel.updateSelectedOption(newValue);
                    });
                    print(viewModel
                        .selectedOption); // Print selected option when changed
                  },
                  items: Option.values
                      .map<DropdownMenuItem<Option>>((Option value) {
                    return DropdownMenuItem<Option>(
                      value: value,
                      child: Text(value.description.toString().split('.').last),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
                onPressed: () {
                  viewModel.onButtonPressed();
                },
                child: const Text("Send"))
          ],
        ),
      ),
    );
  }
}
