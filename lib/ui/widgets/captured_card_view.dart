import 'package:flutter/material.dart';

import '../../models/captured_card.dart';

/// Shows every captured field in full (hex, selectable) plus the APDU exchange log.
class CapturedCardView extends StatelessWidget {
  final CapturedCard card;

  const CapturedCardView({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('읽은 카드 정보', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        _field(context, 'UID', card.uid),
        _field(context, '기술 (Tech)', card.techList.join(', ')),
        _field(context, 'Historical / ATS', card.historicalBytes),
        _field(context, 'AID', card.aid),
        _field(context, 'CC 파일', card.ccFile ?? '-'),
        _field(context, 'NDEF 파일 ID', card.ndefFileId),
        _field(context, 'NDEF 파일', card.ndefFile ?? '-'),
        if (card.ndefText != null) _field(context, 'NDEF 내용', card.ndefText!),
        const SizedBox(height: 16),
        Text('APDU 교환 (${card.apduLog.length})', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        ...card.apduLog.map((e) => _apduTile(context, e)),
      ],
    );
  }

  Widget _field(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 2),
          SelectableText(
            value,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _apduTile(BuildContext context, ApduEntry e) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _apduLine(context, '→', e.command, theme.colorScheme.primary),
          const SizedBox(height: 4),
          _apduLine(context, '←', e.response, theme.colorScheme.tertiary),
        ],
      ),
    );
  }

  Widget _apduLine(BuildContext context, String arrow, String value, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(arrow, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        const SizedBox(width: 8),
        Expanded(
          child: SelectableText(
            value,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 12.5),
          ),
        ),
      ],
    );
  }
}
