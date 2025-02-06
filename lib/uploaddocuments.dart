// ignore_for_file: avoid_print

import 'dart:io'; // Import this at the top of your file
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:sincotdashboard/message.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sincotdashboard/uploadbutton.dart';

class UploadDocuments extends StatefulWidget {
  const UploadDocuments({super.key});

  @override
  UploadDocumentsState createState() => UploadDocumentsState();
}

class UploadDocumentsState extends State<UploadDocuments> {
  bool isIdUploaded = false;
  bool isAddressUploaded = false;
  bool isQualificationsUploaded = false;
  bool isEEA1Uploaded = false;
  bool isBankConfirmationUploaded = false;

  Future<void> uploadDocument(String documentType) async {
    try {
      // Step 1: Pick the document file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        withData: true, // Ensure that file bytes are picked
      );

      if (result == null) {
        print("No file selected.");
        return; // If no file selected, return early
      }

      PlatformFile file = result.files.first;
      print("Picked file: ${file.name}");

      // Check if bytes are available
      if (file.bytes == null) {
        print('No file bytes available for ${file.name}.');
        return;
      }

      final fileBytes = file.bytes!;
      final fileName = file.name;

      print("File bytes length: ${fileBytes.length}");

      // Step 2: Create a temporary File object
      final tempFile = await _createTempFile(fileBytes, fileName);

      // Step 3: Create a reference to Supabase storage
      final storage = Supabase.instance.client.storage.from('profiles');

      // Step 4: Upload the file
      await storage.upload(
        'uploads/$documentType/$fileName',
        tempFile,
      );

      // Optional: Update the state after successful upload
      setState(() {
        if (documentType == 'ID') isIdUploaded = true;
        if (documentType == 'Address') isAddressUploaded = true;
        if (documentType == 'Qualifications') isQualificationsUploaded = true;
        //    if (documentType == 'EEA1') isEEA1Uploaded = true;
        if (documentType == 'Bank') isBankConfirmationUploaded = true;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  // Function to create a temporary file from the bytes
  Future<File> _createTempFile(Uint8List bytes, String fileName) async {
    final tempDir = await Directory.systemTemp.createTemp();
    final tempFile = File('${tempDir.path}/$fileName');
    await tempFile.writeAsBytes(bytes);
    return tempFile;
  }

  @override
  Widget build(BuildContext context) {
    // Check if all documents are uploaded
    bool allDocumentsUploaded = isIdUploaded &&
        isAddressUploaded &&
        isQualificationsUploaded &&
        //     isEEA1Uploaded &&
        isBankConfirmationUploaded;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        title: Text(
          'Upload Documents',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'You need to upload the following:\nCopy of ID.\nProof of Address.\nQualifications\nEEA1\nBank Confirmation.',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
              SizedBox(height: 20),
              CheckboxListTile(
                title: Text(
                  'Copy of ID',
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                value: isIdUploaded,
                onChanged: null, // Disable editing
                controlAffinity: ListTileControlAffinity.leading,
                secondary: UploadButtonButton(
                  onTap: isIdUploaded ? null : () => uploadDocument('ID'),
                  text: 'Upload',
                ),
              ),
              const SizedBox(height: 10),
              CheckboxListTile(
                title: Text(
                  'Proof of Address',
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                value: isAddressUploaded,
                onChanged: null, // Disable editing
                controlAffinity: ListTileControlAffinity.leading,
                secondary: UploadButtonButton(
                  onTap: isAddressUploaded
                      ? null
                      : () => uploadDocument('Address'),
                  text: 'Upload',
                ),
              ),
              const SizedBox(height: 10),
              CheckboxListTile(
                title: Text(
                  'Qualifications',
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                value: isQualificationsUploaded,
                onChanged: null, // Disable editing
                controlAffinity: ListTileControlAffinity.leading,
                secondary: UploadButtonButton(
                  onTap: isQualificationsUploaded
                      ? null
                      : () => uploadDocument('Qualifications'),
                  text: 'Upload',
                ),
              ),
              const SizedBox(height: 10),
              CheckboxListTile(
                title: Text(
                  'EEA1',
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                value: isEEA1Uploaded,
                onChanged: null, // Disable editing
                controlAffinity: ListTileControlAffinity.leading,
                secondary: UploadButtonButton(
                  onTap: isEEA1Uploaded ? null : () => uploadDocument('EEA1'),
                  text: 'Upload',
                ),
              ),
              const SizedBox(height: 10),
              CheckboxListTile(
                title: Text(
                  'Bank Confirmation',
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                value: isBankConfirmationUploaded,
                onChanged: null, // Disable editing
                controlAffinity: ListTileControlAffinity.leading,
                secondary: UploadButtonButton(
                  onTap: isBankConfirmationUploaded
                      ? null
                      : () => uploadDocument('Bank'),
                  text: 'Upload',
                ),
              ),
              // Show the Logout button only when all documents are uploaded
              if (allDocumentsUploaded)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle logout here
                      Supabase.instance.client.auth.signOut();
                      // Navigate to MessagePage
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MessagePage(), // Go to MessagePage
                        ),
                      );
                    },
                    child: Text('Logout'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
