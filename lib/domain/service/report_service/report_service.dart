import 'package:camera/camera.dart';
import 'package:url_launcher/url_launcher.dart';

class ReportService {
  static void reportCameraException(CameraException e) async {
    var whatsapp = "+6281226292132";
    var text =
        """
          Halo saya menemukan error dengan kode ${e.code} dan pesan ${e.description} dengan detail sebagi berikut
          ${e.toString()}
        """;
    var whatsappURlAndroid =
        "whatsapp://send?phone=" + whatsapp + "&text=${text}";
    var whatappURLIos = "https://wa.me/$whatsapp?text=${text}";
    if (await canLaunchUrl(Uri.parse(whatsappURlAndroid))) {
      await launchUrl(Uri.parse(whatsappURlAndroid));
    } else {
      if (await canLaunchUrl(Uri.parse(whatappURLIos))) {
        await launchUrl(Uri.parse(whatappURLIos));
      } else {}
    }
  }

  static void reportException(String e) async {
    var whatsapp = "+6281226292132";
    var text =
        """
          Halo saya menemukan error detail sebagi berikut
          ${e}
        """;
    var whatsappURlAndroid =
        "whatsapp://send?phone=" + whatsapp + "&text=${text}";
    var whatappURLIos = "https://wa.me/$whatsapp?text=${text}";
    if (await canLaunchUrl(Uri.parse(whatsappURlAndroid))) {
      await launchUrl(Uri.parse(whatsappURlAndroid));
    } else {
      if (await canLaunchUrl(Uri.parse(whatappURLIos))) {
        await launchUrl(Uri.parse(whatappURLIos));
      } else {}
    }
  }
}
