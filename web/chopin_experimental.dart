import 'dart:html';
import 'package:web_ui/web_ui.dart';
import 'chopin.dart';
import 'portfolio.dart';
import 'company-info.dart';
import 'company-info-loader.dart';
import 'simple-company-info.dart';

// initial value for click-counter
int startingCount = 5;

/**
 * Learn about the Web UI package by visiting
 * http://www.dartlang.org/articles/dart-web-components/.
 */
void main() {
  // Enable this to use Shadow DOM in the browser.
  //useShadowDom = true;
}

class SampleConfig extends Config {
  ViewResolver viewResolver = (String viewId, WebComponent target) {
    print('resolving $viewId');
    if (viewId == 'portfolio') {
      return new PortfolioComponent();
    }
    if (viewId == 'companyInfo') {
      if (target.parentView != null && target.parent is TableCellElement) {
        print('Resolve simple');
        return new SimpleCompanyInfoComponent();
      }
      if (target.parentView == null) {
        print('Resolve loader');
        return new CompanyInfoLoaderComponent();
      }
      print('Resolve full');
      return new CompanyInfoComponent();
    }
    throw new StateError('unable to resolve $viewId');
  };
}

var config = new SampleConfig();