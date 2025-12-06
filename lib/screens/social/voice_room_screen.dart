import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled_2/models/voice_room_model.dart';
import 'package:untitled_2/providers/app_provider.dart';
import 'package:untitled_2/theme.dart';
import 'package:untitled_2/models/message_model.dart';

class VoiceRoomScreen extends StatefulWidget {
  final VoiceRoomModel room;

  const VoiceRoomScreen({super.key, required this.room});

  @override
  State<VoiceRoomScreen> createState() => _VoiceRoomScreenState();
}

class _VoiceRoomScreenState extends State<VoiceRoomScreen>
    with SingleTickerProviderStateMixin {
  bool micOn = true;
  bool handRaised = false;
  late Timer _pulseTimer;
  double _pulse = 0.0; // 0..1 for speaking ring
  VoiceRoomModel? _room;
  List<MessageModel> _chat = const [];
  bool _loadingChat = false;

  @override
  void initState() {
    super.initState();
    // Simple loop to simulate active-speaker pulse when mic is on
    _pulseTimer = Timer.periodic(const Duration(milliseconds: 400), (_) {
      if (!mounted) return;
      setState(() {
        _pulse = micOn ? (_pulse >= 1.0 ? 0.0 : _pulse + 0.25) : 0.0;
      });
    });
    _loadRoom();
  }

  @override
  void dispose() {
    _pulseTimer.cancel();
    super.dispose();
  }

  Future<void> _loadRoom() async {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final updated = await provider.voiceRoomService.getRoomById(widget.room.id);
    setState(() {
      _room = updated ?? widget.room;
      final userId = provider.currentUser?.id ?? 'guest';
      handRaised = _room!.raisedHandIds.contains(userId);
    });
  }

  Future<void> _refreshRoom() async {
    await _loadRoom();
  }

  Future<void> _toggleHand() async {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final userId = provider.currentUser?.id ?? 'guest';
    final room = _room ?? widget.room;
    bool ok;
    if (handRaised) {
      ok = await provider.voiceRoomService.lowerHand(room.id, userId);
    } else {
      ok = await provider.voiceRoomService.raiseHand(room.id, userId);
    }
    if (ok) {
      setState(() {
        handRaised = !handRaised;
      });
      await _refreshRoom();
    }
  }

  Future<void> _openRequestsSheet() async {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final room = _room ?? widget.room;
    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (ctx) {
        final requests = room.raisedHandIds;
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Requests to Speak', style: ctx.textStyles.titleLarge?.bold),
              const SizedBox(height: AppSpacing.md),
              if (requests.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                  child: Text('No requests yet', style: ctx.textStyles.bodyMedium?.withColor(
                    Theme.of(ctx).colorScheme.onSurfaceVariant,
                  )),
                )
              else
                ...requests.map((id) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Row(
                    children: [
                      CircleAvatar(radius: 16, child: Text('U${id.split('_').last}')),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(child: Text('User ${id.split('_').last}', style: ctx.textStyles.bodyMedium)),
                      OutlinedButton(
                        onPressed: () async {
                          await provider.voiceRoomService.approveSpeaker(room.id, room.hostId, id);
                          if (ctx.mounted) Navigator.of(ctx).pop();
                          await _refreshRoom();
                        },
                        child: const Text('Approve'),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      IconButton(
                        onPressed: () async {
                          await provider.voiceRoomService.lowerHand(room.id, id);
                          if (ctx.mounted) Navigator.of(ctx).pop();
                          await _refreshRoom();
                        },
                        icon: const Icon(Icons.close),
                      )
                    ],
                  ),
                )),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openChat() async {
    final provider = Provider.of<AppProvider>(context, listen: false);
    setState(() => _loadingChat = true);
    final list = await provider.messageService.getConversationMessages(widget.room.id);
    setState(() {
      _chat = list;
      _loadingChat = false;
    });
    if (!mounted) return;
    final ctrl = TextEditingController();
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            top: AppSpacing.lg,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(Icons.chat_bubble_outline),
                  const SizedBox(width: 8),
                  Text('Room Chat', style: ctx.textStyles.titleLarge?.bold),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                height: 260,
                child: _loadingChat
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                  reverse: true,
                  itemCount: _chat.length,
                  itemBuilder: (c, i) {
                    final msg = _chat[_chat.length - 1 - i];
                    final isMe = msg.senderId == (provider.currentUser?.id ?? 'guest');
                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isMe
                              ? LightModeColors.lightPrimary.withValues(alpha: 0.15)
                              : Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2)),
                        ),
                        child: Text(msg.content, style: ctx.textStyles.bodyMedium),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: ctrl,
                      decoration: const InputDecoration(hintText: 'Message...'),
                      onSubmitted: (_) async {
                        await _sendChat(ctrl.text);
                        ctrl.clear();
                        await _openChat();
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () async {
                      await _sendChat(ctrl.text);
                      ctrl.clear();
                      if (ctx.mounted) Navigator.of(ctx).pop();
                      await _openChat();
                    },
                    icon: const Icon(Icons.send),
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> _sendChat(String text) async {
    final provider = Provider.of<AppProvider>(context, listen: false);
    if (text.trim().isEmpty) return;
    final now = DateTime.now();
    final msg = MessageModel(
      id: 'msg_${now.millisecondsSinceEpoch}',
      conversationId: widget.room.id,
      senderId: provider.currentUser?.id ?? 'guest',
      content: text.trim(),
      createdAt: now,
      updatedAt: now,
    );
    await provider.messageService.sendMessage(msg);
    final list = await provider.messageService.getConversationMessages(widget.room.id);
    setState(() => _chat = list);
  }

  Future<void> _leaveRoom() async {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final userId = provider.currentUser?.id ?? 'guest';
    await provider.voiceRoomService.leaveRoom(widget.room.id, userId);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final user = provider.currentUser;
    final room = _room ?? widget.room;
    final isHost = user?.id == room.hostId;

    // Split participants using server state (host + approved speakers)
    final participants = room.participantIds;
    final speakerList = participants.where((id) => room.speakers.contains(id)).toList();
    final listenerList = participants.where((id) => !room.speakers.contains(id)).toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
          onPressed: () async {
            final shouldLeave = await showModalBottomSheet<bool>(
              context: context,
              showDragHandle: true,
              backgroundColor: Theme.of(context).colorScheme.surface,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
              ),
              builder: (ctx) {
                return Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Leave room?', style: ctx.textStyles.titleLarge?.bold),
                      const SizedBox(height: AppSpacing.sm),
                      Text('You can rejoin anytime from the lobby.',
                          style: ctx.textStyles.bodyMedium?.withColor(
                            Theme.of(ctx).colorScheme.onSurfaceVariant,
                          )),
                      const SizedBox(height: AppSpacing.lg),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => Navigator.of(ctx).pop(false),
                              icon: const Icon(Icons.close, color: Colors.black),
                              label: const Text('Stay'),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: () => Navigator.of(ctx).pop(true),
                              icon: const Icon(Icons.logout, color: Colors.white),
                              label: const Text('Leave', style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            );
            if (shouldLeave == true) {
              await _leaveRoom();
            }
          },
        ),
        centerTitle: true,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(room.name, style: context.textStyles.titleMedium?.bold),
            const SizedBox(height: 2),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _pill(room.language, LightModeColors.lightPrimary),
                const SizedBox(width: 8),
                _livePill(),
              ],
            ),
          ],
        ),
        actions: [
          if (isHost == true)
            IconButton(
              tooltip: 'Requests',
              onPressed: _openRequestsSheet,
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.pan_tool_alt, color: Colors.black),
                  if (room.raisedHandIds.isNotEmpty)
                    Positioned(
                      right: -2,
                      top: -2,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(color: LightModeColors.lightError, shape: BoxShape.circle),
                        child: Text('${room.raisedHandIds.length}', style: const TextStyle(color: Colors.white, fontSize: 10)),
                      ),
                    )
                ],
              ),
            ),
          IconButton(
            tooltip: 'Chat',
            onPressed: _openChat,
            icon: const Icon(Icons.chat_bubble_outline, color: Colors.black),
          ),
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: Row(children: [
              const Icon(Icons.group, size: 18, color: Colors.black),
              const SizedBox(width: 6),
              Text('${participants.length}/${room.maxParticipants}',
                  style: context.textStyles.labelMedium),
            ]),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.paddingMd,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Speakers', style: context.textStyles.titleMedium?.semiBold),
              const SizedBox(height: AppSpacing.md),
              _avatarsGrid(context, speakerList, highlightYou: user?.id),
              const SizedBox(height: AppSpacing.lg),
              Text('Listeners', style: context.textStyles.titleMedium?.semiBold),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: listenerList.isEmpty
                    ? Center(
                  child: Text('No listeners yet',
                      style: context.textStyles.bodyMedium?.withColor(
                        Theme.of(context).colorScheme.onSurfaceVariant,
                      )),
                )
                    : _avatarsGrid(context, listenerList, compact: true),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _controlsBar(context, isHost: isHost ?? false),
    );
  }

  Widget _controlsBar(BuildContext context, {required bool isHost}) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(top: BorderSide(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2))),
        ),
        child: Row(
          children: [
            _pillButton(
              color: micOn ? LightModeColors.accentGreen : LightModeColors.lightError,
              icon: micOn ? Icons.mic : Icons.mic_off,
              label: micOn ? 'Mic On' : 'Mic Off',
              onTap: () => setState(() => micOn = !micOn),
            ),
            const SizedBox(width: AppSpacing.md),
            if (!isHost)
              _pillButton(
                color: handRaised ? LightModeColors.accentAmber : Theme.of(context).colorScheme.outline,
                icon: Icons.pan_tool_alt,
                iconColor: handRaised ? Colors.black : Theme.of(context).colorScheme.onSurface,
                textColor: handRaised ? Colors.black : null,
                label: handRaised ? 'Raised' : 'Raise',
                onTap: _toggleHand,
              ),
            const Spacer(),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: LightModeColors.lightError,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onPressed: _leaveRoom,
              icon: const Icon(Icons.call_end, color: Colors.white),
              label: const Text('Leave', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pill(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(text, style: const TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w600)),
    );
  }

  Widget _livePill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: LightModeColors.accentGreen.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.circle, size: 8, color: LightModeColors.accentGreen),
          const SizedBox(width: 6),
          const Text('Live', style: TextStyle(fontSize: 12, color: LightModeColors.accentGreen, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _avatarsGrid(BuildContext context, List<String> ids, {bool compact = false, String? highlightYou}) {
    final columns = compact ? 5 : 3;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: ids.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: compact ? 0.8 : 0.9,
      ),
      itemBuilder: (context, index) {
        final id = ids[index];
        final isYou = highlightYou != null && id == highlightYou;
        final name = isYou ? 'You' : 'User ${id.split('_').last}';

        return _speakerTile(name, isYou: isYou);
      },
    );
  }

  Widget _speakerTile(String name, {bool isYou = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: isYou && micOn ? 64 + _pulse * 10 : 64,
              height: isYou && micOn ? 64 + _pulse * 10 : 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: LightModeColors.lightPrimaryContainer,
              ),
            ),
            CircleAvatar(
              radius: 24,
              backgroundColor: LightModeColors.lightPrimary.withValues(alpha: 0.1),
              child: Text(
                name.characters.first,
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            if (isYou)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    micOn ? Icons.mic : Icons.mic_off,
                    size: 16,
                    color: micOn ? LightModeColors.accentGreen : LightModeColors.lightError,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _pillButton({
    required Color color,
    required IconData icon,
    required String label,
    Color? iconColor,
    Color? textColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: iconColor ?? Colors.black),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(color: textColor ?? Colors.black, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
