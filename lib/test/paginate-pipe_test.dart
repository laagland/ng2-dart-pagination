import 'package:guinness/guinness.dart';
import 'package:unittest/unittest.dart' hide expect;
import 'package:ng2_dart_pagination/src/ng2-pagination.dart';

main(){
    describe("paginate pipe", () {
        PaginatePipe pipe;
        PaginationService paginationService;
        List<String> collection;

        beforeEach(() {
            paginationService = new PaginationService();
            pipe = new PaginatePipe(paginationService);

            collection = [];
            for (var i = 0; i < 100; i++) {
                collection.add('item ${i}');
            }
        });

        describe('simple number argument', () {

            it('should truncate collection', () {
                List<String> result = pipe.transform(collection, ['10']);

                expect(result.length).toBe(10);
                expect(result[0]).toEqual('item 0');
                expect(result[9]).toEqual('item 9');
            });

            it('should register with the PaginationService', () {
                pipe.transform(collection, ['10']);
                IPaginationInstance instance = paginationService.getInstance();
                expect(instance).toBeDefined();
                expect(instance.itemsPerPage).toBe(10);
                expect(instance.totalItems).toBe(100);
            });

            it('should modify the same instance when called multiple times', () {
                IPaginationInstance instance;

                pipe.transform(collection, ['10']);
                instance = paginationService.getInstance();
                expect(instance.itemsPerPage).toBe(10);

                pipe.transform(collection, ['50']);
                instance = paginationService.getInstance();
                expect(instance.itemsPerPage).toBe(50);
            });

        });

        describe('config object argument', () {

            it('should use default id if none specified', () {
                IPaginationInstance config = new IPaginationInstance(10, 1);

                expect(paginationService.getInstance()).not.toBeDefined();
                pipe.transform(collection, [config]);
                expect(paginationService.getInstance()).toBeDefined();
            });

            it('should allow independent instances by setting an id', () {
                IPaginationInstance config1 = new IPaginationInstance(10, 1, id: 'first_one');
                IPaginationInstance config2 = new IPaginationInstance(50, 2, id: 'other_one');

                List<String> result1 = pipe.transform(collection, [config1]);
                List<String> result2 = pipe.transform(collection, [config2]);

                expect(result1.length).toBe(10);
                expect(result1[0]).toEqual('item 0');
                expect(result1[9]).toEqual('item 9');

                expect(result2.length).toBe(50);
                expect(result2[0]).toEqual('item 50');
                expect(result2[49]).toEqual('item 99');
            });

            describe('server-side pagination', () {
                IPaginationInstance config;

                beforeEach(() {
                    config = new IPaginationInstance(10, 1, totalItems: 500);
                    collection = collection.sublist(0, 10);
                });

                it('should truncate collection', () {
                    List<String> result = pipe.transform(collection, [config]);

                    expect(result.length).toBe(10);
                    expect(result[0]).toEqual('item 0');
                    expect(result[9]).toEqual('item 9');
                });
            });

            it('should return identical array for the same input values', () {
                IPaginationInstance config = new IPaginationInstance(10, 1, id: 'first_one');

                List<String> result1 = pipe.transform(collection, [config]);
                List<String> result2 = pipe.transform(collection, [config]);

                expect(result1 == result2).toBe(true);
            });

        });

        describe('unexpected input', () {

            it('should throw exception on non-array inputs', () {
                var input;

                input = '';
                expect(() => pipe.transform(input, ['10'])).toThrow();

                input = 1;
                expect(() => pipe.transform(input, ['10'])).toThrow();

                input = {};
                expect(() => pipe.transform(input, ['10'])).toThrow();

                input = null;
                expect(() => pipe.transform(input, ['10'])).toThrow();
            });
        });
    });
}
