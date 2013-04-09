library companyinfoloader;

import 'package:web_ui/web_ui.dart';
import 'package:web_ui/watcher.dart' as watchers;
import 'package:chopin/chopin.dart' as chopin;
import 'dart:html';

class CompanyInfoLoaderComponent extends WebComponent {
  
  var company;
  
  inserted() {
    chopin.onTokenChange(this, (newToken) {
      var tkn = parent.xtag.token;
      if (tkn == null) {
        tkn = '';
      }
      var tokenInt = int.parse(tkn, onError: (s) => -1);
      if (tokenInt > -1) {
        company = {
          'id': 100001,
          'name': 'Nike',
          'revenue': 3000000.00
        };
        watchers.dispatch();
      }
    });
  }
}