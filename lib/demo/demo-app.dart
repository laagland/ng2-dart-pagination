part of ng2_pagination_demo;

@Component(
    selector: 'demo-app',
    templateUrl: 'package:ng2_dart_pagination/demo/demo-app.html',
    directives: const [CORE_DIRECTIVES, BasicExampleCmp, AdvancedExampleCmp]
)

class DemoApp implements OnInit {

    List<String> meals = [];
    String basicCode = '';
    String advancedCode = '';
    String customTemplateCode = '';

    bool showBasic = false;
    bool showAdvanced = false;

    DemoApp();

    ngOnInit() {
        this.meals = this.generateMeals();
        //TODO: implement
            this.loadCodeSnippet('basicCode', 'packages/ng2_dart_pagination/demo/basic-example-cmp.html');
//            this.loadCodeSnippet('advancedCode', 'demo/advanced-example-cmp.html');
//            this.loadCodeSnippet('customTemplateCode', 'demo/custom-template-example-cmp.html');
    }


    /**
     * Load the example component HTML into a string and attach to the controller.
     */
    loadCodeSnippet(String name, String url) {
        HttpRequest.getString(url).then((String resp){
            InstanceMirror mirror = reflect(this);
            mirror.setField(new Symbol(name), resp);
        });
    }
//
    List<String> generateMeals() {
        List<String> meals = [];
        List<String> dishes = [
            'noodles',
            'sausage',
            'beans on toast',
            'cheeseburger',
            'battered mars bar',
            'crisp butty',
            'yorkshire pudding',
            'wiener schnitzel',
            'sauerkraut mit ei',
            'salad',
            'onion soup',
            'bak choi',
            'avacado maki'
        ];
        List<String> sides = [
            'with chips',
            'a la king',
            'drizzled with cheese sauce',
            'with a side salad',
            'on toast',
            'with ketchup',
            'on a bed of cabbage',
            'wrapped in streaky bacon',
            'on a stick with cheese',
            'in pitta bread'
        ];

        final _random = new Random();

        for (var i = 1; i <= 100; i++) {
            var dish = dishes[_random.nextInt(dishes.length)];
            var side = sides[_random.nextInt(sides.length)];
            meals.add('meal ${i}: ${dish} ${side}');
        }
        return meals;
    }
}

