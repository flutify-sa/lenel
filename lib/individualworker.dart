// ignore_for_file: avoid_print, deprecated_member_use, unused_import

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting
import 'package:sincotdashboard/contract_text_widget.dart';
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
  List<String> _documentUrls = [];
  bool _isLoading = true;

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

  Future<void> _fetchDocuments() async {
    try {
      final response = await _supabase
          .from('profiles')
          .select('user_id')
          .eq('workerpin', widget.pin)
          .single();

      final userID = response['user_id'];
      if (userID == null) {
        print('User ID not found for workerpin: ${widget.pin}');
        return;
      }

      final storagePath = 'uploads/${widget.pin}';
      print('Fetching documents from path: $storagePath');

      final storageResponse =
          await _supabase.storage.from('profiles').list(path: storagePath);

      List<String> urls = [];
      if (storageResponse.isEmpty) {
        print('No documents found in the path $storagePath');
      } else {
        for (var item in storageResponse) {
          final publicUrl = _supabase.storage
              .from('profiles')
              .getPublicUrl('$storagePath/${item.name}');
          urls.add(publicUrl);
        }
      }

      setState(() {
        _documentUrls = urls;
        _isLoading = false; // Set loading state to false when data is fetched
      });
    } catch (e) {
      print('Error fetching documents: $e');
      setState(() {
        _isLoading =
            false; // Set loading state to false even if an error occurs
      });
    }
  }

  // New method to refresh documents
  void _refreshDocuments() {
    setState(() {
      _isLoading = true; // Set loading state to true when refreshing data
    });
    _fetchWorkerDetails();
    _fetchAdditionalDetails();
    _fetchDocuments(); // Call the fetch method to refresh the documents
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffe6cf8c),
        title: Text('Portal Pin: ${widget.pin}'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              // Refresh data and documents
              _refreshDocuments();
            },
          ),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: 8.0), // Set your desired margin
            child: ElevatedButton(
              onPressed: () {
                // Navigate to ContractTextWidget
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContractTextWidget(
                      name: _workerDetails!['name'],
                      surname: _workerDetails!['surname'],
                      mobile: _workerDetails!['mobile_number'],
                      id: _workerDetails!['said'],
                      address: _workerDetails!['address'],
                      bankDetails: _workerDetails!['bank_details'],
                      nextOfKin: _workerDetails!['next_of_kin'],
                      said: _workerDetails!['said'],
                      workerpin: _workerDetails!['workerpin'],
                      childrenNames: _workerDetails!['children_names'],
                      parentDetails: _workerDetails!['parent_details'],
                      location: _additionalDetails!['location'],
                      hourlyRate: _additionalDetails!['hourly_rate'].toString(),
                      project: _additionalDetails!['project'],
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[900], // Background color
                foregroundColor: Colors.white, // Text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                ),
              ),
              child: Text(
                'Generate Contract',
                style: TextStyle(
                    color: Color(0xffe6cf8c)), // Ensure text color is white
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _workerDetails == null || _additionalDetails == null
              ? Center(
                  child:
                      Text("The worker has not uploaded the needed documents."))
              : _documentUrls.isEmpty
                  ? Center(child: Text("No documents found"))
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceBetween, // Space between cards
                        children: [
                          Expanded(
                            flex: 2, // Give more space to the left column
                            child: SingleChildScrollView(
                              // Wrap the Column in a SingleChildScrollView
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Worker Details Card
                                  Card(
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    color: Colors.white,
                                    shadowColor: Colors.grey.withOpacity(0.5),
                                    margin: EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 4),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                              style: TextStyle(fontSize: 16)),
                                          SizedBox(height: 8),
                                          Text(
                                              'Address: ${_workerDetails!['address']}',
                                              style: TextStyle(fontSize: 16)),
                                          SizedBox(height: 8),
                                          Text(
                                              'Bank Details: ${_workerDetails!['bank_details']}',
                                              style: TextStyle(fontSize: 16)),
                                          SizedBox(height: 8),
                                          Text(
                                              'Spouse: ${_workerDetails!['next_of_kin']}',
                                              style: TextStyle(fontSize: 16)),
                                          SizedBox(height: 8),
                                          Text(
                                              'ID No.: ${_workerDetails!['said']}',
                                              style: TextStyle(fontSize: 16)),
                                          SizedBox(height: 8),
                                          Text(
                                              'Pin: ${_workerDetails!['workerpin']}',
                                              style: TextStyle(fontSize: 16)),
                                          SizedBox(height: 8),
                                          Text(
                                              'Children Names: ${_workerDetails!['children_names']}',
                                              style: TextStyle(fontSize: 16)),
                                          SizedBox(height: 8),
                                          Text(
                                              'Parent Details: ${_workerDetails!['parent_details']}',
                                              style: TextStyle(fontSize: 16)),
                                          SizedBox(height: 8),
                                          Text(
                                              'Immediate Family: ${_workerDetails!['immediatefamily']}',
                                              style: TextStyle(fontSize: 16)),
                                          SizedBox(height: 8),
                                          Text(
                                              'Father-in-Law: ${_workerDetails!['father_in_law']}',
                                              style: TextStyle(fontSize: 16)),
                                          SizedBox(height: 8),
                                          Text(
                                              'Mother-in-Law: ${_workerDetails!['mother_in_law']}',
                                              style: TextStyle(fontSize: 16)),
                                          SizedBox(height: 8),
                                          Text(
                                              'Accepted Contract, Policies and Procedures: ${_formatAcceptanceDate(_workerDetails!['acceptance'])}',
                                              style: TextStyle(fontSize: 16)),
                                          SizedBox(height: 8),
                                          Text(
                                              'Race/Gender: ${_workerDetails!['racegender'] ?? 'Not specified'}',
                                              style: TextStyle(fontSize: 16)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5), // Space between cards
                                  // Additional Details Card
                                  Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    color: Colors.white,
                                    shadowColor: Colors.grey.withOpacity(0.5),
                                    margin: EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 4),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              'Location: ${_additionalDetails!['location']}',
                                              style: TextStyle(fontSize: 16)),
                                          SizedBox(height: 8),
                                          Text(
                                              'Hourly Rate: ${_additionalDetails!['hourly_rate']}',
                                              style: TextStyle(fontSize: 16)),
                                          SizedBox(height: 8),
                                          Text(
                                              'Project: ${_additionalDetails!['project']}',
                                              style: TextStyle(fontSize: 16)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Document View Column
                          Expanded(
                            child: Column(
                              children: [
                                SizedBox(height: 10), // Space between columns
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: _documentUrls.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () async {
                                          final url = _documentUrls[index];
                                          if (await canLaunch(url)) {
                                            await launch(url);
                                          } else {
                                            print('Could not launch $url');
                                          }
                                        },
                                        child: Card(
                                          elevation: 3,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          margin: EdgeInsets.all(8),
                                          child: ListTile(
                                            contentPadding: EdgeInsets.all(16),
                                            title: Text(
                                              'Document ${index + 1}',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            trailing: Icon(Icons.open_in_new),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
    );
  }

  String _formatAcceptanceDate(String? date) {
    if (date == null) return 'Not accepted yet';
    try {
      final parsedDate = DateTime.parse(date);
      final formattedDate = DateFormat('dd-MM-yyyy').format(parsedDate);
      return formattedDate;
    } catch (e) {
      return 'Invalid date format';
    }
  }
}
