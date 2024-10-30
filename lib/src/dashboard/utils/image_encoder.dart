import 'dart:convert';
import 'dart:typed_data';

class ImageEncoder {
  static String encodeImage(Uint8List imageBytes) {
    return base64Encode(imageBytes);
  }
}
