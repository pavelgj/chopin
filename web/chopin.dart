library chopin;

import 'package:web_ui/web_ui.dart';

typedef WebComponent ViewResolver(String viewId, WebComponent target);

abstract class Config {
  ViewResolver viewResolver;
}

setToken(WebComponent comp, String value, {silent: false, updateUrl: true, replace: true}) {
  comp.parent.xtag.setToken(value, silent: silent, updateUrl: updateUrl, replace: replace);
}