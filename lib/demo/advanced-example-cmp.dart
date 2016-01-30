part of ng2_pagination_demo;

@Component(
    selector: 'advanced-example',
    templateUrl: 'package:ng2_dart_pagination/demo/advanced-example-cmp.html',
    directives: const [CORE_DIRECTIVES, FORM_DIRECTIVES, PaginationControlsCmp],
    pipes: const [PaginatePipe, StringFilterPipe]
)

class AdvancedExampleCmp {

    @Input('data') List<String> meals = [];

    String filter = '';
    num maxSize = 7;
    bool directionLinks = true;
    bool autoHide = false;

    IPaginationInstance config = new IPaginationInstance(10, 1, id: 'advanced');
}