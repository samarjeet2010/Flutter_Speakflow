import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled_2/models/voice_room_model.dart';
import 'package:untitled_2/providers/app_provider.dart';
import 'package:untitled_2/theme.dart';
import 'package:untitled_2/screens/social/voice_room_screen.dart';

class VoiceRoomsLobbyScreen extends StatefulWidget {
  const VoiceRoomsLobbyScreen({super.key});

  @override
  State<VoiceRoomsLobbyScreen> createState() => _VoiceRoomsLobbyScreenState();
}

class _VoiceRoomsLobbyScreenState extends State<VoiceRoomsLobbyScreen> {
  List<VoiceRoomModel> _rooms = [];
  bool _isLoading = true;
  static const List<String> _allLanguages = [
    'English','Spanish','French','German','Italian','Portuguese','Russian','Chinese','Japanese','Korean','Arabic','Hindi','Bengali','Urdu','Punjabi','Turkish','Vietnamese','Thai','Dutch','Swedish','Norwegian','Danish','Finnish','Polish','Czech','Greek','Hebrew','Indonesian','Malay','Tagalog','Tamil','Telugu','Marathi','Gujarati','Ukrainian','Romanian','Hungarian','Persian','Afrikaans','Swahili'
  ];

  @override
  void initState() {
    super.initState();
    _loadRooms();
  }

  Future<void> _loadRooms() async {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final rooms = await provider.voiceRoomService.getAllRooms();
    setState(() {
      _rooms = rooms;
      _isLoading = false;
    });
  }

  Future<void> _showCreateRoomSheet() async {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final user = provider.currentUser;
    final nameCtrl = TextEditingController();
    String language = 'English';
    String speakLang = user?.nativeLanguage ?? 'English';
    String learnLang = user?.targetLanguage ?? 'Spanish';
    String category = 'Conversation';
    int maxParticipants = 8;
    bool isPublic = true;

    final created = await showModalBottomSheet<VoiceRoomModel>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.md,
            right: AppSpacing.md,
            top: AppSpacing.lg,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Create Voice Room', style: ctx.textStyles.titleLarge?.bold),
              const SizedBox(height: AppSpacing.lg),
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Room name',
                  prefixIcon: Icon(Icons.music_note),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: speakLang,
                      items: _allLanguages
                          .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                          .toList(),
                      onChanged: (v) => speakLang = v ?? speakLang,
                      decoration: const InputDecoration(labelText: 'I speak'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: learnLang,
                      items: _allLanguages
                          .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                          .toList(),
                      onChanged: (v) => learnLang = v ?? learnLang,
                      decoration: const InputDecoration(labelText: 'I want to learn'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: category,
                      items: const [
                        DropdownMenuItem(value: 'Conversation', child: Text('Conversation')),
                        DropdownMenuItem(value: 'Practice', child: Text('Practice')),
                        DropdownMenuItem(value: 'Pronunciation', child: Text('Pronunciation')),
                        DropdownMenuItem(value: 'Study', child: Text('Study')),
                      ],
                      onChanged: (v) => category = v ?? category,
                      decoration: const InputDecoration(labelText: 'Category'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: language,
                      items: _allLanguages
                          .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                          .toList(),
                      onChanged: (v) => language = v ?? language,
                      decoration: const InputDecoration(labelText: 'Room language'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: maxParticipants,
                      items: const [8, 10, 12, 16]
                          .map((v) => DropdownMenuItem(value: v, child: Text('$v people')))
                          .toList(),
                      onChanged: (v) => maxParticipants = v ?? maxParticipants,
                      decoration: const InputDecoration(labelText: 'Max participants'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: SwitchListTile(
                      value: isPublic,
                      onChanged: (v) => isPublic = v,
                      title: const Text('Public room'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () async {
                    final hostName = user?.name ?? 'Guest';
                    final hostId = user?.id ?? 'guest';
                    final room = await provider.voiceRoomService.createRoom(
                      name: nameCtrl.text.trim().isEmpty ? '$language $category Room' : nameCtrl.text.trim(),
                      category: category,
                      language: language,
                      hostId: hostId,
                      hostName: hostName,
                      maxParticipants: maxParticipants,
                      isPublic: isPublic,
                      hostNativeLanguage: speakLang,
                      learningLanguage: learnLang,
                    );
                    if (room != null && ctx.mounted) Navigator.of(ctx).pop(room);
                  },
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text('Create room', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (created != null) {
      // Update lobby list and navigate into room
      await _loadRooms();
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => VoiceRoomScreen(room: created),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Rooms'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingMd,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Active Rooms', style: context.textStyles.headlineSmall?.bold),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Join a room and practice speaking with others',
                style: context.textStyles.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              ...List.generate(_rooms.length, (index) {
                final room = _rooms[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: VoiceRoomCard(room: room),
                );
              }),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateRoomSheet,
        icon: const Icon(Icons.add),
        label: const Text('Create Room'),
      ),
    );
  }
}

class VoiceRoomCard extends StatelessWidget {
  final VoiceRoomModel room;

  const VoiceRoomCard({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.paddingMd,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: LightModeColors.lightPrimary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Text(
                  room.language,
                  style: context.textStyles.bodySmall?.copyWith(
                    color: LightModeColors.lightPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: LightModeColors.accentGreen.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.circle, size: 8, color: LightModeColors.accentGreen),
                    const SizedBox(width: 4),
                    Text(
                      'Live',
                      style: context.textStyles.bodySmall?.copyWith(
                        color: LightModeColors.accentGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(room.name, style: context.textStyles.titleLarge?.bold),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Text(
                'Hosted by ${room.hostName}',
                style: context.textStyles.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              Text(' • ', style: context.textStyles.bodySmall),
              Text(
                room.category,
                style: context.textStyles.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    ...List.generate(
                      room.participantIds.length.clamp(0, 3),
                          (index) => Transform.translate(
                        offset: Offset(index * -8.0, 0),
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: LightModeColors.lightPrimaryContainer,
                          child: Text(
                            String.fromCharCode(65 + index),
                            style: context.textStyles.bodySmall?.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      '${room.participantIds.length}/${room.maxParticipants}',
                      style: context.textStyles.bodyMedium?.semiBold,
                    ),
                  ],
                ),
              ),
              FilledButton(
                onPressed: () async {
                  final provider = Provider.of<AppProvider>(context, listen: false);
                  final userId = provider.currentUser?.id ?? 'guest';
                  final ok = await provider.voiceRoomService.joinRoom(room.id, userId);
                  if (ok && context.mounted) {
                    // Reload lobby list to reflect counts
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => VoiceRoomScreen(room: room),
                      ),
                    );
                  }
                },
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                ),
                child: Text('Join', style: const TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
