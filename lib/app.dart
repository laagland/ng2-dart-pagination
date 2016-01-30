library ng2_pagination_demo;

import 'dart:html';
import 'dart:mirrors';
import 'dart:math';

//angular2
import 'package:angular2/angular2.dart';

//src
import 'src/ng2-pagination.dart';

//components
part 'demo/demo-app.dart';
part 'demo/basic-example-cmp.dart';
part 'demo/advanced-example-cmp.dart';

//pipes
part 'demo/string-filter-pipe.dart';

//injectables
const List<Type> injectables = const [PaginationService];
