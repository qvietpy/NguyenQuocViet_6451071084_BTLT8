import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../data/models/image_model.dart';
import '../data/repository/image_repository.dart';
import '../data/services/file_service.dart';

class ImageGalleryScreen extends StatefulWidget {
  const ImageGalleryScreen({super.key});

  @override
  State<ImageGalleryScreen> createState() => _ImageGalleryScreenState();
}

class _ImageGalleryScreenState extends State<ImageGalleryScreen> {
  final ImageRepository _imageRepository = ImageRepository();
  final FileService _fileService = FileService();

  List<ImageModel> _images = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    setState(() {
      _isLoading = true;
    });

    final images = await _imageRepository.getAll();

    setState(() {
      _images = images;
      _isLoading = false;
    });
  }

  Future<void> _addFakeImage() async {
    // Ảnh giả lập: bytes PNG tối thiểu
    final Uint8List fakeBytes = Uint8List.fromList([
      137, 80, 78, 71, 13, 10, 26, 10,
      0, 0, 0, 13, 73, 72, 68, 82,
      0, 0, 0, 1, 0, 0, 0, 1,
      8, 6, 0, 0, 0, 31, 21, 196, 137,
      0, 0, 0, 13, 73, 68, 65, 84,
      120, 156, 99, 248, 15, 4, 0, 9,
      251, 3, 253, 160, 166, 29, 227,
      0, 0, 0, 0, 73, 69, 78, 68,
      174, 66, 96, 130
    ]);

    final path = await _fileService.saveFakeImage(fakeBytes);
    await _imageRepository.insert(ImageModel(path: path));
    await _loadImages();
  }

  Future<void> _deleteImage(ImageModel image) async {
    await _imageRepository.delete(image.id!);

    final file = File(image.path);
    if (await file.exists()) {
      await file.delete();
    }

    await _loadImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lưu ảnh offline - 6451071084'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _images.isEmpty
          ? const Center(child: Text('Chưa có ảnh nào'))
          : GridView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _images.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          final image = _images[index];

          return Stack(
            children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(image.path),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade300,
                        child: const Center(
                          child: Icon(Icons.broken_image),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                top: 6,
                right: 6,
                child: CircleAvatar(
                  backgroundColor: Colors.black54,
                  child: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.white),
                    onPressed: () => _deleteImage(image),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addFakeImage,
        child: const Icon(Icons.add),
      ),
    );
  }
}