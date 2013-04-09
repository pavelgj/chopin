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
    if (viewId == 'a') {
      return new AComponent();
    }
    if (viewId == 'b') {
      return new BComponent();
    }
    if (viewId == 'c') {
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
  <x-view view-id="b" my-attribute="{{myValue}}" history-bound="{{true}}"></x-view>
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
For example, a url like this /a/1234/4321 will tell the root view to load view id 'a' 
and assign history token 1234 to it. If view 'a' contains a sub-view (lets say 'b'), then
token 4321 will be passed to 'b'. And so on.

If view 'b' would call setToken('5432') then the URL will automatically update to
/a/1234/5432.
