// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WorkerPage extends StatefulWidget {
  const WorkerPage({super.key});

  @override
  State<WorkerPage> createState() => _WorkerPageState();
}

class _WorkerPageState extends State<WorkerPage> {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Initialize _userList directly to ensure it is set
  final Future<List<Map<String, dynamic>>> _userList =
      Supabase.instance.client.from('profiles').select().then((response) {
    // ignore: unnecessary_null_comparison
    if (response == null || response.isEmpty) {
      throw Exception('No user data found.');
    }
    return List<Map<String, dynamic>>.from(response);
  });

  Future<void> logout() async {
    await _supabase.auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Worker Page',
          style: TextStyle(color: Color(0xffe6cf8c)),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _userList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final users = snapshot.data!;
            if (users.isEmpty) {
              return Center(child: Text('No users found.'));
            }
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];

                return Column(
                  children: [
                    Card(
                      color: Color(0xff2c2c2c),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
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
                                  '${user['name']} ${user['surname']}',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'ID: ',
                                      style: TextStyle(
                                          color: Color(0xffe6cf8c),
                                          fontSize: 14),
                                    ),
                                    Text(
                                      '${user['said']} ',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Text(
                                      'Pin: ',
                                      style: TextStyle(
                                          color: Color(0xffe6cf8c),
                                          fontSize: 14),
                                    ),
                                    Text(
                                      user['workerpin'].toString(),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Address:',
                              style: TextStyle(
                                  color: Color(0xffe6cf8c), fontSize: 14),
                            ),
                            Text(
                              user['address'] ?? 'N/A',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Bank Details:',
                              style: TextStyle(
                                  color: Color(0xffe6cf8c), fontSize: 14),
                            ),
                            Text(
                              user['bank_details'] ?? 'N/A',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
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
                                  user['next_of_kin'] ?? 'N/A',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
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
                                  '0${user['mobile_number']}',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10), // Space between card and text
                    Card(
                      color: Color(0xff2c2c2c), // Dark card color
                      elevation: 4, // Card shadow
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Rounded corners
                      ),
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'This is the info from the database from the user.\nNow I need to know from you what you\nwant to add to this.',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Such as a button to add something to the record or anything else.',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              },
            );
          }
          return Center(child: Text('No data found.'));
        },
      ),
    );
  }
}
