// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sincotdashboard/authservice.dart';
import 'package:sincotdashboard/profilebutton.dart';
import 'package:sincotdashboard/uploaddocuments.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Authservice _authService = Authservice();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _bankDetailsController = TextEditingController();
  final TextEditingController _nextOfKinController = TextEditingController();

  bool _isProfileUpdated = false;
  String _userEmail = ''; // This will store the user's registered email

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _saveProfileToSupabase() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    // Directly insert or update the profile data without any checks or error handling
    await supabase.from('profiles').upsert([
      {
        'user_id': user!.id, // Reference to the authenticated user
        'name': _nameController.text,
        'surname': _surnameController.text,
        'mobile_number': _mobileController.text,
        'address': _addressController.text,
        'bank_details': _bankDetailsController.text,
        'next_of_kin': _nextOfKinController.text,
      }
    ]);

    // Success notification
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Profile saved/updated successfully!')),
    );
  }

  // Load profile data from shared preferences and auth service
  Future<void> _loadProfile() async {
    String email = _authService.getCurrentUserEmail() ?? '';

    // Get profile data from Supabase
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    // Fetch the user's profile from Supabase
    final response = await supabase
        .from('profiles')
        .select()
        .eq('user_id', user!.id)
        .single(); // Fetch a single record

    setState(() {
      // Directly access the fields from the response data
      _nameController.text = response['name'] ?? '';
      _surnameController.text = response['surname'] ?? '';
      _mobileController.text = response['mobile_number'] ?? '';
      _idController.text = response['id'] ?? '';
      _addressController.text = response['address'] ?? '';
      _bankDetailsController.text = response['bank_details'] ?? '';
      _nextOfKinController.text = response['next_of_kin'] ?? '';
      _userEmail = email;
      _isProfileUpdated = true; // Profile is updated when we get data
    });
  }

  // Save profile data to shared preferences
  // ignore: unused_element
  Future<void> _saveProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Save profile data to SharedPreferences (local storage)
    await prefs.setString('name', _nameController.text);
    await prefs.setString('surname', _surnameController.text);
    await prefs.setString('mobile_number', _mobileController.text);
    await prefs.setString('id', _idController.text);
    await prefs.setString('address', _addressController.text);
    await prefs.setString('bankDetails', _bankDetailsController.text);
    await prefs.setString('nextOfKin', _nextOfKinController.text);

    // Now save or update the profile data to Supabase
    await _saveProfileToSupabase();

    _loadProfile(); // Reload profile data after saving
  }

  Future<void> _showEditProfileDialog() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(hintText: 'Name'),
                ),
                TextField(
                  controller: _surnameController,
                  decoration: InputDecoration(hintText: 'Surname'),
                ),
                TextField(
                  controller: _idController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: 'ID'),
                ),
                TextField(
                  controller: _addressController,
                  maxLines: 3, // Multiline
                  decoration: InputDecoration(hintText: 'Address'),
                ),
                TextField(
                  controller: _bankDetailsController,
                  maxLines: 3, // Multiline
                  decoration: InputDecoration(hintText: 'Bank Details'),
                ),
                TextField(
                  controller: _nextOfKinController,
                  decoration: InputDecoration(hintText: 'Next of Kin'),
                ),
                TextField(
                  controller: _mobileController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: 'Mobile',
                    prefixText: '+27 ',
                    errorText: _validateMobileNumber(_mobileController.text)
                        ? null
                        : 'Invalid phone number',
                  ),
                  maxLength:
                      9, // South African numbers allow 9 digits after +27
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[0-9]')), // Allow only numbers
                  ],
                  onChanged: (value) {
                    // Ensure the user cannot input a leading zero
                    if (value.startsWith('0')) {
                      _mobileController.text =
                          value.substring(1); // Remove leading zero
                      _mobileController.selection = TextSelection.fromPosition(
                        TextPosition(offset: _mobileController.text.length),
                      );
                    }
                  },
                ),
                TextField(
                  controller: TextEditingController(text: _userEmail),
                  decoration: InputDecoration(hintText: 'Email'),
                  enabled: false, // Email field is not editable
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (_validateMobileNumber(_mobileController.text)) {
                  await _saveProfileToSupabase(); // Save profile to Supabase
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Invalid mobile number')),
                  );
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  bool _validateMobileNumber(String mobile) {
    // Add +27 prefix dynamically for validation purposes
    if (!mobile.startsWith('+27')) {
      mobile = '+27$mobile';
    }

    final RegExp mobileRegExp = RegExp(r'^\+27[0-9]{9}$');
    return mobileRegExp.hasMatch(mobile);
  }

  // Logout method
  Future<void> logout() async {
    try {
      await _authService.signOut();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logged out successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Profile Page',
          style: TextStyle(
            color: Color(0xffe6cf8c),
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: Icon(Icons.logout, size: 30, color: Color(0xffe6cf8c)),
              onPressed: logout,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // Align from the top
          children: [
            if (_isProfileUpdated) ...[
              Card(
                color: Color(0xff2c2c2c), // Dark card color
                elevation: 4, // Card shadow
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Full Name: ',
                            style: TextStyle(
                                color: Color(0xffe6cf8c), fontSize: 14),
                          ),
                          Text(
                            '${_nameController.text} ${_surnameController.text}',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            'ID: ',
                            style: TextStyle(
                                color: Color(0xffe6cf8c), fontSize: 14),
                          ),
                          Text(
                            _idController.text,
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Address:',
                        style:
                            TextStyle(color: Color(0xffe6cf8c), fontSize: 14),
                      ),
                      Text(
                        _addressController.text,
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Bank Details:',
                        style:
                            TextStyle(color: Color(0xffe6cf8c), fontSize: 14),
                      ),
                      Text(
                        _bankDetailsController.text,
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            'Next of Kin: ',
                            style: TextStyle(
                                color: Color(0xffe6cf8c), fontSize: 14),
                          ),
                          Text(
                            _nextOfKinController.text,
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            'Mobile: ',
                            style: TextStyle(
                                color: Color(0xffe6cf8c), fontSize: 14),
                          ),
                          Text(
                            '0${_mobileController.text}', // Prepend 0 for display
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment
                            .start, // Aligns content to the top
                        children: [
                          Text(
                            'Email: ',
                            style: TextStyle(
                                color: Color(0xffe6cf8c), fontSize: 14),
                          ),
                          Expanded(
                            child: Text(
                              _userEmail,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                              overflow: TextOverflow
                                  .ellipsis, // Optional: Adds "..." if text is too long
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              //  UploadDocuments(),
            ],
            SizedBox(height: 20), // Add spacing between sections
            MyProfileButton(
              onTap: _showEditProfileDialog,
              text: 'Edit Profile',
            ),
            SizedBox(height: 20), // Add spacing between sections
            MyProfileButton(
              onTap: () {
                // Navigate to UploadDocuments screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UploadDocuments()),
                );
              },
              text: 'Upload Documents',
            ),
          ],
        ),
      ),
    );
  }
}
