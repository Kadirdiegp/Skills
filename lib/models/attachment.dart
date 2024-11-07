enum AttachmentType {
  image,
  document,
  audio;

  String get displayName {
    switch (this) {
      case AttachmentType.image:
        return 'Image';
      case AttachmentType.document:
        return 'Document';
      case AttachmentType.audio:
        return 'Audio';
    }
  }
}

class ChatAttachment {
  final String id;
  final String url;
  final String fileName;
  final AttachmentType type;
  final int size; // in bytes
  final DateTime uploadTime;

  ChatAttachment({
    required this.id,
    required this.url,
    required this.fileName,
    required this.type,
    required this.size,
    required this.uploadTime,
  });
} 