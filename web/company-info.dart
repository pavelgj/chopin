library companyinfo;

import 'package:web_ui/web_ui.dart';
import 'dart:html';
import 'package:web_ui/watcher.dart' as watchers;
import 'chopin.dart' as chopin;

class CompanyInfoComponent extends WebComponent {
  
  var company;
  String section;
  
  inserted() {
    parent.xtag.onTokenChange((newToken) {
      print('section new token $newToken');
      if (['info', 'activities', 'notes'].contains(newToken)) {
        showSection(newToken, null, updateUrl: false);
      } else {
        showSection('info', null, replace:true);
      }
    });
    company = parent.xtag.company;
  }
  
  showSection(section, e, {updateUrl: true, replace: false, silent: true}) {
    if (e != null) {
      e.preventDefault();
    }
    this.section = section;
    watchers.dispatch();
    chopin.setToken(this, section, silent: silent, updateUrl: updateUrl, replace: replace);
  }
  
  String activeClass(sect) {
    if (sect == section) {
      return "active";
    }
    return "";
  }

}