// ignore_for_file: unused_import

import 'package:flutter/material.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io'; // For file operations
import 'package:path_provider/path_provider.dart'; // For getting the app's documents directory
import 'package:file_picker/file_picker.dart'; // For allowing the user to choose the save location

class Locations extends StatefulWidget {
  final String? selectedCode; // Selected location code
  final String? name; // Worker's name
  final String? surname; // Worker's surname

  const Locations({
    super.key,
    this.selectedCode,
    this.name,
    this.surname,
  });

  @override
  State<Locations> createState() => _LocationsState();
}

class _LocationsState extends State<Locations> {
  // Key for saving data in SharedPreferences
  //static const String _prefsKey = 'worker_location_data';

  // List to store saved entries
  List<String> savedEntries = [];

  // Controller for the search input
  final TextEditingController _searchController = TextEditingController();

  // Filtered list based on search input
  List<String> filteredEntries = [];

  @override
  void initState() {
    super.initState();
    // _loadSavedData(); // Load saved data when the widget initializes
    _saveData(); // Save new data when the widget initializes
  }

  // Function to load saved data from SharedPreferences
  // Future<void> _loadSavedData() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final savedData = prefs.getStringList(_prefsKey) ?? [];
  //   setState(() {
  //     savedEntries = savedData;
  //     filteredEntries =
  //         savedData; // Initialize filteredEntries with all entries
  //   });
  // }

  // Function to save data to SharedPreferences
  Future<void> _saveData() async {
    if (widget.name != null &&
        widget.surname != null &&
        widget.selectedCode != null) {
      final entry = '${widget.name} ${widget.surname} - ${widget.selectedCode}';
      // final prefs = await SharedPreferences.getInstance();

      // Remove all previous entries with the same name and surname
      savedEntries
          .removeWhere((e) => e.startsWith('${widget.name} ${widget.surname}'));

      // Add the new entry
      savedEntries.add(entry);

      // Save the updated list to SharedPreferences
      //   await prefs.setStringList(_prefsKey, savedEntries);

      setState(() {
        filteredEntries =
            savedEntries; // Update filteredEntries with the new list
      });
    }
  }

  // Function to filter entries based on search input
  void _filterEntries(String query) {
    setState(() {
      filteredEntries = savedEntries
          .where((entry) => entry
              .toLowerCase()
              .contains(query.toLowerCase())) // Case-insensitive search
          .toList();
    });
  }

  // Function to export data to a file
  Future<void> _exportDataToFile() async {
    try {
      // Let the user choose the directory
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

      if (selectedDirectory == null) {
        // User canceled the picker
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Export canceled by user')),
          );
        }
        return;
      }

      // Create the file in the selected directory
      final file = File('$selectedDirectory/locations.txt');

      // Write the savedEntries list to the file
      await file.writeAsString(savedEntries.join('\n'));

      // Show a confirmation message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data exported to ${file.path}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to export data: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Locations'),
        actions: [
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
                    _filterEntries(''); // Clear the search and show all entries
                  },
                ),
              ),
              onChanged: _filterEntries, // Filter entries as the user types
            ),
          ),
          // Display filtered entries or "NO LOCATIONS FOUND"
          Expanded(
            child: filteredEntries.isEmpty
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
                    itemCount: filteredEntries.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Text(
                          filteredEntries[index],
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
