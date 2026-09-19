import 'package:flutter/material.dart';

/// NFC availability, for the banner display.
enum NfcStatus { enabled, disabled, unsupported }

/// Colored banner reflecting NFC availability, with a "설정 열기" action when off.
class NfcStatusBanner extends StatelessWidget {
  final NfcStatus status;
  final VoidCallback onOpenSettings;

  const NfcStatusBanner({
    super.key,
    required this.status,
    required this.onOpenSettings,
  });

  @override
  Widget build(BuildContext context) {
    final (Color color, IconData icon, String text, bool showAction) =
        switch (status) {
      NfcStatus.enabled => (Colors.green, Icons.nfc, 'NFC 사용 가능', false),
      NfcStatus.disabled => (
          Colors.orange,
          Icons.warning_amber_rounded,
          'NFC가 꺼져 있습니다',
          true,
        ),
      NfcStatus.unsupported => (
          Colors.red,
          Icons.block,
          '이 기기는 NFC를 지원하지 않습니다',
          false,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
          if (showAction)
            TextButton(
              onPressed: onOpenSettings,
              child: const Text('설정 열기'),
            ),
        ],
      ),
    );
  }
}
