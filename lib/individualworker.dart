// ignore_for_file: avoid_print, deprecated_member_use, unused_import

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class IndividualWorker extends StatefulWidget {
  final String pin;

  const IndividualWorker({super.key, required this.pin});

  @override
  IndividualWorkerState createState() => IndividualWorkerState();
}

class IndividualWorkerState extends State<IndividualWorker> {
  final SupabaseClient _supabase = Supabase.instance.client;
  Map<String, dynamic>? _workerDetails;
  Map<String, dynamic>? _additionalDetails; // For workers data

  @override
  void initState() {
    super.initState();
    _fetchWorkerDetails();
    _fetchAdditionalDetails();
    _fetchDocuments(); // Fetch additional details from workers table
  }

  Future<void> _fetchWorkerDetails() async {
    try {
      final response = await _supabase
          .from('profiles')
          .select(
              'user_id, name, surname, mobile_number, address, bank_details, next_of_kin, said, workerpin, children_names, parent_details, immediatefamily, father_in_law, mother_in_law, acceptance, racegender')
          .eq('workerpin', widget.pin)
          .single();

      setState(() {
        _workerDetails = response;
      });
    } catch (e) {
      print('Error fetching worker details: $e');
    }
  }

  Future<void> _fetchAdditionalDetails() async {
    try {
      final response = await _supabase
          .from('workers')
          .select(
              'location, hourly_rate, project') // Ensure these fields exist in the table
          .eq(
              'pin',
              widget
                  .pin) // Ensure this pin matches the one in the workers table
          .single(); // Use single() to get a single record

      setState(() {
        _additionalDetails = response;
      });
    } catch (e) {
      print('Error fetching additional worker details: $e');
    }
  }

// Define a list to store document URLs
  List<String> _documentUrls = [];

  Future<void> _fetchDocuments() async {
    try {
      final storagePath = 'uploads/${widget.pin}';
      final response =
          await _supabase.storage.from('profiles').list(path: storagePath);

      // Extract and generate URLs
      final documents = response.map((item) => item.name).toList();
      List<String> urls = [];

      for (var fileName in documents) {
        final publicUrl = _supabase.storage
            .from('profiles')
            .getPublicUrl('$storagePath/$fileName');
        urls.add(publicUrl);
      }

      setState(() {
        _documentUrls = urls;
      });
    } catch (e) {
      print('Error fetching documents: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Portal Pin: ${widget.pin}'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              // Call the methods to refresh data
              _fetchWorkerDetails();
              _fetchAdditionalDetails();
              _fetchDocuments();
            },
          ),
        ],
      ),
      body: _workerDetails == null || _additionalDetails == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // Space between cards
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 300),
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          color: Colors.white,
                          shadowColor: Colors.grey.withOpacity(0.5),
                          margin:
                              EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Name: ${_workerDetails!['name']} ${_workerDetails!['surname']}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Mobile Number: ${_workerDetails!['mobile_number']}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Address: ${_workerDetails!['address']}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Bank Details: ${_workerDetails!['bank_details']}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Spouse: ${_workerDetails!['next_of_kin']}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'ID No.: ${_workerDetails!['said']}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Pin: ${_workerDetails!['workerpin']}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Children Names: ${_workerDetails!['children_names']}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Parent Details: ${_workerDetails!['parent_details']}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Immediate Family: ${_workerDetails!['immediatefamily']}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Father-in-Law: ${_workerDetails!['father_in_law']}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Mother-in-Law: ${_workerDetails!['mother_in_law']}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  // Change from acceptance to Date / Time
                                  'Accepted Contract, Policies and Procedures:\n ${_formatAcceptanceDate(_workerDetails!['acceptance'])}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Race/Gender: ${_workerDetails!['racegender'] ?? 'Not specified'}',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16), // Space between the two cards
                  Column(
                    children: [
                      // Top Card
                      SizedBox(
                        height: 150, // Adjust the height as needed
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          color: Colors.white,
                          shadowColor: Colors.grey.withOpacity(0.5),
                          margin:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Location: ${_additionalDetails!['location']}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Hourly Rate: R${_additionalDetails!['hourly_rate']}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Project: ${_additionalDetails!['project']}',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Space between the two cards
                      SizedBox(height: 16),

                      // Bottom Card (currently blank)
                      SingleChildScrollView(
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          color: Colors.white,
                          shadowColor: Colors.grey.withOpacity(0.5),
                          margin:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Uploaded Documents:',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8),
                                _documentUrls.isEmpty
                                    ? Text(
                                        'No documents found.',
                                        style: TextStyle(fontSize: 14),
                                      )
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: _documentUrls.map((url) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: Image.network(
                                              url,
                                              width: 400,
                                              //  height: 150,
                                              fit: BoxFit.cover,
                                              loadingBuilder: (context, child,
                                                  loadingProgress) {
                                                if (loadingProgress == null) {
                                                  return child;
                                                }
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    value: loadingProgress
                                                                .expectedTotalBytes !=
                                                            null
                                                        ? loadingProgress
                                                                .cumulativeBytesLoaded /
                                                            loadingProgress
                                                                .expectedTotalBytes!
                                                        : null,
                                                  ),
                                                );
                                              },
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Icon(Icons.error,
                                                    color: Colors.red);
                                              },
                                            ),
                                          );
                                        }).toList(),
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  String _formatAcceptanceDate(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp); // Convert to DateTime
    return DateFormat('yyyy-MM-dd HH:mm')
        .format(dateTime); // Format as 'YYYY-MM-DD HH:MM'
  }
}
