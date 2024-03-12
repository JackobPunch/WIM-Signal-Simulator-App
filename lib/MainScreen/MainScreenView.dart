import 'package:flutter/material.dart';
import 'MainScreenViewModel.dart';


class MainScreenView extends StatefulWidget {
  @override
  _MainScreenViewState createState() => _MainScreenViewState();
}

class _MainScreenViewState extends State<MainScreenView> {

  final viewModel = MainScreenViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorScheme.fromSeed(seedColor: Colors.blue).primary,
        title: Text('Panel Sterowania Zadajnikiem v. 0.1',
        style: TextStyle(color: Colors.white),),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Aplikacja do sterowania zadajnikiem sygnału testowego. Pozwala na wybór prędkości jazdy."),
            Text('Wybierz prędkość zadajnika:'),
            SizedBox(height: 20),
            Container(width: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 1), // this adds border
                borderRadius: BorderRadius.circular(5), // this makes the border rounded
              ),
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: DropdownButtonHideUnderline( // add this line
              child: DropdownButton<Option>(
                focusColor: Theme.of(context).scaffoldBackgroundColor,
                isExpanded: true,
                value: viewModel.selectedOption,
                onChanged: (Option? newValue) {
                  viewModel.updateSelectedOption(newValue);
                },
                items: Option.values.map<DropdownMenuItem<Option>>((Option value) {
                  return DropdownMenuItem<Option>(
                    value: value,
                    child: Text(value.description.toString().split('.').last),
                  );
                }).toList(),
              ),
            ),
            ),
            SizedBox(height: 40),
            ElevatedButton(onPressed: () {
              viewModel.onButtonPressed();
            }, child: Text("Send") )
          ],
        ),
      ),

    );
  }
}