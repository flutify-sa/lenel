import 'package:flutter/material.dart';
import 'package:sincotdashboard/listofoworkers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
//import 'package:flutter_downloader/flutter_downloader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // // Initialize FlutterDownloader
  // await FlutterDownloader.initialize(
  //   debug: true, // Set to false in production
  // );

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://eepddugdfgbgrkotwhrg.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVlcGRkdWdkZmdiZ3Jrb3R3aHJnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzY4NDA4NDIsImV4cCI6MjA1MjQxNjg0Mn0.9EphzmdSCuj0mmceBP9EWcZ4rP4XYFkzeygsq2-KjYA',
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sincot Trading Dashboard',
      home: ListOfWorkers(),
    );
  }
}
