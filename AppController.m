//
//  AppController.m
//  RaiseMan
//
//  Created by Charles Feduke on 2/17/11.
//  Copyright 2011 Mobile Posse. All rights reserved.
//

#import "AppController.h"
#import "PreferenceController.h"


@implementation AppController

- (IBAction)showPreferencePanel:(id)sender {
	if (!preferenceController) {
		preferenceController = [[PreferenceController alloc] init];
	}
	
	NSLog(@"showing %@", preferenceController);
	[preferenceController showWindow:self];
}

-(IBAction)showAboutPanel:(id)sender {
	NSWindowController* awc = [[NSWindowController alloc] initWithWindowNibName:@"About" owner:self];
	[[awc window] makeKeyAndOrderFront:nil];
	//[[NSApplication shareApplication] arrangeInFront:nil];	
}

+(void)initialize {
	[PreferenceController initializeDefaults];
}

-(BOOL)applicationShouldOpenUntitledFile:(NSApplication*)sender {
	NSLog(@"applicationShouldOpenUntitledFile:");
	return [[NSUserDefaults standardUserDefaults] boolForKey:BNREmptyDocKey];
}

-(void)applicationDidResignActive:(NSNotification*) note {
	NSLog(@"BEEP BEEP!");
	NSBeep();
}

@end