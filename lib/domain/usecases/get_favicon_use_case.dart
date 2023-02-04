import 'usecase.dart';

abstract class IGetFaviconUseCase extends IUseCase<String, String> {}

class GetFaviconUseCase implements IGetFaviconUseCase {
  @override
  String execute(String input) {
    return 'https://icon.horse/icon?uri=${_getProperUri(input)}';
  }

  String _getProperUri(String input) {
    final parsedUrl = Uri.tryParse(input);
    if (parsedUrl != null) {
      if (parsedUrl.hasScheme) {
        if (parsedUrl.scheme == "https") {
          return input;
        } else {
          return parsedUrl.replace(scheme: "https").toString();
        }
      } else {
        Uri? schemedUrl = Uri.tryParse('https://$input');
        if (schemedUrl != null) {
          return schemedUrl.toString();
        } else {
          return input;
        }
      }
    } else {
      return input;
    }
  }

// "https://www.gravatar.com/avatar?d=wavatar",
// 'https://www.google.com/s2/favicons?domain=facebook.com',
// 'https://www.facebook.com/favicon.ico',
// 'https://icons.duckduckgo.com/ip2/www.stackoverflow.com.ico',
// 'https://icon.horse/icon/discord.com',
// 'https://icon.horse/icon?uri=https://wikipedia.org',
}
