import 'package:angular2/angular2.dart';
import 'package:angular2/bootstrap.dart';
import 'package:angular2/router.dart';
import 'package:ng2_dart_pagination/app.dart';

void main() {
  var app = DemoApp;
  var bindings = [injectables,
  bind(APP_BASE_HREF).toValue('/'),
  bind(LocationStrategy).toClass(HashLocationStrategy)];

  bootstrap(app, bindings);
}