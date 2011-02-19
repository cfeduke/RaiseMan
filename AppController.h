//
//  AppController.h
//  RaiseMan
//
//  Created by Charles Feduke on 2/17/11.
//  Copyright 2011 Mobile Posse. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PreferenceController;

@interface AppController : NSObject {
	PreferenceController *preferenceController;
}

- (IBAction)showPreferencePanel:(id)sender;
-(IBAction)showAboutPanel:(id)sender;

@end
