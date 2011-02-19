//
//  PreferenceController.h
//  RaiseMan
//
//  Created by Charles Feduke on 2/17/11.
//  Copyright 2011 Mobile Posse. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NSString* const BNRTableBgColorKey;
NSString* const BNREmptyDocKey;
NSString* const BNRColorChangedNotification;

@interface PreferenceController : NSWindowController {
	IBOutlet NSColorWell *colorWell;
	IBOutlet NSButton *checkbox;
}
-(IBAction)changeBackgroundColor:(id)sender;
-(IBAction)changeNewEmptyDoc:(id)sender;
-(NSColor*)tableBgColor;
-(BOOL)emptyDoc;
-(IBAction)reset:(id)sender;
+(void)initializeDefaults;
-(void)synchronizeSettings;
@end
