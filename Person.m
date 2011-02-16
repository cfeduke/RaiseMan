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

- (void)setNilValueForKey:(NSString *)key {
	if ([key isEqual:@"expectedRaise"]) {
		[self setExpectedRaise:0.0];
	} else {
		[super setNilValueForKey:key];
	}
}

- (void)encodeWithCoder:(NSCoder *)coder {
	[coder encodeObject:personName forKey:@"personName"];
	[coder encodeFloat:expectedRaise forKey:@"expectedRaise"];
}

- (id)initWithCoder:(NSCoder *)coder {
	[super init];
	personName = [[coder decodeObjectForKey:@"personName"] retain];
	expectedRaise = [coder decodeFloatForKey:@"expectedRaise"];
	return self;
}
@end
