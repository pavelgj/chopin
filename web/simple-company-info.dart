library simplecompanyinfo;

import 'package:web_ui/web_ui.dart';
import 'dart:html';

class SimpleCompanyInfoComponent extends WebComponent {
  
  var company;
  
  inserted() {
    // TODO(pavelgj): find a better API for accessing the view.
    company = parent.xtag.company;
  }
}