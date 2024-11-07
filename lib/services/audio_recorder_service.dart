import 'dart:io';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import '../models/attachment.dart';

class AudioRecorderService {
  final Record _recorder = Record();
  String? _currentRecordingPath;
  bool _isRecording = false;

  Future<bool> get hasPermission => _recorder.hasPermission();
  bool get isRecording => _isRecording;

  Future<void> startRecording() async {
    if (await hasPermission) {
      final directory = await getTemporaryDirectory();
      _currentRecordingPath = '${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
      
      await _recorder.start(
        path: _currentRecordingPath,
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        samplingRate: 44100,
      );
      _isRecording = true;
    }
  }

  Future<File?> stopRecording() async {
    if (_isRecording && _currentRecordingPath != null) {
      await _recorder.stop();
      _isRecording = false;
      
      final file = File(_currentRecordingPath!);
      if (await file.exists()) {
        return file;
      }
    }
    return null;
  }

  Future<void> cancelRecording() async {
    if (_isRecording) {
      await _recorder.stop();
      _isRecording = false;
      
      if (_currentRecordingPath != null) {
        final file = File(_currentRecordingPath!);
        if (await file.exists()) {
          await file.delete();
        }
      }
    }
  }

  Future<double?> getAmplitude() async {
    if (_isRecording) {
      final amplitude = await _recorder.getAmplitude();
      return amplitude.current;
    }
    return null;
  }
} 