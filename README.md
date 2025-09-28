# vcapp


## Getting Started

## Build Instructions

### Flutter Version

This app is developed and tested with 
**Flutter (Channel stable, 3.29.2)**. **Dart version 3.7.2**. **Getx state management**

### Build the App

To build the release APK for Android, run the following command in your project directory:

flutter build apk --release

To build the release iOS app (requires macOS and Xcode), run:

flutter build ios --release

### Generate a Signing Key (Keystore) For Android Configure Android

appple@appples-MacBook-Pro Desktop % 

keytool -genkey -v -keystore vcapp-release.keystore -alias vcappkey -keyalg RSA -keysize 2048 -validity 10000

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


###  Ios Configure ios Signing

" ios build "  then open on xcode add your profile accound theb build and archive

