# MedBay

## HOW TO RUN THIS PROJECT FROM GITHUB

1.	Clone the project: Go to the GitHub repository where the Flutter project is hosted and click the "Clone or download" button. Copy the repository URL.

2.	Open a terminal or command prompt: Navigate to the directory where you want to store the project and open a terminal or command prompt.

3.	Clone the repository: Run the command git clone <repository-url> and wait for the project to download.

4.	Install Flutter: If you haven't already, download and install Flutter on your system. Follow the installation guide for your specific operating system on the Flutter website.

5.	Install dependencies: Open a terminal or command prompt and navigate to the project directory. Run the command flutter pub get to install all dependencies listed in the project's pubspec.yaml file.

6.	Set up an emulator or connect a physical device: You can use an emulator to run the app or connect a physical device. To set up an emulator, open Android Studio and select AVD Manager from the Tools menu. Follow the prompts to create and start an emulator. To connect a physical device, follow the instructions provided by your device manufacturer.

7. Setup an OpenAI account and generate an API key. Paste the API key in the chatAi.dart file in lib>screens.
   Setup a Cloud Vision API and generate an auth.json credentials file and put it in the assests folder.
   Setup a Google Maps API account and generate an API key. Then place the API key in the nearbyplaces.dart file in lib>screens.

8.	Run the app: To run the app, open a terminal or command prompt and navigate to your project directory. Run the command flutter run. If you're using an emulator or physical device, make sure it's connected and recognized by Flutter.
