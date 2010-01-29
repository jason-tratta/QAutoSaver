//
//  AppController.h
//  QAutoSaver
//
//  Created by Jason Tratta 2/4/09.
//  Copyright 2009 Sound Character. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>
#import "QlabScripting.h"
#import <SDGlobalShortcuts/SDGlobalShortcuts.h>
#import <ShortcutRecorder/ShortcutRecorder.h>
#import "AboutWindow.h"

NSString * const JATHoursFieldKey;
NSString * const JATMinutesFieldKey;

@interface AppController : NSObject {
	
	
	IBOutlet SRRecorderControl *recorderControl;

	AboutWindow *aboutWindow;
	
	NSTimer *timer;
	int count;
	int progressBarMax;
	BOOL startTimer; 
	BOOL firstPass;
	BOOL active; 
	NSString *file; 
	NSString *toParent;
	IBOutlet NSTextField *feedBackBox;
	IBOutlet NSTextField *fieldHours; 
	IBOutlet NSTextField *fieldMinutes;
	QlabScripting *qlabScripts; 
	PreferenceController *myPrefs; 
	

}


-(IBAction) saveButton: (id) sender;
-(IBAction)startTimer: (id) sender;
-(IBAction)stopTimer:(id) sender;
-(void) theTimer;
-(void)setCount;
-(IBAction)openAboutWindow: (id) sender;
-(IBAction)hotKey: (id) sender; 
-(int)getMinutes; 
-(int)getHours; 
-(void) setMinutesField;
-(void) setHoursField; 
-(IBAction) testButton: (id) sender;



@end
