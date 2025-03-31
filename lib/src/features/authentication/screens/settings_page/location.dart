import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  GoogleMapController? _mapController;
  LatLng? _currentPosition;
  LatLng? _homePosition;
  final Location _locationService = Location();

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  // Initialize location with permission check
  Future<void> _initializeLocation() async {
    try {
      // Check and request location service
      bool serviceEnabled = await _locationService.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _locationService.requestService();
        if (!serviceEnabled) {
          _showSnackBar('Location services are disabled.', Colors.red);
          return;
        }
      }

      // Check and request location permission
      PermissionStatus permissionGranted =
          await _locationService.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await _locationService.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          _showSnackBar('Location permissions are denied.', Colors.red);
          return;
        }
      }

      // Get current location
      LocationData locationData = await _locationService.getLocation();
      setState(() {
        _currentPosition =
            LatLng(locationData.latitude!, locationData.longitude!);
      });

      // Animate camera to current location
      _mapController?.animateCamera(CameraUpdate.newLatLng(_currentPosition!));

      // Load home location
      _loadHomeLocation();
    } catch (e) {
      _showSnackBar("Error getting location: $e", Colors.red);
    }
  }

  // Save home location
  Future<void> _setHomeLocation() async {
    if (_currentPosition == null) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble("home_lat", _currentPosition!.latitude);
    await prefs.setDouble("home_lng", _currentPosition!.longitude);
    setState(() {
      _homePosition = _currentPosition;
    });
    _showSnackBar("Home location set!", Colors.green);
  }

  // Load home location from shared preferences
  Future<void> _loadHomeLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double? lat = prefs.getDouble("home_lat");
    double? lng = prefs.getDouble("home_lng");

    if (lat != null && lng != null) {
      setState(() {
        _homePosition = LatLng(lat, lng);
      });
    }
  }

  // Open Google Maps for directions
  Future<void> _getDirections() async {
    if (_homePosition == null) {
      _showSnackBar("Home location not set!", Colors.red);
      return;
    }

    final Uri url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=${_homePosition!.latitude},${_homePosition!.longitude}',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      _showSnackBar('Could not open Google Maps.', Colors.red);
    }
  }

  // Display snack bar messages
  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text("Location Settings",
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.green)),
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: isDarkMode ? Colors.white : Colors.green),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh,
                color: isDarkMode ? Colors.white : Colors.green),
            onPressed: _initializeLocation,
          ),
        ],
      ),
      body: Column(
        children: [
          // Google Map
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentPosition ??
                    LatLng(37.7749, -122.4194), // Default: San Francisco
                zoom: 14,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: {
                if (_currentPosition != null)
                  Marker(
                    markerId: MarkerId("current"),
                    position: _currentPosition!,
                    infoWindow: InfoWindow(title: "Current Location"),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueBlue),
                  ),
                if (_homePosition != null)
                  Marker(
                    markerId: MarkerId("home"),
                    position: _homePosition!,
                    infoWindow: InfoWindow(title: "Home Location"),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueRed),
                  ),
              },
              onMapCreated: (controller) {
                _mapController = controller;
              },
            ),
          ),

          // Location Info & Buttons
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  "Current Location: ${_currentPosition?.latitude ?? 'N/A'}, ${_currentPosition?.longitude ?? 'N/A'}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  _homePosition != null
                      ? "Home Location: ${_homePosition?.latitude}, ${_homePosition?.longitude}"
                      : "No home location set",
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildButton("Set Home", Icons.home, _setHomeLocation),
                    SizedBox(width: 20),
                    _buildButton("Update Location", Icons.my_location,
                        _initializeLocation),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildButton(
                        "Directions", Icons.directions, _getDirections),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Custom button widget
  Widget _buildButton(String label, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
