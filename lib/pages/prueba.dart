import 'package:flutter/material.dart';
import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:image_picker/image_picker.dart';

class PreviewPage extends StatefulWidget {
  final XFile? photo;
  const PreviewPage({super.key,this.photo});

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  late TextureSource texture;
  late GroupShaderConfiguration configuration;
  bool textureLoaded = false;

  @override
  void initState() {
    super.initState();
    configuration = GroupShaderConfiguration();
    configuration.add(BrightnessShaderConfiguration()..brightness = 0.5);
    configuration.add(SaturationShaderConfiguration()..saturation = 0.5);
    TextureSource.fromAsset(widget.photo!.path)
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
        ? PipelineImageShaderPreview(
            texture: texture,
            configuration: configuration,
          )
        : const Offstage();
  }
}
