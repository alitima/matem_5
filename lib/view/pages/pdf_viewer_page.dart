import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerPage extends StatelessWidget {
  const PdfViewerPage({super.key, required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SfPdfViewer.asset(path),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final byteData = await rootBundle.load(path);
          final file = File(
              '${(await getTemporaryDirectory()).path}/${path.split('/').last}');
          await file.create(recursive: true);
          await file.writeAsBytes(byteData.buffer
              .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
          Share.shareXFiles([XFile(file.path)]);
        },
        child: const Icon(Icons.share),
      ),
    );
  }
}
