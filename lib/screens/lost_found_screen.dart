import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class LostAndFoundPage extends StatefulWidget {
  const LostAndFoundPage({super.key});

  @override
  State<LostAndFoundPage> createState() => _LostAndFoundPageState();
}

class _LostAndFoundPageState extends State<LostAndFoundPage> {
  final List<Map<String, dynamic>> _lostItems = [
    {
      'title': 'Black Water Bottle',
      'description': 'Steel bottle with a dent on the side and a Hydro Flask sticker',
      'category': 'Accessories',
      'location': 'Science Building, 2nd floor',
      'coordinates': const LatLng(40.7135, -74.0055),
      'time': '2 hours ago',
      'image': 'assets/water_bottle.png',
    },
  ];

  final List<Map<String, dynamic>> _foundItems = [
    {
      'title': 'Bluetooth Earbuds (boAt)',
      'description': 'Black earbuds in a square case, blinking blue light',
      'category': 'Electronics',
      'location': 'Library, 1st floor reading area',
      'coordinates': const LatLng(40.7130, -74.0062),
      'time': 'Today',
      'image': 'assets/earbuds.png',
    },
  ];

  LatLng? _currentLocation;
  bool _isLoadingLocation = false;
  bool _locationPermissionDenied = false;
  bool _locationServiceDisabled = false;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    setState(() {
      _locationServiceDisabled = !serviceEnabled;
    });

    if (_locationServiceDisabled) {
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => _locationPermissionDenied = true);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() => _locationPermissionDenied = true);
      return;
    }

    await _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _locationPermissionDenied = false;
        _locationServiceDisabled = false;
      });
    } catch (e) {
      setState(() {
        _locationPermissionDenied = true;
      });
    } finally {
      setState(() => _isLoadingLocation = false);
    }
  }

  void _showAddItemDialog() {
    final _formKey = GlobalKey<FormState>();
    String title = '';
    String description = '';
    String locationDescription = '';
    String category = 'Accessories';
    bool isLost = true;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Report New Item'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Item Title'),
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                    onSaved: (value) => title = value!,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Description'),
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                    onSaved: (value) => description = value!,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Location Description'),
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                    onSaved: (value) => locationDescription = value!,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: category,
                    items: ['Accessories', 'Electronics', 'Stationery', 'Bags', 'Others']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) => category = value!,
                    decoration: const InputDecoration(labelText: 'Category'),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('Status:'),
                      const SizedBox(width: 16),
                      DropdownButton<bool>(
                        value: isLost,
                        items: const [
                          DropdownMenuItem<bool>(
                            value: true,
                            child: Text('Lost'),
                          ),
                          DropdownMenuItem<bool>(
                            value: false,
                            child: Text('Found'),
                          ),
                        ],
                        onChanged: (value) => isLost = value!,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (_currentLocation != null)
                    Text(
                      'Location: ${_currentLocation!.latitude.toStringAsFixed(4)}, '
                          '${_currentLocation!.longitude.toStringAsFixed(4)}',
                      style: const TextStyle(fontSize: 12),
                    )
                  else
                    const Text(
                      'Location not available',
                      style: TextStyle(color: Colors.red),
                    ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  final newItem = {
                    'title': title,
                    'description': description,
                    'category': category,
                    'location': locationDescription,
                    'coordinates': _currentLocation ?? const LatLng(0, 0),
                    'time': 'Just now',
                    'image': '',
                  };

                  setState(() {
                    if (isLost) {
                      _lostItems.insert(0, newItem);
                    } else {
                      _foundItems.insert(0, newItem);
                    }
                  });

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Item ${isLost ? 'lost' : 'found'} reported successfully'),
                    ),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildItemCard(Map<String, dynamic> item, bool isLost) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isLost ? Icons.location_on : Icons.find_in_page,
                  color: isLost ? Colors.red : Colors.green,
                ),
                const SizedBox(width: 8),
                Text(
                  item['title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(item['description']),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.category, size: 16),
                const SizedBox(width: 4),
                Text(
                  item['category'],
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16),
                const SizedBox(width: 4),
                Text(
                  item['location'],
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16),
                const SizedBox(width: 4),
                Text(
                  item['time'],
                  style: const TextStyle(fontSize: 12),
                ),
                const Spacer(),
                if (_currentLocation != null)
                  Text(
                    '${Geolocator.distanceBetween(
                      _currentLocation!.latitude,
                      _currentLocation!.longitude,
                      item['coordinates'].latitude,
                      item['coordinates'].longitude,
                    ).toStringAsFixed(0)}m away',
                    style: const TextStyle(fontSize: 12),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Lost & Found'),
        actions: [
          IconButton(
            icon: _isLoadingLocation
                ? const CircularProgressIndicator()
                : const Icon(Icons.my_location),
            onPressed: _getCurrentLocation,
            tooltip: 'Get current location',
          ),
        ],
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              if (_locationPermissionDenied || _locationServiceDisabled)
          Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.orange[100],
      child: Row(
        children: [
          const Icon(Icons.warning, color: Colors.orange),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _locationServiceDisabled
                  ? 'Location services are disabled'
                  : 'Location permission required',
              style: const TextStyle(color: Colors.orange),
            ),
          ),
          TextButton(
            onPressed: _checkLocationPermission,
            child: const Text('Enable'),
          ),
        ],
      ),
    ),
    const SizedBox(height: 16),

    // LOST Items Section
    const Text(
    'LOST ITEMS',
    style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.red,
    ),
    ),
    const SizedBox(height: 8),
    if (_lostItems.isNotEmpty)
    Column(
    children: _lostItems.map((item) => _buildItemCard(item, true)).toList(),
    )else
    const Padding(
    padding: EdgeInsets.symmetric(vertical: 16),
    child: Center(
    child: Text('No lost items reported'),
    ),
    ),

    const SizedBox(height: 24),

    // FOUND Items Section
    const Text(
    'FOUND ITEMS',
    style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.green,
    ),
    ),
    const SizedBox(height: 8),
    if (_foundItems.isNotEmpty)
    Column(
    children: _foundItems.map((item) => _buildItemCard(item, false)).toList(),
    )else
    const Padding(
    padding: EdgeInsets.symmetric(vertical: 16),
    child: Center(
    child: Text('No found items reported'),
    ),
    ),
    ],
    ),
    ),
    floatingActionButton: FloatingActionButton(
    onPressed: _showAddItemDialog,
    child: const Icon(Icons.add),
    ),
    );
  }
}