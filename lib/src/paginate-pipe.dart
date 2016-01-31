part of ng2_pagination;

const num LARGE_NUMBER = 999999999;

//TODO: Abstract class -> implements?
class IPipeState {
    List<dynamic> collection;
    num start;
    num end;
    List<dynamic> slice;

    IPipeState(this.collection, this.start, this.end, this.slice);
}

@Pipe(
    name: 'paginate',
    pure: false
)

@Injectable()
class PaginatePipe {

    // store the values from the last time the pipe
    Map<String, IPipeState> state = {};
    PaginationService service;

    PaginatePipe(this.service);

    List<String> transform(List<String> collection, [List<dynamic> args = null]) {

        // for non-array types, throw an exception
        if (!(collection is List)) {
            throw('PaginationPipe: Argument error - expected an array.');
        }

        bool usingConfig = args[0] is IPaginationInstance;
        bool serverSideMode = usingConfig && args[0].totalItems != null;
        IPaginationInstance instance = this.createInstance(collection, args);
        String id = instance.id;
        num start, end;

        this.service.register(instance);

        if (!usingConfig && instance.totalItems != collection.length) {
            this.service.setTotalItems(id, collection.length);
        }
        num itemsPerPage = instance.itemsPerPage;
        if (!serverSideMode && collection is List) {
            itemsPerPage = itemsPerPage ?? LARGE_NUMBER;
            start = (this.service.getCurrentPage(id) - 1) * itemsPerPage;
            if (instance.totalItems < ((this.service.getCurrentPage(id) * itemsPerPage) - 1)){
                end = instance.totalItems;
            } else {
                end = start + itemsPerPage;
            }

            bool isIdentical = this.stateIsIdentical(id, collection, start, end);
            if (isIdentical) {
                return this.state[id].slice;
            } else {
                List<dynamic> slice = collection.sublist(start.toInt(), end.toInt());
                this.saveState(id, collection, slice, start, end);
                return slice;
            }
        }
        return collection;
    }

    IPaginationInstance createInstance(List<dynamic> collection, dynamic args)  {
        IPaginationInstance instance;
        if (args[0] is String || args[0] is num) {
            String id = this.service.defaultId;
            instance = new IPaginationInstance(
                (args[0] is String) ? int.parse(args[0]) : args[0],
                this.service.getCurrentPage(id) ?? 1,
                id: id,
                totalItems: collection.length
            );
        } else if (args[0] is IPaginationInstance) {
            instance = new IPaginationInstance(
                args[0].itemsPerPage ?? 0,
                args[0].currentPage ?? 1,
                id: args[0].id ?? this.service.defaultId,
                totalItems: args[0].totalItems ?? collection.length
            );
        } else {
            throw('PaginatePipe: Argument must be a string, number or an object.');
        }
        return instance;
    }

    /**
     * To avoid returning a brand new array each time the pipe is run, we store the state of the sliced
     * array for a given id. This means that the next time the pipe is run on this collection & id, we just
     * need to check that the collection, start and end points are all identical, and if so, return the
     * last sliced array.
     */
    void saveState(String id, List<dynamic> collection, List<dynamic> slice, num start, num end) {
        this.state[id] = new IPipeState(collection, start, end, slice);
    }

    /**
     * For a given id, returns true if the collection, start and end values are identical.
     */
    bool stateIsIdentical(String id, List<dynamic> collection, num start, num end) {
        if (this.state == null || this.state[id] == null) {
            return false;
        }
        IPipeState state = this.state[id];
        return state.collection == collection && state.start == start && state.end == end;
    }
}