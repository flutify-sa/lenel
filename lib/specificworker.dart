// ignore_for_file: avoid_print, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sincotdashboard/locations.dart'; // Ensure this import is correct
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SpecificWorker extends StatefulWidget {
  final Map<String, dynamic> worker;

  const SpecificWorker({super.key, required this.worker});

  @override
  State<SpecificWorker> createState() => _SpecificWorkerState();
}

class _SpecificWorkerState extends State<SpecificWorker> {
  final supabase = Supabase.instance.client;
  List<String> imageUrls = [];
  bool isLoading = true;
  String? selectedCode; // Variable to store selected code

  @override
  void initState() {
    super.initState();
    fetchImages();
    _loadSelectedCode(); // Load the selected code from shared preferences
  }

  // Function to fetch selected code from SharedPreferences
  Future<void> _loadSelectedCode() async {
    final prefs = await SharedPreferences.getInstance();
    final workerPin = widget.worker['workerpin']; // Use workerPin as the key
    final savedCode = prefs.getString('selectedCode_$workerPin');
    if (mounted) {
      setState(() {
        selectedCode = savedCode;
      });
    }
  }

  // Function to save selected code to SharedPreferences
  Future<void> _saveSelectedCode(String? code) async {
    final prefs = await SharedPreferences.getInstance();
    final workerPin = widget.worker['workerpin']; // Use workerPin as the key
    await prefs.setString('selectedCode_$workerPin', code ?? '');
  }

  Future<void> fetchImages() async {
    try {
      final workerPin = widget.worker['workerpin'];
      if (workerPin == null) {
        print('Worker Pin is missing.');
        return;
      }

      setState(() {
        isLoading = true;
        imageUrls.clear();
      });

      final documentTypes = ['Address', 'Bank', 'EEA1', 'ID', 'Qualifications'];
      for (final documentType in documentTypes) {
        final response = await supabase.storage
            .from('profiles')
            .list(path: 'uploads/$workerPin/$documentType/');
        if (response.isNotEmpty) {
          final urls = await Future.wait(response.take(4).map((file) async {
            final signedUrl = await supabase.storage
                .from('profiles')
                .createSignedUrl(
                    'uploads/$workerPin/$documentType/${file.name}', 3600);
            return signedUrl;
          }));
          if (mounted) {
            setState(() {
              imageUrls.addAll(urls);
            });
          }
        } else {
          print('No files found in $documentType folder for worker $workerPin');
        }
      }
    } catch (e) {
      print('Error fetching images: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final worker = widget.worker;

    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      appBar: AppBar(
        backgroundColor: Colors.white30,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xffe6cf8c)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          '${worker['name']} ${worker['surname']}',
          style: TextStyle(color: Color(0xffe6cf8c)),
        ),
        actions: [
          // Button to navigate to Locations
          IconButton(
            icon: Icon(Icons.location_on, color: Color(0xffe6cf8c)),
            onPressed: () {
              // Navigate to the Locations widget and pass the selectedCode, name, and surname
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Locations(
                    selectedCode: selectedCode, // Pass selectedCode
                    name: worker['name'], // Pass worker's name
                    surname: worker['surname'], // Pass worker's surname
                  ),
                ),
              );
            },
          ),
          // Display the selected code in the AppBar
          if (selectedCode != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Location: ',
                      style: TextStyle(color: Color(0xffe6cf8c), fontSize: 16),
                    ),
                    TextSpan(
                      text: selectedCode!,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          IconButton(
            icon: Icon(Icons.refresh, color: Color(0xffe6cf8c)),
            onPressed: () {
              fetchImages(); // Re-fetch images on refresh
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Card(
                      color: Color(0xff2c2c2c),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildRow('Full Name: ',
                                '${worker['name']} ${worker['surname']}'),
                            _buildRow('ID: ', '${worker['workerpin']}'),
                            // _buildRow('Pin: ', '${worker['workerpin']}'),
                            _buildRow('Address: ', worker['address'] ?? 'N/A'),
                            _buildRow('Bank Details: ',
                                worker['bank_details'] ?? 'N/A'),
                            _buildRow('Next of Kin: ',
                                worker['next_of_kin'] ?? 'N/A'),
                            _buildRow(
                                'Mobile: ', '0${worker['mobile_number']}'),
                            _buildRow(
                                'Children: ', '${worker['children_names']}'),
                            _buildRow(
                                'Parents: ', '${worker['parent_details']}'),
                          ],
                        ),
                      ),
                    ),
                    // Amber card under the existing card (aligned to the left column)
                    Card(
                      color: Color(0xff2c2c2c), // Amber background
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                // Narrow dropdown for selecting specific code
                                Container(
                                  width: 150, // Set the narrower width
                                  child: DropdownButton<String>(
                                    value: selectedCode,
                                    hint: Text(
                                      'Select Location Code',
                                      style:
                                          TextStyle(color: Color(0xffe6cf8c)),
                                    ),
                                    dropdownColor: Color(0xff2c2c2c),
                                    icon: Icon(Icons.arrow_downward,
                                        color: Color(0xffe6cf8c)),
                                    isExpanded: true,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedCode = newValue;
                                      });
                                      _saveSelectedCode(
                                          newValue); // Save the selected value
                                    },
                                    items: [
                                      'AVD1',
                                      'AVD2',
                                      'DRN',
                                      'GRA1',
                                      'GSO1',
                                      'SPS',
                                      'UKU1',
                                      'UKU2',
                                      'ZIB',
                                      'ZEN',
                                      'BER'
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: TextStyle(
                                              color: Color(0xffe6cf8c)),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Right column with blue.50 background and images
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xff2c2c2c),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Uploaded Documents',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 16),
                      isLoading
                          ? Center(child: CircularProgressIndicator())
                          : imageUrls.isEmpty
                              ? Center(
                                  child: Text(
                                  'No documents found.',
                                  style:
                                      TextStyle(color: Colors.yellow.shade500),
                                ))
                              : GridView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 8,
                                    mainAxisSpacing: 8,
                                  ),
                                  itemCount: imageUrls.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () => _launchURL(imageUrls[index]),
                                      child: Image.network(
                                        imageUrls[index],
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  },
                                ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              color: Color(0xffe6cf8c),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
