library companyinfoloader;

import 'package:web_ui/web_ui.dart';
import 'dart:html';
import 'package:web_ui/watcher.dart' as watchers;

class CompanyInfoLoaderComponent extends WebComponent {
  
  var company;
  
  inserted() {
    // TODO(pavelgj): find a better API for accessing the view.
    parent.xtag.onTokenChange((newToken) {
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