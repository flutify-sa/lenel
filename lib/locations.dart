// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Import Supabase
import 'dart:io'; // For file operations
import 'package:file_picker/file_picker.dart'; // For allowing the user to choose the save location

class Locations extends StatefulWidget {
  const Locations({super.key});

  @override
  State<Locations> createState() => _LocationsState();
}

class _LocationsState extends State<Locations> {
  final SupabaseClient _supabase = Supabase.instance.client;

  List<Map<String, dynamic>> workers = []; // List to store workers data
  List<Map<String, dynamic>> filteredWorkers =
      []; // Filtered list based on search input
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false; // Changed to a state variable

  @override
  void initState() {
    super.initState();
    _fetchWorkers(); // Fetch workers data when the widget initializes
  }

  Future<void> _fetchWorkers() async {
    setState(() {
      _isLoading = true; // Set loading to true
    });
    try {
      final response = await _supabase
          .from('workers')
          .select('name, surname, location'); // Removed the trailing comma
      setState(() {
        workers = List<Map<String, dynamic>>.from(response);
        filteredWorkers =
            workers; // Initialize filteredWorkers with all workers
        _isLoading = false; // Set loading to false after fetching
      });
      print('Fetched workers: $workers'); // Log the fetched workers
    } catch (e) {
      print('Error fetching workers: $e'); // Print the error to the terminal
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch workers: $e')),
        );
      }
      setState(() {
        _isLoading = false; // Set loading to false on error
      });
    }
  }

  // Function to export data to a file
  Future<void> _exportDataToFile() async {
    try {
      // Let the user choose the directory
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

      if (selectedDirectory == null) {
        // User canceled the picker
        return;
      }

      // Create the file in the selected directory
      final file = File('$selectedDirectory/locations.txt');

      // Write the filtered workers list to the file
      final entries = filteredWorkers.map((worker) {
        return '${worker['name']} ${worker['surname']} - ${worker['location']}';
      }).join('\n');
      await file.writeAsString(entries);

      // Show a confirmation message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data exported to ${file.path}')),
        );
      }
    } catch (e) {
      // Handle any exceptions that occur during file export
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to export data: $e')),
        );
      }
    }
  }

  // Function to filter workers based on search query
  void _filterWorkers(String query) {
    setState(() {
      filteredWorkers = workers
          .where((worker) => worker['location']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
      print('Filtered workers: $filteredWorkers'); // Log the filtered workers
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Locations'),
        actions: [
          // Refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchWorkers, // Refresh data
          ),
          // Export button
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _exportDataToFile, // Export data to a file
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by location...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _filterWorkers(''); // Clear the search and show all workers
                  },
                ),
              ),
              onChanged: _filterWorkers, // Filter workers as the user types
            ),
          ),
          // Display filtered workers or "NO LOCATIONS FOUND"
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredWorkers.isEmpty
                    ? Center(
                        child: Text(
                          'NO LOCATIONS FOUND',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredWorkers.length,
                        itemBuilder: (context, index) {
                          final worker = filteredWorkers[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Text(
                              '${worker['name']} ${worker['surname']} - ${worker['location']}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[700],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
