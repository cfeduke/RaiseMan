//
//  PreferenceController.m
//  RaiseMan
//
//  Created by Charles Feduke on 2/17/11.
//  Copyright 2011 Mobile Posse. All rights reserved.
//

#import "PreferenceController.h"

NSString* const BNRTableBgColorKey = @"TableBackgroundColor";
NSString* const BNREmptyDocKey = @"EmptyDocumentFlag";
NSString* const BNRColorChangedNotification = @"BNRColorChanged";

@implementation PreferenceController
-(id)init {
	if (![super initWithWindowNibName:@"Preferences"])
		return nil;
	return self;
}
-(NSColor*)tableBgColor {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSData* colorAsData = [defaults objectForKey:BNRTableBgColorKey];
	return [NSKeyedUnarchiver unarchiveObjectWithData:colorAsData];
}
-(BOOL)emptyDoc {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	return [defaults boolForKey:BNREmptyDocKey];
}
-(void)windowDidLoad {
	[self synchronizeSettings];
}
-(void)synchronizeSettings {
	[colorWell setColor:[self tableBgColor]];
	[checkbox setState:[self emptyDoc]];
}
-(IBAction)changeBackgroundColor:(id)sender {
	NSColor* color = [colorWell color];
	NSLog(@"color changed: %@", color);
	NSData* colorAsData = [NSKeyedArchiver archivedDataWithRootObject:color];
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:colorAsData forKey:BNRTableBgColorKey];
	
	NSDictionary* d = [NSDictionary dictionaryWithObject:color forKey:@"color"];
	
	NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
	[nc postNotificationName:BNRColorChangedNotification object:self userInfo:d];
}
-(IBAction)changeNewEmptyDoc:(id)sender {
	int state = [checkbox state];
	NSLog(@"Checkbox changed %d", state);
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:state forKey:BNREmptyDocKey];
}
-(IBAction)reset:(id)sender {
	NSLog(@"Resetting defaults");
	
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	[defaults removeObjectForKey:BNREmptyDocKey];
	[defaults removeObjectForKey:BNRTableBgColorKey];
	
	[self synchronizeSettings];
}
+(void)initializeDefaults {
	NSMutableDictionary* defaultValues = [NSMutableDictionary dictionary];
	
	NSData *colorAsData = [NSKeyedArchiver archivedDataWithRootObject:[NSColor yellowColor]];
	
	[defaultValues setObject:colorAsData forKey:BNRTableBgColorKey];
	[defaultValues setObject:[NSNumber numberWithBool:YES]
					  forKey:BNREmptyDocKey];
	
	[[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
	NSLog(@"registered defaults: %@", defaultValues);
}
@end
