library chopin;

import 'dart:html';
import 'package:web_ui/web_ui.dart';

typedef WebComponent ViewResolver(String viewId, WebComponent target);

abstract class Config {
  ViewResolver viewResolver;
}

setToken(WebComponent comp, String value, {silent: false, updateUrl: true, replace: false}) {
  comp.parent.xtag.setToken(value, silent: silent, updateUrl: updateUrl, replace: replace);
}

typedef bool ElementVisitor(Element e);

visitParents(Element element, ElementVisitor visitor, {includeSelf: false}) {
  var p = includeSelf ? element : element.parent;
  while (p != null) {
    if (!visitor(p)) {
      break;
    }
    p = p.parent;
  }
}

typedef void TokenChangeCallback(String token);

onTokenChange(WebComponent comp, TokenChangeCallback callback) {
  comp.parent.xtag.onTokenChange(callback);
}

Map viewAttributes(WebComponent comp) {
  return comp.parent.xtag.scope;
}