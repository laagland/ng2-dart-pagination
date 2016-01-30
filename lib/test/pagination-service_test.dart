import 'package:guinness/guinness.dart';
import 'package:unittest/unittest.dart' hide expect;
import 'package:ng2_dart_pagination/src/ng2-pagination.dart';
import 'dart:convert';

main(){
    describe("pagination service", () {
        PaginationService service;
        IPaginationInstance instance;
        const String ID = 'test';

        beforeEach(() {
            service = new PaginationService();
            instance = new IPaginationInstance(10, 1 , id: ID, totalItems: 100);
        });

        it('should register the instance', () {
            service.register(instance);
            IPaginationInstance registered = service.getInstance(id: ID);
            expect(registered).toEqual(instance);
        });

        it('getInstance() should return a clone of the instance', () {
            service.register(instance);
            expect(service.getInstance(id: ID)).not.toBe(instance);
        });

        it('setCurrentPage() should work for valid page number', () {
            service.register(instance);
            service.setCurrentPage(ID, 3);
            expect(service.getCurrentPage(ID)).toBe(3);
        });

        it('setCurrentPage() should work for max page number', () {
            service.register(instance);
            service.setCurrentPage(ID, 10);
            expect(service.getCurrentPage(ID)).toBe(10);
        });

        it('setCurrentPage() should not change page if new page is too high', () {
            service.register(instance);
            service.setCurrentPage(ID, 11);
            expect(service.getCurrentPage(ID)).toBe(1);
        });

        it('setCurrentPage() should not change page if new page is less than 1', () {
            service.register(instance);
            service.setCurrentPage(ID, 0);
            expect(service.getCurrentPage(ID)).toBe(1);
        });

        it('setTotalItems() should work for valid input', () {
            service.register(instance);
            service.setTotalItems(ID, 500);
            expect(service.getInstance(id: ID).totalItems).toBe(500);
        });

        it('setTotalItems() should not work for negative values', () {
            service.register(instance);
            service.setTotalItems(ID, -10);
            expect(service.getInstance(id: ID).totalItems).toBe(100);
        });


    });
}