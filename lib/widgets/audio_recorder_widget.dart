import 'package:flutter/material.dart';
import '../services/audio_recorder_service.dart';
import '../services/attachment_service.dart';

class AudioRecorderWidget extends StatefulWidget {
  final Function(ChatAttachment) onAudioRecorded;

  const AudioRecorderWidget({
    super.key,
    required this.onAudioRecorded,
  });

  @override
  State<AudioRecorderWidget> createState() => _AudioRecorderWidgetState();
}

class _AudioRecorderWidgetState extends State<AudioRecorderWidget> {
  final AudioRecorderService _recorderService = AudioRecorderService();
  final AttachmentService _attachmentService = AttachmentService();
  bool _isRecording = false;
  Duration _duration = Duration.zero;
  double _amplitude = 0.0;

  late final Stream<Duration> _durationStream;
  late final Stream<double> _amplitudeStream;

  @override
  void initState() {
    super.initState();
    _initStreams();
  }

  void _initStreams() {
    _durationStream = Stream.periodic(
      const Duration(seconds: 1),
      (count) => Duration(seconds: count),
    );

    _amplitudeStream = Stream.periodic(
      const Duration(milliseconds: 100),
      (_) => _recorderService.getAmplitude(),
    ).asyncMap((future) async => await future ?? 0.0);
  }

  Future<void> _startRecording() async {
    final hasPermission = await _recorderService.hasPermission;
    if (!hasPermission) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Microphone permission denied')),
      );
      return;
    }

    await _recorderService.startRecording();
    setState(() {
      _isRecording = true;
      _duration = Duration.zero;
    });
  }

  Future<void> _stopRecording() async {
    final recordedFile = await _recorderService.stopRecording();
    setState(() => _isRecording = false);

    if (recordedFile != null) {
      try {
        final attachment = await _attachmentService._uploadFile(
          recordedFile,
          AttachmentType.audio,
        );
        widget.onAudioRecorded(attachment);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload audio: $e')),
        );
      }
    }
  }

  Future<void> _cancelRecording() async {
    await _recorderService.cancelRecording();
    setState(() => _isRecording = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: _isRecording
          ? Row(
              children: [
                StreamBuilder<double>(
                  stream: _amplitudeStream,
                  builder: (context, snapshot) {
                    _amplitude = snapshot.data ?? 0.0;
                    return SizedBox(
                      width: 100,
                      child: LinearProgressIndicator(
                        value: _amplitude,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
                StreamBuilder<Duration>(
                  stream: _durationStream,
                  builder: (context, snapshot) {
                    _duration = snapshot.data ?? Duration.zero;
                    final minutes = _duration.inMinutes.toString().padLeft(2, '0');
                    final seconds = (_duration.inSeconds % 60).toString().padLeft(2, '0');
                    return Text('$minutes:$seconds');
                  },
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.cancel),
                  onPressed: _cancelRecording,
                  color: Colors.red,
                ),
                IconButton(
                  icon: const Icon(Icons.stop),
                  onPressed: _stopRecording,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            )
          : IconButton(
              icon: const Icon(Icons.mic),
              onPressed: _startRecording,
              color: Theme.of(context).colorScheme.primary,
            ),
    );
  }
} 