//
//  Person.h
//  RaiseMan
//
//  Created by Charles Feduke on 2/13/11.
//  Copyright 2011 Mobile Posse. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Person : NSObject <NSCoding> {
	NSString *personName;
	float expectedRaise;
}

@property (readwrite, copy) NSString *personName;
@property (readwrite) float expectedRaise;

-(void)removeRaise;
@end
