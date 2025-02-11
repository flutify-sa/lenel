// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:sincotdashboard/individualworker.dart';
import 'package:sincotdashboard/locations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ListOfWorkers extends StatefulWidget {
  const ListOfWorkers({super.key});

  @override
  State<ListOfWorkers> createState() => _ListOfWorkersState();
}

class _ListOfWorkersState extends State<ListOfWorkers> {
  final SupabaseClient _supabase = Supabase.instance.client;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _hourlyRateController = TextEditingController();
  final TextEditingController _projectController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();

  List<Map<String, dynamic>> _workers = [];
  final List<String> _locations = [
    'Avondale - Substation - Upington - AVD1',
    'Avondale - OHL - Upington - AVD2',
    'Doornhoek PV Farm - Klerksdorp - DRN',
    'Graspan - Hopetown - GRA1',
    'Grooetspruit - Allanridge - GSO1',
    'Springbok Solar - Substation & OHL - Virginia - SPS',
    'Umsinde WF, Khangela Umoyeni WF (Northern Cluster) - Substation - Murraysburg - UKU1',
    'Umsinde WF, Khangela Umoyeni WF (Northern Cluster) - OHL- Murraysburg - UKU2',
    'Zibulo overhead lines - Ogies, MP - ZIB',
    'Zen Wind farm - Tulbach, WC - ZEN',
    'Bergrivier Wind Farm - Tulbach, WC - BER',
  ];

  String? _selectedLocation;
  Future<void> _fetchWorkers() async {
    final response =
        await _supabase.from('workers').select('*'); // Fetch all fields

    print(response);

    setState(() {
      _workers = List<Map<String, dynamic>>.from(response);
    });
  }

  Future<void> _handleSubmit() async {
    if (_selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a location')),
      );
      return;
    }

    await _supabase.from('workers').insert([
      {
        'name': _nameController.text,
        'surname': _surnameController.text,
        'id_number': _idController.text,
        'location': _selectedLocation,
        'hourly_rate': double.tryParse(_hourlyRateController.text) ?? 0.0,
        'project': _projectController.text,
        'pin': int.tryParse(_pinController.text) ?? 0,
      }
    ]);

    _fetchWorkers();
    Navigator.of(context).pop();
  }

  void _showFormDialog() {
    _nameController.clear();
    _surnameController.clear();
    _idController.clear();
    _hourlyRateController.clear();
    _projectController.clear();
    _pinController.clear();
    _selectedLocation = null;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Worker'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: _surnameController,
                  decoration: InputDecoration(labelText: 'Surname'),
                ),
                TextField(
                  controller: _idController,
                  decoration: InputDecoration(labelText: 'ID Number'),
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Location'),
                  value: _selectedLocation,
                  items: _locations.map((location) {
                    return DropdownMenuItem<String>(
                      value: location,
                      child: Text(location),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedLocation = newValue;
                    });
                  },
                ),
                TextField(
                  controller: _hourlyRateController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Hourly Rate'),
                ),
                TextField(
                  controller: _projectController,
                  decoration: InputDecoration(labelText: 'Project'),
                ),
                TextField(
                  controller: _pinController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Pin'),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[900],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: _handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[900],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteWorker(String pin) async {
    await _supabase.from('workers').delete().eq('pin', pin);
    _fetchWorkers();
  }

  void _showDeleteConfirmation(String pin) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Worker'),
          content: Text('Are you sure you want to delete this worker?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteWorker(pin);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showEditFormDialog(Map<String, dynamic> worker) {
    _nameController.text = worker['name'] ?? '';
    _surnameController.text = worker['surname'] ?? '';
    _idController.text = worker['id_number'] ?? '';
    _selectedLocation =
        worker['location']; // Ensure this value exists in _locations
    _hourlyRateController.text = worker['hourly_rate']?.toString() ?? '';
    _pinController.text = worker['pin']?.toString() ?? '';
    _projectController.text = worker['project'] ?? '';

    // Check if the selected location is valid
    if (!_locations.contains(_selectedLocation)) {
      _selectedLocation = null; // Reset if not valid
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Worker'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: _surnameController,
                  decoration: InputDecoration(labelText: 'Surname'),
                ),
                TextField(
                  controller: _idController,
                  decoration: InputDecoration(labelText: 'ID Number'),
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Location'),
                  value: _selectedLocation,
                  items: _locations.map((location) {
                    return DropdownMenuItem<String>(
                      value: location,
                      child: Text(location),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedLocation = newValue;
                    });
                  },
                ),
                TextField(
                  controller: _hourlyRateController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Hourly Rate'),
                ),
                TextField(
                  controller: _projectController,
                  decoration: InputDecoration(labelText: 'Project'),
                ),
                TextField(
                  controller: _pinController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Pin'),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[900],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _updateWorker(worker['pin'].toString());
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[900],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateWorker(String pin) async {
    await _supabase.from('workers').update({
      'name': _nameController.text,
      'surname': _surnameController.text,
      'id_number': _idController.text,
      'location': _selectedLocation,
      'hourly_rate': double.tryParse(_hourlyRateController.text) ?? 0.0,
      'project': _projectController.text,
      'pin': int.tryParse(_pinController.text) ?? 0,
    }).eq('pin', pin);

    _fetchWorkers();
  }

  @override
  void initState() {
    super.initState();
    _fetchWorkers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'List of Workers',
          style: TextStyle(color: Color(0xffe6cf8c)),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Color(0xffe6cf8c)),
            onPressed: () {
              _fetchWorkers();
            },
          ),
          IconButton(
            icon: Icon(Icons.location_on, color: Color(0xffe6cf8c)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Locations()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _showFormDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[900],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Add Worker'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                color: Colors.yellow.shade50,
                padding: EdgeInsets.all(8.0),
                child: _workers.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: _workers.length,
                        itemBuilder: (context, index) {
                          final worker = _workers[index];
                          return Container(
                            margin: EdgeInsets.only(bottom: 8.0),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: ListTile(
                              title: Text(
                                  '${worker['name']} ${worker['surname']}'),
                              subtitle: Text('Pin: ${worker['pin']}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () {
                                      _showEditFormDialog(worker);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      _showDeleteConfirmation(
                                          worker['pin'].toString());
                                    },
                                  ),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => IndividualWorker(
                                        pin: worker['pin'].toString()),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
