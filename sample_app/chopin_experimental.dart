import 'dart:html';
import 'package:web_ui/web_ui.dart';
import 'package:chopin/chopin.dart' as chopin;
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

class SampleConfig extends chopin.Config {
  chopin.ViewResolver viewResolver = (String viewId, WebComponent target) {
    if (viewId == 'portfolio') {
      return new PortfolioComponent();
    }
    if (viewId == 'companyInfo') {
      if (target.parentView != null && target.parent is TableCellElement) {
        return new SimpleCompanyInfoComponent();
      }
      if (target.parentView == null) {
        return new CompanyInfoLoaderComponent();
      }
      return new CompanyInfoComponent();
    }
    throw new StateError('unable to resolve $viewId');
  };
}

var config = new SampleConfig();