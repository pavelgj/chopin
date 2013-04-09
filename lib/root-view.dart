library chopinview;

import 'package:web_ui/web_ui.dart';
import 'dart:html';
import 'package:chopin/chopin.dart' as chopin;
import 'view.dart';

class RootViewComponent extends WebComponent {
  chopin.Config config;
  String currentViewId;
  WebComponent _prevComp;
  WebComponent _prevViewComp;
  bool historyBound = false;
  
  inserted() {
    window.onPopState.listen((_) {
      var hash = window.location.hash;
      print('pop state $hash');
      if (hash != null && hash.startsWith('#/')) {
        var viewId = hash.split('/')[1];
        if (currentViewId != viewId) {
          if (_prevComp != null) {
            host.children.clear();
            var lifecycleCaller = new ComponentItem(_prevComp)
               ..remove();
          }
          var comp = new ViewComponent();
          comp.viewId = viewId;
          comp.historyBound = historyBound;
          _prevComp = createAndInsertComponent(comp);
          currentViewId = viewId;
          _prevViewComp = comp;
        }
        _prevViewComp.propagateTokens(hash.split('/').sublist(2));
      }
    });
  }
  
  createAndInsertComponent(WebComponent comp) {
    comp.host = new DivElement();
    var lifecycleCaller = new ComponentItem(comp)
        ..create();
    host.children.add(comp.host);
    lifecycleCaller.insert();
    return comp;
  }
}