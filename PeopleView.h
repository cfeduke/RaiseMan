//
//  PeopleView.h
//  RaiseMan
//
//  Created by Charles Feduke on 2/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PeopleView : NSView {
	NSArray *people;
	NSMutableDictionary *attributes;
	float lineHeight;
	NSRect pageRect;
	int linesPerPage;
	int currentPage;
}

-(id)initWithPeople:(NSArray *)array;

@end
