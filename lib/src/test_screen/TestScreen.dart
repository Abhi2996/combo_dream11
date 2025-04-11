// import 'package:flat_management/TestPage/SupaBase/CRUDPage.dart';
import 'package:combo_dream11/src/presentetion/riverpod/match_entry/screens/cricket_filter_screen.dart';
import 'package:combo_dream11/src/presentetion/screens/player_info_form/player_info_form.dart';
import 'package:combo_dream11/src/presentetion/screens/player_list_screen/player_list_page.dart';
import 'package:combo_dream11/src/test_screen/routes/app_routes.dart';
import 'package:flutter/material.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Screen'),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // IP Address input can be uncommented if needed
              // CustomTextField(
              //   controller: _ipController,
              //   hintText: 'Enter IP Address',
              //   onChanged: (text) {
              //     // No need for additional state; using controller to get text
              //   },
              // ),
              // const SizedBox(height: 20),

              // Button to Set IP Address (if used)
              // ElevatedButton(
              //   onPressed: () {
              //     ApiConfig.setIpAddress(_ipController.text);
              //     ScaffoldMessenger.of(context).showSnackBar(
              //       SnackBar(content: Text('IP Address set to ${_ipController.text}')),
              //     );
              //   },
              //   style: CustomElevatedButtonStyle.getButtonStyle(
              //     backgroundColor: Colors.orange.shade300,
              //   ),
              //   child: const Text("Set IP Address"),
              // ),              const SizedBox(height: 30),

              // Button to Navigate to PDF Complaint Report Screen
              _buildStyledButton(
                iconData: Icons.build_circle_sharp,
                context: context,
                label: 'PlayerListPage',
                onPressed: () {
                  NavigationPaths.navigateToScreen(
                    context: context,
                    page: PlayerListPage(),
                  );
                  // AppNavigator.navigateTo(
                  //     context: context,
                  //     // page: const CustomBottomNavigationBar(),
                  //     page: MovieSearchScreen());
                },
              ),
              const SizedBox(height: 30),

              // Button to Navigate to PDF Complaint Report Screen
              _buildStyledButton(
                iconData: Icons.build_circle_sharp,
                context: context,
                label: 'CricketFilterScreen',
                onPressed: () {
                  NavigationPaths.navigateToScreen(
                    context: context,
                    page: CricketFilterScreen(),
                  );
                  // AppNavigator.navigateTo(
                  //     context: context,
                  //     // page: const CustomBottomNavigationBar(),
                  //     page: MovieSearchScreen());
                },
              ),
              const SizedBox(height: 20),

              // Button to Navigate to Dashboard Screen
              _buildStyledButton(
                iconData: Icons.dashboard,
                context: context,
                label: 'PlayerInfoForm ',
                onPressed: () {
                  NavigationPaths.navigateToScreen(
                    context: context,
                    // page: ErrorScreen(
                    //   errorMessage: "$error",
                    //   fullDetails: stackTrace.toString(),
                    // ),
                    page: AddPlayerScreen(),
                  );
                  // AppNavigator.navigateTo(
                  //   context: context,
                  //   page: BottomNavigationScreen(),
                  //   // page: StudentListScreen(),
                  // );
                },
              ),
              //
              // Container(
              //   margin: EdgeInsets.all(50), // Adds 10px outside
              //   width: 250,
              //   height: 250,
              //   color: Colors.black,
              //   child: Container(
              //     width: 150,
              //     height: 150,
              //     color: Colors.amber,
              //   ),
              // )
              //
            ],
          ),
        ),
      ),
    );
  }

  // Method to build styled buttons
  Widget _buildStyledButton({
    required BuildContext context,
    required String label,
    required IconData iconData,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.75,
      child: ElevatedButton.icon(
        iconAlignment: IconAlignment.end,
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          alignment: Alignment.center, // Center the content
          backgroundColor: Colors.black, // Button color
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.0), // Rounded corners
          ),
          // ignore: prefer_const_constructors
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600, // Bold text style for the label
          ),
        ),
        label: Text(label),
        icon: Icon(iconData),
      ),
    );
  }
}
