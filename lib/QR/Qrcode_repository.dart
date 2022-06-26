


import 'package:check_app/QR/Qrcode_provider.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class QrcodeRepository{
  final QrCodeProvider _qrCodeProvider = QrCodeProvider();

  Future<void> findCode() async {
    Response response = await _qrCodeProvider.findcode();
    dynamic body = await response.body;
    print(body);

}

}