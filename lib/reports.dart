import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:typed_data';

void main() {
  runApp(MaterialApp(
    title: 'Spray Entry PDF Report',
    home: SprayEntryReportPage(),
  ));
}

class SprayEntryReportPage extends StatelessWidget {
  final Map<String, dynamic> sprayEntry = {
    // Your spray entry data goes here
    'status': 'Completed',
    'startdate': 'August 18, 2023 at 8:55:18 AM UTC+3',
    'temperature': 25.5,
    'anyrain': false,
    // Add other fields here
  };

  Future<void> generatePDFReport() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                decoration: pw.BoxDecoration(
                  border: pw.Border(
                    top: pw.BorderSide(
                      color: PdfColors.blue, // Correct usage
                      width: 1.0, // Adjust the width as needed
                    ),
                  ),
                ),
                child: pw.Header(
                  level: 0,
                  text: 'Spray Entry Report',
                  textStyle: pw.TextStyle(fontSize: 24),
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text('Status: ${sprayEntry['status'] ?? ''}',
                  style: pw.TextStyle(fontSize: 16)),
              pw.Text('Start Date: ${sprayEntry['startdate'] ?? ''}',
                  style: pw.TextStyle(fontSize: 16)),
              pw.Text('Temperature: ${sprayEntry['temperature'] ?? ''}',
                  style: pw.TextStyle(fontSize: 16)),
              pw.Text('Rain: ${sprayEntry['anyrain'] ?? ''}',
                  style: pw.TextStyle(fontSize: 16)),
              // Additional fields and safety evaluation
              // ...
            ],
          );
        },
      ),
    );

    final pdfBytes = await pdf.save();
    final outputFile = await savePDF(pdfBytes);

    print('PDF saved to: $outputFile');
  }

  Future<String> savePDF(Uint8List pdfBytes) async {
    final output = await getTemporaryDirectory();
    final outputFile = File('${output.path}/spray_entry_report.pdf');
    await outputFile.writeAsBytes(pdfBytes.toList());
    return outputFile.path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spray Entry Report'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: generatePDFReport,
          child: Text('Generate PDF Report'),
        ),
      ),
    );
  }
}
