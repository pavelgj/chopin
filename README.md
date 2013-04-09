# Chopin framework (EXPERIMENTAL)
> [Chopin](http://en.wikipedia.org/wiki/Fr%C3%A9d%C3%A9ric_Chopin) is pronounced "show-pan".

Chopin is an experimental simple routing, hierarchical deep-linking and view composition framework.

The idea is that the UI is composed of "views". Each view has a view id and 
view ids are dynamically resolved to web components by view resolver defined
in the configuration. View can be nested are nested, allowing composition.

At the root of all views (the entry point into the view hierarchy) there is 
a root-view which contains the configuration and also resolves the first view.

Sample config:
```dart
import 'package:chopin/chopin.dart' as chopin;

class SampleConfig extends chopin.Config {
  WebComponent viewResolver(String viewId, WebComponent target) {
    if (viewId == 'aaa') {
      return new AComponent();
    }
    if (viewId == 'bbb') {
      return new BComponent();
    }
    if (viewId == 'ccc') {
      return new CComponent();
    }
    throw new StateError('unable to resolve $viewId');
  }
}
```

You can imagine that view id resolution can be muck more sophisticated, for
example, taking into account the logged in user's permissions or preferences.

You can embed other views like so

```html
  <head>
    <link rel="components" href="package:chopin/view.html">
  </head>
  ...
  <x-view view-id="bbb" my-attribute="{{myValue}}" history-bound="{{true}}"></x-view>
  ...
```

You can set custom attributes on the views and resolved web components can access those attributes like so:

```dart
  // TODO: come up with a nicer API for this.
  chopin.viewAttributes(this)['myAttribute']
```

Each view that's marked as history-bound is also attached to the url.

```dart
  chopin.onTokenChange(this, (newToken) {
    // do something with new token
  });
  
  // set new token for this view
  chopin.setToken(this, 'newToken');
```
For example, a url like this /aaa/foo/bar will tell the root view to load view id 'aaa' 
and assign history token 'foo' to it. If view 'aaa' contains a sub-view (lets say 'bbb'), then
token bar will be passed to 'bbb'. And so on.

If view 'bbb' calls setToken('baz') then the URL will automatically update to
/a/foo/baz. If view 'aaa' setToken('auz') then the URL will automatically update
to '/a/aux'. Setting history token in the middle of the view stack strips the tail.
