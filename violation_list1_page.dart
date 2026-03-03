import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ViolationListPage extends StatefulWidget {
  const ViolationListPage({Key? key}) : super(key: key);

  @override
  State<ViolationListPage> createState() => _ViolationListPageState();
}

class _ViolationListPageState extends State<ViolationListPage> {

  List violations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchViolations();
  }

  void fetchViolations() async {
    var url = Uri.parse("http://YOUR_IP/aclc_api/get_violations.php");

    var response = await http.get(url);
    var data = json.decode(response.body);

    setState(() {
      violations = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Violation List")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: violations.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(
                        "Student ID: ${violations[index]['student_id']}"),
                    subtitle: Text(
                        "Violation: ${violations[index]['violation_type']}"),
                  ),
                );
              },
            ),
    );
  }
}