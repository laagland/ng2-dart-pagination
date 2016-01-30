part of ng2_pagination_demo;

@Component(
    selector: 'basic-example',
    templateUrl: 'package:ng2_dart_pagination/demo/basic-example-cmp.html',
    directives: const [CORE_DIRECTIVES, PaginationControlsCmp],
    pipes: const [PaginatePipe]
)

class BasicExampleCmp {

    @Input('data') List<String> meals = [];

}