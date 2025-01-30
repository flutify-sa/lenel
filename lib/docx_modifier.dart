// docx_modifier.dart

import 'package:archive/archive.dart';
import 'package:xml/xml.dart';
import 'dart:io';
import 'dart:convert';

Future<void> modifyDocx(String filePath, Map<String, String> data) async {
  // Load the DOCX file (ZIP archive)
  final file = File(filePath);
  final bytes = await file.readAsBytes();
  final archive = ZipDecoder().decodeBytes(bytes);

  // Find the document.xml file inside the archive
  final docXmlFile =
      archive.firstWhere((element) => element.name == 'word/document.xml');
  final docXml = utf8.decode(docXmlFile.content);

  // Parse the XML content
  final document = XmlDocument.parse(docXml);

  // Replace placeholders in the XML with actual data
  data.forEach((key, value) {
    final elements = document.findAllElements(key);
    for (var element in elements) {
      element.innerText = value; // Replace the placeholder text
    }
  });

  // Save the modified XML back into the archive
  final modifiedDocXml = Utf8Encoder().convert(document.toXmlString());
  final modifiedDocXmlFile =
      ArchiveFile('word/document.xml', modifiedDocXml.length, modifiedDocXml);

  // Create a new archive with the modified document.xml file
  final modifiedArchive = Archive();
  modifiedArchive.addFile(modifiedDocXmlFile);

  // Save the new DOCX file
  final newDocxFile = File('path/to/save/modified_local.docx');
  await newDocxFile.writeAsBytes(ZipEncoder().encode(modifiedArchive));
}
