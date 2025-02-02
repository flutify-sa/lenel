// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:sincotdashboard/individualworker.dart';
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
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _hourlyRateController = TextEditingController();
  final TextEditingController _projectController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();

  // List to store the fetched workers
  List<Map<String, dynamic>> _workers = [];

  Future<void> _fetchWorkers() async {
    final response =
        await _supabase.from('workers').select('name, surname, pin');
    setState(() {
      _workers = List<Map<String, dynamic>>.from(response);
    });
  }

  // Function to handle form submission and insert data into Supabase
  Future<void> _handleSubmit() async {
    await _supabase.from('workers').insert([
      {
        'name': _nameController.text,
        'surname': _surnameController.text,
        'id_number': _idController.text,
        'location': _locationController.text,
        'hourly_rate': double.tryParse(_hourlyRateController.text) ?? 0.0,
        'project': _projectController.text,
        'pin': int.tryParse(_pinController.text) ?? 0,
      }
    ]);

    _fetchWorkers(); // Refresh the list after adding a new worker
    Navigator.of(context).pop(); // Close the dialog
  }

  void _showFormDialog() {
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
                TextField(
                  controller: _locationController,
                  decoration: InputDecoration(labelText: 'Location'),
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
                Navigator.of(context).pop(); // Close the dialog
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
    _fetchWorkers(); // Refresh the list after deletion
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
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteWorker(pin);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchWorkers(); // Fetch workers when the screen loads
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
              _fetchWorkers(); // Call the fetch method when pressed
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
                              trailing: IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _showDeleteConfirmation(
                                      worker['pin'].toString());
                                },
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
