library simplecompanyinfo;

import 'package:web_ui/web_ui.dart';
import 'package:chopin/chopin.dart' as chopin;
import 'dart:html';

class SimpleCompanyInfoComponent extends WebComponent {
  var company;
  
  inserted() {
    company = chopin.viewAttributes(this)['company'];
  }
}