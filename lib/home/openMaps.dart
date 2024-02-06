import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';

class DoSearchOnMap extends StatefulWidget {
  const DoSearchOnMap({Key? key}) : super(key: key);

  @override
  State<DoSearchOnMap> createState() => _DoSearchOnMapState();
}

class _DoSearchOnMapState extends State<DoSearchOnMap> {
  double? currentLat;
  double? currentLong;
  bool locationError = false;
  String address = '';
  final Geolocator geolocator = Geolocator();

  @override
  void initState() {
    super.initState();
    initializeLocationInfo();
  }

  Future<void> checkLocationPermission() async {
    Geolocator.getServiceStatusStream().listen((status) {
      if (status == ServiceStatus.enabled) {
        if (mounted) {
          setState(() {
            locationError = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            locationError = true;
          });
        }
      }
    });
  }

  Future<void> checkLocationPermissionAndFetchLocation() async {
    final permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      try {
        final data = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        if (mounted) {
          setState(() {
            currentLat = data.latitude;
            currentLong = data.longitude;
            locationError = false;
          });
        }
      } catch (e) {
        print('Error getting location: $e');
      }
    } else {
      if (mounted) {
        setState(() {
          locationError = true;
        });
      }
    }
  }

  void initializeLocationInfo() {
    checkLocationPermission();
    checkLocationPermissionAndFetchLocation();
  }

  @override
  void dispose() {
    super.dispose();
    initializeLocationInfo();
  }

  @override
  Widget build(BuildContext context) {
    if (locationError) {
      return AlertDialog(
        title: const Text('Turn On Location'),
        content:
            const Text('Please turn on your location to use this feature.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(
            "Maps",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Colors.white, // Set the color of the back icon
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: (currentLat != null && currentLong != null)
            ? OpenStreetMapSearchAndPick(
                center: LatLong(currentLat!, currentLong!),
                onPicked: (pickedData) {
                  setState(() {
                    address = pickedData.addressName;
                  });
                },
                locationPinText: address,
                buttonText: 'Get Address',
              )
            : const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.blue,
                    ),
                    SizedBox(height: 16),
                    Text("Loading...",
                        style: TextStyle(
                          color: Colors.blue,
                        )),
                  ],
                ),
              ),
      );
    }
  }
}
