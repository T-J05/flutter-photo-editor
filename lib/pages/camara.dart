import 'package:flutter/material.dart';
import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:image_picker/image_picker.dart';

class PreviewPageE extends StatefulWidget {
  final XFile? photo;
  const PreviewPageE({super.key,this.photo});

  @override
  State<PreviewPageE> createState() => _PreviewPageEState();

}

class _PreviewPageEState extends State<PreviewPageE> {

  late TextureSource texture;
  late BrightnessShaderConfiguration configuration;
  bool textureLoaded = false;

  @override
  void initState() {
    super.initState();
    configuration = BrightnessShaderConfiguration();
    configuration.brightness = 10;
    
    TextureSource.fromAsset(widget.photo!.path) //https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg
        .then((value) => texture = value)
        .whenComplete(
          () => setState(() {
            textureLoaded = true;
          }),
        );
  }

  @override
  Widget build(BuildContext context) {
    return textureLoaded
        ? ImageShaderPreview(
            texture: texture,
            configuration: configuration,
          )
        : const Offstage();
  }
}