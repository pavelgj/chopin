library chopinview;

import 'package:web_ui/web_ui.dart';
import 'dart:html';
import 'dart:async';
import 'package:chopin/chopin.dart';
import 'root-view.dart';

class ViewComponent extends WebComponent {
  String viewId;
  Config _config;
  var scope = {};
  bool historyBound = false;
  String token;
  List<Function> tokenChangeCallbacks = [];
  
  Config get config {
    if (_config == null) {
      visitParents(this, (p) {
        if (p.tagName == 'X-ROOT-VIEW') {
          _config = p.xtag.config;
          return false;
        }
        return true;
      });
      if (_config == null) {
        throw new StateError('expected to find X-ROOT-VIEW as one of the ancestors.');
      }
    }
    return _config;
  }
  
  ViewComponent get parentView {
    var pv = null;
    visitParents(this, (p) {
      if (p.xtag != null && p.xtag is ViewComponent) {
        pv = p.xtag;
        return false;
      }
      return true;
    });
    return pv;
  }
  
  noSuchMethod(InvocationMirror invocation) {
    if (invocation.isGetter) {
      return scope[invocation.memberName];
    }
    if (invocation.isSetter) {
      scope[invocation.memberName.substring(0, invocation.memberName.length - 1)] = invocation.positionalArguments[0];
      return;
    }
    super.noSuchMethod(invocation);
  }
  
  inserted() {
    var comp = config.viewResolver(viewId, this);
    createAndInsertComponent(comp, this);
  }
  
  propagateTokens(List<String> stack) {
    var tail;
    if (stack.length > 0) {
      token = stack[0];
      tail = stack.sublist(1);
    } else {
      token = null;
      tail = [];
    }
    tokenChangeCallbacks.forEach((c) => c(token));
    _propagateToChildViews(host.children, tail);
  }
  
  _propagateToChildViews(List<Element> children, List<String> tail) {
    children.forEach((c) {
      if (c.xtag != null && c.xtag is ViewComponent) {
        c.xtag.propagateTokens(tail);
      } else {
        _propagateToChildViews(c.children, tail);
      }
    });
  }
  
  setToken(String token, {silent: false, updateUrl: true, replace: false}) {
    this.token = token;
    if (updateUrl) {
      // walk up the tree and count view stack depth.
      var stackDepth = 0;
      var stack = [];
      visitParents(this, (p) {
        if (p.xtag != null) {
          if (p.xtag is ViewComponent) {
            stackDepth++;
            stack.insert(0, p.xtag.token);
          }
          if (p.xtag is RootViewComponent) {
            stackDepth++;
            stack.insert(0, p.xtag.currentViewId);
          }
        }
        return true;
      }, includeSelf: true);
      stack[stackDepth - 1] = token;
      var newUrl = '#/' + stack.sublist(0, stackDepth).join('/');
      if (replace) {
        window.history.replaceState(null, newUrl, newUrl); 
      } else {
        window.history.pushState(null, newUrl, newUrl); 
      }
    }
    if (silent) {
      return;
    }
    propagateTokens([token]);
  }
  
  // TODO(pavelgj): replace this with a stream.
  void onTokenChange(callback) {
    tokenChangeCallbacks.add(callback);
  }
  
  createAndInsertComponent(WebComponent comp, WebComponent target) {
    comp.host = new DivElement();
    var lifecycleCaller = new ComponentItem(comp)
        ..create();
    target.host.children.add(comp.host);
    lifecycleCaller.insert();
    return comp;
  }
}