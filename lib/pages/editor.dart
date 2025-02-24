import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class MyWidget extends StatefulWidget {
  final XFile? photo;
  const MyWidget({super.key, this.photo});
  
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  ColorFilter? _selectedFilter;
  final ScreenshotController _screenshotController = ScreenshotController();

  final Map<String, ColorFilter?> _filters = {
    "Ninguno": null,
    "Rojo": const ColorFilter.mode(Colors.red, BlendMode.modulate),
    "Gris": const ColorFilter.mode(Colors.grey, BlendMode.saturation),
    "Sepia": const ColorFilter.matrix([
      0.393, 0.769, 0.189, 0, 0,
      0.349, 0.686, 0.168, 0, 0,
      0.272, 0.534, 0.131, 0, 0,
      0, 0, 0, 1, 0,
    ]),
    "Azul": const ColorFilter.mode(Colors.blue, BlendMode.modulate),
  };

  Future<void> _saveImage() async {
    // Pedir permiso en Android
    if (Platform.isAndroid) {
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        if (!mounted) return; // Verifica si el widget sigue en pantalla
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Permiso de almacenamiento denegado")),
        );
        return;
      }
    }

    try {
      final Uint8List? imageBytes = await _screenshotController.capture();

      if (imageBytes != null) {
        final result = await ImageGallerySaver.saveImage(imageBytes);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['isSuccess'] == true
                ? "Imagen guardada en la galería"
                : "Error al guardar la imagen"),
          ),
        );
      }
    } catch (e) {
      debugPrint("Error al guardar la imagen: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Scaffold(
          appBar: AppBar(
            leading: const BackButton(),
            title: const Text("Editor de Imagen"),
            actions: [
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: _saveImage,
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: Center(
                  child: Screenshot(
                    controller: _screenshotController,
                    child: widget.photo == null 
                      ? const Icon(Icons.image, size: 100)
                      : ColorFiltered(
                          colorFilter: _selectedFilter ?? const ColorFilter.mode(Colors.transparent, BlendMode.multiply),
                          child: Image.file(
                            File(widget.photo!.path),
                            fit: BoxFit.contain,
                          ),
                        ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                color: Colors.grey[200],
                child: Wrap(
                  spacing: 8.0,
                  children: _filters.entries.map((entry) {
                    return ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedFilter = entry.value;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedFilter == entry.value ? Colors.blueGrey : Colors.white,
                        foregroundColor: _selectedFilter == entry.value ? Colors.white : Colors.black,
                      ),
                      child: Text(entry.key),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
