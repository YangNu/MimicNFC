// Shape of the data shown on screen. UI skeleton only — no serialization or
// platform wiring yet; that gets added when the native channel lands.

/// One command -> response pair (hex strings).
class ApduEntry {
  final String command;
  final String response;
  const ApduEntry({required this.command, required this.response});
}

/// Everything read from a single card, for display.
class CapturedCard {
  final String uid;
  final List<String> techList;
  final String historicalBytes;
  final String aid;
  final String? ccFile;
  final String? ndefFile;
  final String ndefFileId;
  final String? ndefText;
  final List<ApduEntry> apduLog;

  const CapturedCard({
    required this.uid,
    required this.techList,
    required this.historicalBytes,
    required this.aid,
    required this.ndefFileId,
    required this.apduLog,
    this.ccFile,
    this.ndefFile,
    this.ndefText,
  });
}
