import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

class FileService {
  Future<String> saveFakeImage(Uint8List bytes) async {
    final dir = await getApplicationDocumentsDirectory();
    final fileName = 'img_${DateTime.now().millisecondsSinceEpoch}.png';
    final file = File('${dir.path}/$fileName');

    await file.writeAsBytes(bytes);
    return file.path;
  }
}