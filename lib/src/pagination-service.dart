part of ng2_pagination;

//TODO: Abstract class -> implements?
class IPaginationInstance {
    /**
     * An optional ID for the pagination instance. Only useful if you wish to
     * have more than once instance at a time in a given component.
     */
    String id;
    /**
     * The number of items per paginated page.
     */
    num itemsPerPage;
    /**
     * The current (active) page.
     */
    num currentPage;
    /**
     * The total number of items in the collection. Only useful when
     * doing server-side paging, where the collection size is limited
     * to a single page returned by the server API.
     *
     * For in-memory paging, this property should not be set, as it
     * will be automatically set to the value of  collection.length.
     */
    num totalItems;

    IPaginationInstance(this.itemsPerPage, this.currentPage, {this.id, this.totalItems});

    IPaginationInstance.clone(IPaginationInstance object){
        this.itemsPerPage = object.itemsPerPage;
        this.currentPage = object.currentPage;
        this.id = object.id;
        this.totalItems = object.totalItems;
    }

}

@Injectable()
class PaginationService {

    EventEmitter<String> change = new EventEmitter();

    Map<String, IPaginationInstance> instances = {};
    static const DEFAULT_ID = 'DEFAULT_PAGINATION_ID';

    get defaultId => PaginationService.DEFAULT_ID;

    // static template config
    static String templateUrl;
    static String template;

    void register(IPaginationInstance instance) {
        if (instance.id == null) {
            instance.id = PaginationService.DEFAULT_ID;
        }

        if (this.instances[instance.id] == null) {
            this.instances[instance.id] = instance;
            this.change.emit(instance.id);
        } else {
            var changed = this.updateInstance(instance);
            if (changed) {
                this.change.emit(instance.id);
            }
        }
    }

    /**
     * Check each property of the instance and update any that have changed. Return
     * true if any changes were made, else return false.
     */
    bool updateInstance(IPaginationInstance instance) {
        bool changed = false;
        ClassMirror cm = reflectClass(IPaginationInstance);
        InstanceMirror im = reflect(instance);
        InstanceMirror rim = reflect(this.instances[instance.id]);
        for (var k in cm.declarations.values.where((d) => d is VariableMirror)) {
                String fieldName = MirrorSystem.getName(k.simpleName);
                if (rim.getField(new Symbol(fieldName)).reflectee != im.getField(new Symbol(fieldName)).reflectee){
                    rim.setField(new Symbol(fieldName), im.getField(new Symbol(fieldName)).reflectee);
                    changed = true;
                }
        }
        return changed;
    }

    /**
     * Returns the current page number.
     */
    num getCurrentPage(String id) {
        if (this.instances[id] != null) {
            return this.instances[id].currentPage;
        }

//        return 1;
    }

    /**
     * Sets the current page number.
     */
    void setCurrentPage(String id, num page) {
        if (this.instances[id] != null) {
            IPaginationInstance instance = this.instances[id];
            var maxPage = (instance.totalItems / instance.itemsPerPage).ceil();
            if (page <= maxPage && 1 <= page) {
                this.instances[id].currentPage = page;
                this.change.emit(id);
            }
        }
    }

    /**
     * Sets the value of instance.totalItems
     */
    void setTotalItems(String id, num totalItems) {
        if (this.instances[id] != null && 0 <= totalItems) {
            this.instances[id].totalItems = totalItems;
            this.change.emit(id);
        }
    }

    /**
     * Sets the value of instance.itemsPerPage.
     */
    void setItemsPerPage(String id, num itemsPerPage) {
        if (this.instances[id] != null) {
            this.instances[id].itemsPerPage = itemsPerPage;
            this.change.emit(id);
        }
    }

    /**
     * Returns a clone of the pagination instance object matching the id. If no
     * id specified, returns the instance corresponding to the default id.
     */
    IPaginationInstance getInstance({String id: PaginationService.DEFAULT_ID}) {
        if (this.instances[id] != null) {
            return this.clone(this.instances[id]);
        }
    }

    /**
     * Perform a shallow clone of an object.
     */
    IPaginationInstance clone(IPaginationInstance obj) {
        IPaginationInstance clone = new IPaginationInstance.clone(obj);
        return clone;
    }

}