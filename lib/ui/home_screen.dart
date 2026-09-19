import 'package:flutter/material.dart';

import '../models/captured_card.dart';
import 'widgets/captured_card_view.dart';
import 'widgets/nfc_status_banner.dart';

/// UI layout only. Local state + placeholder content so the composition renders;
/// no NFC/service wiring (that gets added later).
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NfcStatus _status = NfcStatus.enabled;
  bool _scanning = false;
  bool _replaying = false;
  CapturedCard? _card;

  Future<void> _onScan() async {
    setState(() => _scanning = true);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() {
      _scanning = false;
      _card = _placeholderCard;
    });
  }

  void _onToggleReplay() => setState(() => _replaying = !_replaying);

  @override
  Widget build(BuildContext context) {
    final canScan = _status != NfcStatus.unsupported && !_scanning;
    final canReplay = _card != null && _status == NfcStatus.enabled;

    return Scaffold(
      appBar: AppBar(title: const Text('Mimic NFC')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            NfcStatusBanner(status: _status, onOpenSettings: () {}),
            const SizedBox(height: 16),
            _ScanButton(scanning: _scanning, onPressed: canScan ? _onScan : null),
            const SizedBox(height: 24),
            _ReplaySection(
              active: _replaying,
              enabled: canReplay,
              onToggle: _onToggleReplay,
            ),
            const SizedBox(height: 24),
            if (_card != null)
              CapturedCardView(card: _card!)
            else
              const _EmptyState(),
          ],
        ),
      ),
    );
  }
}

class _ScanButton extends StatelessWidget {
  final bool scanning;
  final VoidCallback? onPressed;

  const _ScanButton({required this.scanning, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: FilledButton.icon(
        onPressed: onPressed,
        icon: scanning
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.nfc),
        label: Text(scanning ? '카드를 태그하세요…' : '카드 스캔'),
      ),
    );
  }
}

class _ReplaySection extends StatelessWidget {
  final bool active;
  final bool enabled;
  final VoidCallback onToggle;

  const _ReplaySection({
    required this.active,
    required this.enabled,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final String subtitle;
    if (active) {
      subtitle = '이 폰이 스캔한 카드처럼 동작 중입니다. 리더에 폰을 대세요.\n(앱을 벗어나면 자동으로 꺼집니다)';
    } else if (enabled) {
      subtitle = 'Replay를 켜면 이 폰이 스캔한 카드처럼 동작합니다.';
    } else {
      subtitle = '먼저 카드를 스캔하세요.';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: active ? scheme.primaryContainer : scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(active ? Icons.contactless : Icons.contactless_outlined),
              const SizedBox(width: 8),
              Text(
                active ? 'Replay 동작 중' : 'Replay',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(subtitle),
          const SizedBox(height: 12),
          FilledButton.tonalIcon(
            onPressed: (enabled || active) ? onToggle : null,
            icon: Icon(active ? Icons.stop : Icons.play_arrow),
            label: Text(active ? 'Replay 중지' : 'Replay 시작'),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Icon(Icons.contactless_outlined, size: 48, color: scheme.outline),
          const SizedBox(height: 12),
          Text(
            '아직 스캔한 카드가 없습니다.\n위 스캔 버튼을 눌러 카드를 읽어보세요.',
            textAlign: TextAlign.center,
            style: TextStyle(color: scheme.outline),
          ),
        ],
      ),
    );
  }
}

/// Placeholder shown after a scan so the card layout is visible.
const _placeholderCard = CapturedCard(
  uid: '04A2B3C4D5E6F0',
  techList: ['IsoDep', 'NfcA'],
  historicalBytes: '80737C0202007F',
  aid: 'D2760000850101',
  ccFile: '000F20003B00340406E1040800',
  ndefFile: '0011D1010D55016578616D706C652E636F6D',
  ndefFileId: 'E104',
  ndefText: 'https://example.com',
  apduLog: [
    ApduEntry(command: '00A4040007D276000085010100', response: '9000'),
    ApduEntry(command: '00A4000C02E103', response: '9000'),
    ApduEntry(command: '00B0000000', response: '000F20003B00340406E10408009000'),
    ApduEntry(command: '00A4000C02E104', response: '9000'),
    ApduEntry(command: '00B0000002', response: '00119000'),
    ApduEntry(command: '00B0000211', response: 'D1010D55016578616D706C652E636F6D9000'),
  ],
);
