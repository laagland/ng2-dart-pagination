part of ng2_pagination;

class IPage {
    String label;
    dynamic value;

    IPage(this.label, this.value);
}

//TODO: Dynamic template loading
//const String DEFAULT_TEMPLATE = '';
//
//String getTemplate() {
//    return PaginationService.template ?? DEFAULT_TEMPLATE;
//}

@Component(
    selector: 'pagination-controls',
    template: '''
    <ul class="pagination" role="navigation" aria-label="Pagination" *ngIf="displayDefaultTemplate()">

        <li class="pagination-previous" [class.disabled]="isFirstPage()" *ngIf="directionLinks">
            <a *ngIf="1 < getCurrent()" (click)="setCurrent(getCurrent() - 1)" aria-label="Next page">
                Previous <span class="show-for-sr">page</span>
            </a>
            <span *ngIf="isFirstPage()">Previous <span class="show-for-sr">page</span></span>
        </li>

        <li [class.current]="getCurrent() == page.value" *ngFor="#page of pages">
            <a (click)="setCurrent(page.value)" *ngIf="getCurrent() != page.value">
                <span class="show-for-sr">Page</span>
                <span>{{ page.label }}</span>
            </a>
            <div *ngIf="getCurrent() == page.value">
                <span class="show-for-sr">You're on page</span>
                <span>{{ page.label }}</span>
            </div>
        </li>

        <li class="pagination-next" [class.disabled]="isLastPage()" *ngIf="directionLinks">
            <a *ngIf="!isLastPage()" (click)="setCurrent(getCurrent() + 1)" aria-label="Next page">
                Next <span class="show-for-sr">page</span>
            </a>
            <span *ngIf="isLastPage()">Next <span class="show-for-sr">page</span></span>
        </li>

    </ul>
    ''',
    directives: const [CORE_DIRECTIVES]
)

class PaginationControlsCmp implements OnInit, OnDestroy, OnChanges, AfterContentInit {

    @Input() String id;
    @Input() num maxSize = 7;
    @Input() bool directionLinks = true;
    @Input() bool autoHide = false;

    @Output() EventEmitter<num> pageChange = new EventEmitter();

    @ContentChild(TemplateRef) dynamic customTemplate;

    StreamSubscription<String> changeSub;
    List<IPage> pages = [];

    PaginationService service;
    ViewContainerRef viewContainer;

    PaginationControlsCmp(this.service, this.viewContainer) {
        this.changeSub = this.service.change.listen((String id) {
            if(this.id == id) {
                this.updatePages();
            }
        });
    }

    void updatePages() {
        var inst = this.service.getInstance(id: this.id);
        this.pages = this.createPageList(inst.currentPage, inst.itemsPerPage, inst.totalItems, this.maxSize);
    }

    bool displayDefaultTemplate() {
        if (this.customTemplate != null) {
            return false;
        }
        return !this.autoHide ?? 1 < this.pages.length;
    }

    /**
     * Set up the subscription to the PaginationService.change observable.
     */
    ngOnInit() {
        if (this.id == null) {
            this.id = this.service.defaultId;
        }
    }

    void ngAfterContentInit () {
        if (this.customTemplate != null) {
            this.viewContainer.createEmbeddedView(this.customTemplate);
        }
    }

    void ngOnChanges(Map<String, SimpleChange> changes) {
        this.updatePages();
    }

    void ngOnDestroy() {
        this.changeSub.cancel();
    }

    /**
     * Set the current page number.
     */
    void setCurrent(num page) {
        this.service.setCurrentPage(this.id, page);
        this.pageChange.emit(this.service.getCurrentPage(this.id));
    }

    /**
     * Get the current page number.
     */
    num getCurrent() {
        return this.service.getCurrentPage(this.id);
    }

    bool isFirstPage() {
        return this.getCurrent() == 1;
    }

    bool isLastPage() {
        var inst = this.service.getInstance(id: this.id);
        return (inst.totalItems / inst.itemsPerPage).ceil() == inst.currentPage;
    }

    /**
     * Returns a List of IPage objects to use in the pagination controls.
     */
    List<IPage> createPageList(num currentPage, num itemsPerPage, num totalItems, dynamic paginationRange) {
        // paginationRange could be a string if passed from attribute, so cast to number.
        paginationRange = (paginationRange is String) ? int.parse(paginationRange) : paginationRange;
        if(paginationRange == null) paginationRange = 1;
        List<IPage> pages = [];
        num totalPages = (totalItems / itemsPerPage).ceil();
        num halfWay = (paginationRange / 2).ceil();

        bool isStart = currentPage <= halfWay;
        bool isEnd = totalPages - halfWay < currentPage;
        bool isMiddle = !isStart && !isEnd;

        bool ellipsesNeeded = paginationRange < totalPages;
        int i = 1;

        while (i <= totalPages && i <= paginationRange) {
            var label;
            var pageNumber = this.calculatePageNumber(i, currentPage, paginationRange, totalPages);
            bool openingEllipsesNeeded = (i == 2 && (isMiddle || isEnd));
            bool closingEllipsesNeeded = (i == paginationRange - 1 && (isMiddle || isStart));
            if (ellipsesNeeded && (openingEllipsesNeeded || closingEllipsesNeeded)) {
                label = '...';
            } else {
                label = pageNumber;
            }
            pages.add(new IPage(label, pageNumber));
            i++;
        }
        return pages;
    }

    /**
     * Given the position in the sequence of pagination links [i],
     * figure out what page number corresponds to that position.
     */
    num calculatePageNumber(num i, num currentPage, num paginationRange, num totalPages) {
        var halfWay = (paginationRange / 2).ceil();
        if (i == paginationRange) {
            return totalPages;
        } else if (i == 1) {
            return i;
        } else if (paginationRange < totalPages) {
            if (totalPages - halfWay < currentPage) {
                return totalPages - paginationRange + i;
            } else if (halfWay < currentPage) {
                return currentPage - halfWay + i;
            } else {
                return i;
            }
        } else {
            return i;
        }
    }
}
