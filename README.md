# Angular2 Pagination for Dart
This is a Dart port of [ng2-pagination](https://github.com/michaelbromley/ng2-pagination/), an excellent Angular2 Typescript library by Michael Bromley. 

Check out his demo here: http://michaelbromley.github.io/ng2-pagination/


## Installation

```
npm install ng2-dart-pagination --save
```

Works with latest versions of Dart (1.14) and Angular2 (2.0.0-beta.2)

## Code example

```Dart
import 'dart:async';
import 'package:angular2/angular2.dart';
import 'package:ng2-dart-pagination/src/ng2-pagination.dart';

@Component(
    selector: 'my-component',
    template: '''
    <ul>
      <li *ngFor="#item of collection | paginate: [ITEMS_PER_PAGE or CONFIG_OBJECT] "> ... </li>
    <ul>
               
    <pagination-controls></pagination-controls>
    ''',
    directives: const [CORE_DIRECTIVES, PaginationControlsCmp],
    pipes: const [PaginatePipe],
    providers: const [PaginationService, DataService]
)

class MyComponent implements OnInit {

    List<dynamic> collection = [];
    DataService dataService;

    MyComponent(this.dataService);

    ngOnInit() {
      getList();
    }
    
    Future getList() async {
      collection = await dataService.getList();
    }

}
```

## API

### PaginatePipe

The PaginatePipe should be placed at the end of an NgFor expression. It accepts a single argument, which should be 
either a `number` or an object confirming to `IPaginationInstance`. If the argument is a number, the number sets the
value of `itemsPerPage`. 

Using an object allows some more advanced configuration. The following config options are available:

```Dart
class IPaginationInstance {
    /**
     * The number of items per paginated page.
     */
    num itemsPerPage;
    
    /**
     * The current (active) page.
     */
    num currentPage;
    
    /**
     * (Optional) An ID for the pagination instance. Only useful if you wish to
     * have more than once instance at a time in a given component.
     */
    String id;
    
    /**
     * (Optional) The total number of items in the collection. Only useful when
     * doing server-side paging, where the collection size is limited
     * to a single page returned by the server API.
     *
     * For in-memory paging, this property should not be set, as it
     * will be automatically set to the value of  collection.length.
     */
     
    num totalItems;

    IPaginationInstance(this.itemsPerPage, this.currentPage, {this.id, this.totalItems});
}

//Instance example
IPaginationInstance config = new IPaginationInstance(10, 1, id: 'advanced', totalItems: 10);

```


### PaginationControlsCmp

```HTML
<pagination-controls  id="some_id"
                      (pageChange)="pageChanged($event)"
                      maxSize="9"
                      directionLinks="true"
                      autoHide="true">
</pagination-controls>
```

* **`id`** [string] If you need to support more than one instance of pagination at a time, set the `id` and ensure it
matches the id set in the PaginatePipe config.
* **`change`** [function] The function specified will be invoked whenever the page changes via a click on one of the
pagination controls. The `$event` argument will be the number of the new page.
* **`maxSize`** [number] Defines the maximum number of page links to display. Default is `7`.
* **`directionLinks`** [boolean] If set to `false`, the "previous" and "next" links will not be displayed. Default is `true`.
* **`autoHide`** [boolean] If set to `true`, the pagination controls will not be displayed when all items in the
collection fit onto the first page. Default is `false`.

## License

MIT



