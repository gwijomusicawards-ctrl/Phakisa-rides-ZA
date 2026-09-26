iOS configuration notes:
- Run `flutterfire configure` to generate iOS Firebase configuration.
- Add the Google Maps iOS API key in AppDelegate/Info.plist as required by Google Maps Flutter.
- Add NSLocationWhenInUseUsageDescription and background location permissions only if your approved use case needs them.
- Configure signing, bundle identifier, Push Notifications and Background Modes in Xcode before App Store submission.
