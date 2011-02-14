//
//  MyDocument.h
//  RaiseMan
//
//  Created by Charles Feduke on 2/13/11.
//  Copyright 2011 Mobile Posse. All rights reserved.
//


#import <Cocoa/Cocoa.h>
@class Person;

@interface MyDocument : NSDocument {
	NSMutableArray *employees;
}
-(void)setEmployees:(NSMutableArray *)a;
-(void)removeObjectFromEmployeesAtIndex:(int)index;
-(void)insertObject:(Person *)p inEmployeesAtIndex:(int)index;
-(void)startObservingPerson:(Person *)person;
-(void)stopObservingPerson:(Person *)person;
@end
