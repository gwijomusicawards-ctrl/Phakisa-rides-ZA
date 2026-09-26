# Phakisa Rides ZA

Professional Flutter ride-hailing app for Android and iOS.

## Production services required
This project is structured for live services. Before release, configure:
1. Firebase project + Android/iOS apps
2. Google Maps SDK/API key
3. Firestore security rules
4. Firebase Authentication
5. Firebase Cloud Messaging
6. A production payment provider suitable for South Africa
7. A secure backend/cloud function for fare calculation, matching, trip state and payment webhooks
8. Apple Developer and Google Play developer accounts

Do not put secret payment credentials in the mobile app.

## Run
flutter pub get
flutter run

## Android
flutter build apk --release
flutter build appbundle --release

## iOS (requires macOS + Xcode)
flutter build ios --release

## Branding
App: Phakisa Rides ZA
Developer credit: Developed by Otsile Graphics Co.

## Important
The app contains no fake driver GPS, fake payment success, or simulated completed rides. Live functionality becomes active after the listed production services are configured.
