import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class RoleScreen extends StatelessWidget {
  const RoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              const Icon(Icons.local_taxi, size: 70),
              const SizedBox(height: 18),
              const Text('PHAKISA RIDES ZA',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              const Text('Move smarter. Ride safer.',
                  style: TextStyle(fontSize: 17)),
              const Spacer(),
              _button(context, 'Passenger', Icons.person,
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PassengerHome()))),
              const SizedBox(height: 12),
              _button(context, 'Driver', Icons.drive_eta,
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DriverHome()))),
              const SizedBox(height: 24),
              const Center(child: Text('Developed by Otsile Graphics Co.',
                  style: TextStyle(fontSize: 12, color: Colors.black54))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _button(BuildContext c, String text, IconData icon, VoidCallback f) {
    return SizedBox(
      width: double.infinity, height: 58,
      child: FilledButton.icon(onPressed: f, icon: Icon(icon), label: Text(text)),
    );
  }
}

class PassengerHome extends StatefulWidget {
  const PassengerHome({super.key});
  @override State<PassengerHome> createState() => _PassengerHomeState();
}
class _PassengerHomeState extends State<PassengerHome> {
  GoogleMapController? map;
  LatLng? position;
  bool locating = true;

  @override
  void initState() { super.initState(); _locate(); }

  Future<void> _locate() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      setState(() => locating = false); return;
    }
    var p = await Geolocator.checkPermission();
    if (p == LocationPermission.denied) p = await Geolocator.requestPermission();
    if (p == LocationPermission.denied || p == LocationPermission.deniedForever) {
      setState(() => locating = false); return;
    }
    final current = await Geolocator.getCurrentPosition();
    if (!mounted) return;
    setState(() { position = LatLng(current.latitude, current.longitude); locating = false; });
  }

  @override
  Widget build(BuildContext context) {
    final p = position ?? const LatLng(-26.2041, 28.0473);
    return Scaffold(
      appBar: AppBar(title: const Text('Phakisa Rides ZA'), actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.account_circle))
      ]),
      body: Stack(children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(target: p, zoom: 14),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          onMapCreated: (c) => map = c,
          markers: position == null ? {} : {
            Marker(markerId: const MarkerId('pickup'), position: p, infoWindow: const InfoWindow(title: 'Pickup'))
          },
        ),
        Positioned(
          left: 16, right: 16, bottom: 18,
          child: Card(
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                const Align(alignment: Alignment.centerLeft,
                  child: Text('Where are you going?', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
                const SizedBox(height: 12),
                const TextField(decoration: InputDecoration(
                  prefixIcon: Icon(Icons.trip_origin), hintText: 'Pickup location', border: OutlineInputBorder())),
                const SizedBox(height: 10),
                const TextField(decoration: InputDecoration(
                  prefixIcon: Icon(Icons.location_on), hintText: 'Destination', border: OutlineInputBorder())),
                const SizedBox(height: 12),
                SizedBox(width: double.infinity, height: 52,
                  child: FilledButton.icon(
                    onPressed: locating ? null : () => _requestRide(context),
                    icon: const Icon(Icons.search), label: const Text('Find a ride'))),
              ]),
            ),
          ),
        )
      ]),
    );
  }

  void _requestRide(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ride request requires the production backend and live driver matching service.')));
  }
}

class DriverHome extends StatefulWidget {
  const DriverHome({super.key});
  @override State<DriverHome> createState() => _DriverHomeState();
}
class _DriverHomeState extends State<DriverHome> {
  bool online = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Driver Dashboard')),
      body: ListView(padding: const EdgeInsets.all(18), children: [
        Card(child: ListTile(
          leading: Icon(online ? Icons.radio_button_checked : Icons.radio_button_off),
          title: Text(online ? 'You are online' : 'You are offline'),
          subtitle: const Text('Receive nearby ride requests'),
          trailing: Switch(value: online, onChanged: (v) => setState(() => online = v)),
        )),
        const SizedBox(height: 12),
        _tile(Icons.near_me, 'Live location', 'Share your location during an active trip'),
        _tile(Icons.request_page, 'Ride requests', 'Accept or decline incoming requests'),
        _tile(Icons.account_balance_wallet, 'Earnings', 'View completed trips and earnings'),
        _tile(Icons.star, 'Ratings', 'View passenger ratings'),
        _tile(Icons.history, 'Trip history', 'Review previous trips'),
        const SizedBox(height: 24),
        const Center(child: Text('Developed by Otsile Graphics Co.',
            style: TextStyle(fontSize: 12, color: Colors.black54))),
      ]),
    );
  }
  Widget _tile(IconData i, String t, String s) => Card(
    child: ListTile(leading: Icon(i), title: Text(t), subtitle: Text(s), trailing: const Icon(Icons.chevron_right)));
}

class SafetyScreen extends StatelessWidget {
  const SafetyScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Safety')),
    body: ListView(padding: const EdgeInsets.all(18), children: [
      const Text('Emergency assistance', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      FilledButton.icon(
        onPressed: () async {
          final uri = Uri(scheme: 'tel', path: '112');
          if (await canLaunchUrl(uri)) await launchUrl(uri);
        },
        icon: const Icon(Icons.emergency), label: const Text('Call emergency services')),
      const SizedBox(height: 12),
      const Text('For production release, connect SOS events to your backend, emergency workflow and support team.')
    ]),
  );
}
