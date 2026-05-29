import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

/// GitHub Releases Update Checker
/// Checks https://github.com/YOUR_USERNAME/TNPSC-AI-App/releases for new versions
class UpdateService {
  static final UpdateService instance = UpdateService._init();
  UpdateService._init();

  // ─── CHANGE THIS to your GitHub username and repo name ───
  static const String _githubUser = 'SriSarvesh08';
  static const String _githubRepo = 'app';
  // ─────────────────────────────────────────────────────────

  static const String _apiUrl =
      'https://api.github.com/repos/$_githubUser/$_githubRepo/releases/latest';

  /// Returns update info if a newer version exists, null otherwise
  Future<UpdateInfo?> checkForUpdate() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version; // e.g. "1.0.0"

      final response = await http
          .get(Uri.parse(_apiUrl), headers: {'Accept': 'application/vnd.github.v3+json'})
          .timeout(const Duration(seconds: 8));

      if (response.statusCode != 200) return null;

      final data = json.decode(response.body) as Map<String, dynamic>;

      // GitHub tag is like "v1.1.0" — strip the "v"
      final latestTag = (data['tag_name'] as String).replaceAll('v', '').trim();
      final releaseNotes = data['body'] as String? ?? 'Bug fixes and improvements.';

      if (_isNewerVersion(latestTag, currentVersion)) {
        // Find the APK asset download URL
        final assets = data['assets'] as List<dynamic>? ?? [];
        String downloadUrl =
            'https://github.com/$_githubUser/$_githubRepo/releases/latest';
        for (final asset in assets) {
          final name = asset['name'] as String? ?? '';
          if (name.endsWith('.apk')) {
            downloadUrl = asset['browser_download_url'] as String;
            break;
          }
        }

        return UpdateInfo(
          currentVersion: currentVersion,
          latestVersion: latestTag,
          releaseNotes: releaseNotes,
          downloadUrl: downloadUrl,
        );
      }

      return null; // Already up to date
    } catch (e) {
      // Silently fail — don't crash app if GitHub is unreachable
      return null;
    }
  }

  /// Compares "1.2.0" vs "1.1.0" — returns true if [latest] is newer than [current]
  bool _isNewerVersion(String latest, String current) {
    try {
      final latestParts = latest.split('.').map(int.parse).toList();
      final currentParts = current.split('.').map(int.parse).toList();

      // Pad shorter version with zeros
      while (latestParts.length < 3) latestParts.add(0);
      while (currentParts.length < 3) currentParts.add(0);

      for (int i = 0; i < 3; i++) {
        if (latestParts[i] > currentParts[i]) return true;
        if (latestParts[i] < currentParts[i]) return false;
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}

class UpdateInfo {
  final String currentVersion;
  final String latestVersion;
  final String releaseNotes;
  final String downloadUrl;

  const UpdateInfo({
    required this.currentVersion,
    required this.latestVersion,
    required this.releaseNotes,
    required this.downloadUrl,
  });
}
