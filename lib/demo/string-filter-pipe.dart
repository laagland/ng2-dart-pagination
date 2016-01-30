part of ng2_pagination_demo;

/**
 * A simple string filter, since ng2 does not yet have a filter pipe built in.
 */
@Pipe(
    name: 'stringFilter'
)

class StringFilterPipe {

    List<String> transform(List<String> value, List<String> args) {
        var q = args[0];
        if (q == null || q.isEmpty) {
            return value;
        }
        return value.where((String item) => item.toLowerCase().contains(q.toLowerCase())).toList();
    }
}
