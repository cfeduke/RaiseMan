//
//  PeopleView.m
//  RaiseMan
//
//  Created by Charles Feduke on 2/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PeopleView.h"
#import "Person.h"


@implementation PeopleView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

-(id)initWithPeople:(NSArray *)persons {
	[super initWithFrame:NSMakeRect(0, 0, 700, 700)];
	people = [persons copy];
	attributes = [[NSMutableDictionary alloc] init];
	NSFont *font = [NSFont fontWithName:@"Monaco" size:12.0];
	lineHeight = [font capHeight] * 1.7;
	[attributes setObject:font forKey:NSFontAttributeName];
	
	return self;
}

-(void)dealloc {
	[people release];
	[attributes release];
	[super dealloc];
}

#pragma mark Pagination

-(BOOL)knowsPageRange:(NSRangePointer)range
{
	NSPrintOperation *po = [NSPrintOperation currentOperation];
	NSPrintInfo *printInfo = [po printInfo];
	pageRect = [printInfo imageablePageBounds];
	NSRect newFrame;
	newFrame.origin = NSZeroPoint;
	newFrame.size = [printInfo paperSize];
	
	linesPerPage = pageRect.size.height / lineHeight;
	
	range->location = 1;
	
	range->length = [people count] / linesPerPage;
	if ([people count] % linesPerPage) {
		range->length = range->length+1;
	}
	
	return YES;
}

-(NSRect)rectForPage:(NSInteger)i {
	currentPage = i - 1;
	return pageRect;
}

#pragma mark Drawing

-(BOOL)isFlipped {
	return YES;
}

-(void)drawRect:(NSRect)r {
	NSRect nameRect;
	NSRect raiseRect;
	raiseRect.size.height = nameRect.size.height = lineHeight;
	nameRect.origin.x = pageRect.origin.x;
	nameRect.size.width = 200.0;
	raiseRect.origin.x = NSMaxX(nameRect);
	raiseRect.size.width = 100;
	
	int i;
	for (i=0;i<linesPerPage;i++) {
		int index = (currentPage * linesPerPage) + i;
		if (index >= [people count]) {
			break;
		}
		Person *p = [people objectAtIndex:index];
		
		nameRect.origin.y = pageRect.origin.y + (i * lineHeight);
		NSString *nameString = [NSString stringWithFormat:@"%2d %@", index, [p personName]];
		[nameString drawInRect:nameRect withAttributes:attributes];
		
		raiseRect.origin.y = nameRect.origin.y;
		NSString *raiseString = [NSString stringWithFormat:@"%4.1f%%", [p expectedRaise]];
		
		[raiseString drawInRect:raiseRect withAttributes:attributes];
	}
}

@end
