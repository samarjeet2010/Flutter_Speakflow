import 'package:flutter/material.dart';
import 'package:untitled_2/theme.dart';

class AIVoiceChatScreen extends StatefulWidget {
  const AIVoiceChatScreen({super.key});

  @override
  State<AIVoiceChatScreen> createState() => _AIVoiceChatScreenState();
}

class _AIVoiceChatScreenState extends State<AIVoiceChatScreen> with SingleTickerProviderStateMixin {
  late AnimationController _waveController;
  bool _isRecording = false;
  String _selectedAccent = 'Neutral';

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  void _toggleRecording() {
    setState(() => _isRecording = !_isRecording);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Chat'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.paddingXl,
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.xl),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [LightModeColors.lightPrimary, LightModeColors.lightSecondary],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text('🤖', style: TextStyle(fontSize: 64)),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'AI Voice Assistant',
                style: context.textStyles.headlineSmall?.bold,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                _isRecording ? 'Listening...' : 'Tap to speak',
                style: context.textStyles.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              if (_isRecording)
                AnimatedBuilder(
                  animation: _waveController,
                  builder: (context, child) {
                    return CustomPaint(
                      size: const Size(300, 100),
                      painter: WaveformPainter(_waveController.value),
                    );
                  },
                ),
              const Spacer(),
              Text('Select Accent', style: context.textStyles.titleMedium?.semiBold),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                alignment: WrapAlignment.center,
                children: ['Neutral', 'British', 'American', 'Australian'].map((accent) {
                  return ChoiceChip(
                    label: Text(accent),
                    selected: _selectedAccent == accent,
                    onSelected: (selected) => setState(() => _selectedAccent = accent),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.xl),
              GestureDetector(
                onTap: _toggleRecording,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _isRecording
                          ? [Colors.red, Colors.redAccent]
                          : [LightModeColors.lightPrimary, LightModeColors.lightSecondary],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (_isRecording ? Colors.red : LightModeColors.lightPrimary).withValues(alpha: 0.4),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Icon(
                    _isRecording ? Icons.stop : Icons.mic,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.volume_up_outlined),
                    iconSize: 32,
                  ),
                  const SizedBox(width: AppSpacing.xl),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.translate_outlined),
                    iconSize: 32,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}

class WaveformPainter extends CustomPainter {
  final double animationValue;

  WaveformPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = LightModeColors.lightPrimary
      ..strokeWidth = 3
      ..style = PaintingStyle.fill;

    final barCount = 40;
    final barWidth = size.width / barCount;

    for (int i = 0; i < barCount; i++) {
      final normalizedI = i / barCount;
      final wave = (normalizedI - animationValue).abs();
      final height = size.height * (0.2 + 0.6 * (1 - wave * 2).clamp(0.0, 1.0));

      final rect = Rect.fromLTWH(
        i * barWidth,
        (size.height - height) / 2,
        barWidth * 0.7,
        height,
      );

      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(2)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(WaveformPainter oldDelegate) => true;
}
