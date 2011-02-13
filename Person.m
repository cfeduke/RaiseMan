//
//  Person.m
//  RaiseMan
//
//  Created by Charles Feduke on 2/13/11.
//  Copyright 2011 Mobile Posse. All rights reserved.
//

#import "Person.h"


@implementation Person

- (id)init {
	[super init];
	expectedRaise = 5.0;
	personName = @"New Person";
	return self;
}

- (void)dealloc {
	[personName release];
	[super dealloc];
}
	
@synthesize personName;
@synthesize expectedRaise;

@end
