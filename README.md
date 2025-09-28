# vcapp

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Build Instructions

### Flutter Version

This app is developed and tested with **Flutter 3.10**.

### Build the App

To build the release APK for Android, run the following command in your project directory:

flutter build apk --release

To build the release iOS app (requires macOS and Xcode), run:

flutter build ios --release

Generate a Signing Key (Keystore)

appple@appples-MacBook-Pro Desktop % keytool -genkey -v -keystore vcapp-release.keystore -alias vcappkey -keyalg RSA -keysize 2048 -validity 10000

Enter keystore password:  
Re-enter new password: 
They don't match. Try again
Enter keystore password:  
Keystore password is too short - must be at least 6 characters
Enter keystore password:  
Re-enter new password: 
What is your first and last name?
  [Unknown]:  saurbh
What is the name of your organizational unit?
  [Unknown]:  saurbh
What is the name of your organization?
  [Unknown]:  test
What is the name of your City or Locality?
  [Unknown]:  pune
What is the name of your State or Province?
  [Unknown]:  maharastra
What is the two-letter country code for this unit?
  [Unknown]:  in
Is CN=saurbh, OU=saurbh, O=test, L=pune, ST=maharastra, C=in correct?
  [no]:  y

Generating 2,048 bit RSA key pair and self-signed certificate (SHA256withRSA) with a validity of 10,000 days
	for: CN=saurbh, OU=saurbh, O=test, L=pune, ST=maharastra, C=in
[Storing vcapp-release.keystore]


For App sining for android
Use the keytool command found in the Java Development Kit (JDK) to generate a keystore file:
