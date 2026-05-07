import 'package:encrypt/encrypt.dart';
import 'package:password_dart/password_dart.dart';

class EncryptionService {
  String hashPassword(String password) {
    return Password.hash(password, PBKDF2());
  }

  bool verifyPassword(String password, String hashedPassword) {
    return Password.verify(password, hashedPassword);
  }

  Future<String> encrypt(String text, String? key, String? iv) async {
    // Dynamically pad key to 16, 24, or 32 bytes
    final paddedKey = _padKeyDynamically(key!);
    final paddedIv = _padIvDynamically(iv!);
    
    Encrypter encrypter = Encrypter(AES(Key.fromUtf8(paddedKey), mode: AESMode.cbc));
    final encrypted = encrypter.encrypt(text, iv: IV.fromUtf8(paddedIv));
    return encrypted.base64;
  }

  Future<String> decrypt(String encryptedText, String? key, String? iv) async {
    final paddedKey = _padKeyDynamically(key!);
    final paddedIv = _padIvDynamically(iv!);
    
    Encrypter encrypter = Encrypter(AES(Key.fromUtf8(paddedKey), mode: AESMode.cbc));
    final decrypted = encrypter.decrypt(Encrypted.fromBase64(encryptedText), iv: IV.fromUtf8(paddedIv));
    return decrypted;
  }

  /// Pad key dynamically to nearest valid AES size (16, 24, or 32 bytes)
  String _padKeyDynamically(String key) {
    if (key.length >= 32) return key.substring(0, 32); // Use first 32 bytes
    if (key.length >= 24) return key.substring(0, 24); // Use first 24 bytes
    if (key.length >= 16) return key.substring(0, 16); // Use first 16 bytes
    // Pad to 16 bytes if smaller
    return key.padRight(16);
  }

  /// Pad IV dynamically to 16 bytes (required for AES)
  String _padIvDynamically(String iv) {
    if (iv.length >= 16) return iv.substring(0, 16);
    return iv.padRight(16);
  }
}