//
//  MyDocument.h
//  RaiseMan
//
//  Created by Charles Feduke on 2/13/11.
//  Copyright 2011 Mobile Posse. All rights reserved.
//


#import <Cocoa/Cocoa.h>

@interface MyDocument : NSDocument {
	NSMutableArray *employees;
}
-(void)setEmployees:(NSMutableArray *)a;
@end
