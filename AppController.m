//
//  AppController.m
//  QAutoSaver
//
//  Created by Jason Tratta 2/4/09.
//  Copyright 2009 Sound Character. All rights reserved.
//

#import "AppController.h"
#import	"Qlab.h"
#import "AboutWindow.h"

NSString * const JATHoursFieldKey = @"HoursField";
NSString * const JATMinutesFieldKey = @"MinutesField";

@implementation AppController


-(id)init
{
	[super init]; 
	qlabScripts = [[QlabScripting alloc] init]; 
	myPrefs = [[PreferenceController alloc] init];
	
	//Key Values for ProgressBar 
	[self willChangeValueForKey:@"count"];
	[self willChangeValueForKey:@"progressBarMax"];
	count = 0;
	progressBarMax = 100; 
	[self didChangeValueForKey:@"count"];
	[self didChangeValueForKey:@"progressBarMax"]; 
	
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter]; 
	[nc addObserver:self selector:@selector(handleFeedback:) name:(NSString *)JATFeedBackNotification object:nil];
	[nc addObserver:self selector:@selector(restoreDefaults:) name:(NSString *)JATRestoreDefaultsNotification object:nil];
	NSLog(@"Registered with notification center"); 
	
		
	return self;
}

-(void)awakeFromNib
{ 

	//Status Bar Land TO BE ADDED LATER
	//NSStatusBar *menuBar = [NSStatusBar systemStatusBar];
   // NSStatusItem *bpaMenuStatusItem = [[menuBar statusItemWithLength:NSVariableStatusItemLength] retain];
	
    //[bpaMenuStatusItem setTitle:NSLocalizedString(@"QAS",@"")];
   // [bpaMenuStatusItem setHighlightMode:YES];
	
	//Global HotKey Selector
	SDGlobalShortcutsController *shortcutsController = [SDGlobalShortcutsController sharedShortcutsController];
	[shortcutsController addShortcutFromDefaultsKey:@"JustSomeDefaultsKey"
										withControl:recorderControl
											 target:self
										   selector:@selector(hotKey:)];
	
	[self setMinutesField]; 
	[self setHoursField]; 

	
	
	
}
// Register the preferance defaults
+(void) initialize 
{ 
	//Create a dictionary 
	NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary]; 
	
	//Create the defaults 
	NSString *defaultHoursField = @"0"; 
	NSString *defaultMinutesField = @"30"; 
	
	//Put the defaults in the dictionary 
	[defaultValues setObject:defaultHoursField forKey:JATHoursFieldKey]; 
	[defaultValues setObject:defaultMinutesField forKey:JATMinutesFieldKey];
		
	//Register the Dictionary of defualts 
	[[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues]; 
	NSLog(@"registed defaults: %@", defaultValues);
	
	
	
}




#pragma mark Open Windows

-(IBAction)openAboutWindow: (id) sender
{ 
	
	
	//Is About window Nil?
	if (!aboutWindow) { 
		aboutWindow = [[AboutWindow alloc] init]; 
	} 
	NSLog(@"showing %@", aboutWindow); 
	[aboutWindow showWindow:self]; 
	
	
	
}





-(IBAction) saveButton:(id) sender
{ 
	active = [qlabScripts isQlabActive];
	if (active == TRUE) {
	
	[qlabScripts saveWorkspaceLogic]; }
	
	
}


#pragma mark Timer Functions 

// Use NSTimer to call the decrease count function  
-(void) theTimer
{
	
	if (startTimer == YES) {
	
	
	timer = [[NSTimer scheduledTimerWithTimeInterval:0.5
			target:self
			selector:@selector(decreaseCount:)
			userInfo:nil 
			repeats:YES] retain]; 
		
	} else {
		[timer invalidate]; 
		[timer release]; 
		timer = nil; 
	}

	
}

//Starts the timer 
-(IBAction)startTimer: (id) sender
{ 
	active = [qlabScripts isQlabActive];
	if (active == TRUE){
	
	[self stopTimer:(id) sender]; //Prevents the timer from creating multiple ticks
	startTimer = YES; 
	firstPass = YES;
	[self setCount]; 
	[self theTimer]; 
	[qlabScripts setFeedBackText:@"Timer Running"];
		[feedBackBox setStringValue:[qlabScripts feedBackText]];
		
	
	} else {
		[feedBackBox setStringValue:[qlabScripts feedBackText]];  } 

}

//Stop the timer and release NSTimer / Also make the progress bar look pretty
-(IBAction)stopTimer:(id) sender
{ 
	startTimer = NO; 
	[self theTimer]; 
	[self willChangeValueForKey:@"count"];
	[self willChangeValueForKey:@"progressBarMax"];
	count = 0;
	progressBarMax = 100;
	[self didChangeValueForKey:@"count"];
	[self didChangeValueForKey:@"progressBarMax"]; 
	[qlabScripts setFeedBackText:@"Timer Stopped"];
	[feedBackBox setStringValue:[qlabScripts feedBackText]];

}
	
//Contoller for the timer.  Loops the timer and calls for the save functions
-(void) decreaseCount: (NSTimer *) aTimer 
{ 
	[self willChangeValueForKey:@"count"]; 
	
	if (firstPass == YES){ 
		count --; 
		if (count == 0){
			[qlabScripts saveWorkspaceLogic];
			[self setCount];
		firstPass = NO; } }
	
	if (firstPass == NO) {
		count --;
		if (count == 0){
			[qlabScripts saveWorkspaceLogic];
		[self setCount]; } }
		
	
	[self didChangeValueForKey:@"count"]; 
}

//Get user input and set the count and bar for the timer
-(void)setCount 
{ 
	[self willChangeValueForKey:@"count"];
	[self willChangeValueForKey:@"progressBarMax"];
	//Set the count 
	
	int h; 
	int m;
	h = [self getHours]; 
	m = [self getMinutes]; 
	NSLog(@"Minutes is %i", m);
	
	count = (h * 7200) + (m * 120);
	progressBarMax = count;
	NSLog(@"Count is set to %i", count); 
	
	[self didChangeValueForKey:@"count"]; 
	[self didChangeValueForKey:@"progressBarMax"]; 
}


#pragma mark Hotkey Methods 

-(IBAction)hotKey: (id) sender
{ 
	
	NSLog(@"HOTKEY!");
		
	[qlabScripts saveWorkspaceLogic]; 
	
}

#pragma mark Hours and Minutes Prefs 

-(void) setMinutesField 
{ 
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
	NSString *minutesString = [defaults objectForKey:JATMinutesFieldKey]; 
	
	
	[fieldMinutes setStringValue:minutesString]; 	
	NSLog(@"MinField Says %@", [fieldMinutes stringValue]);
}	

-(void) setHoursField 
{ 
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
	NSString *hoursString = [defaults objectForKey:JATHoursFieldKey]; 
	
	[fieldHours setStringValue:hoursString]; 	
	
	
	NSLog(@"HoursString is %@", hoursString);
	NSLog(@"HorField Says %@", [fieldHours stringValue]);
}	

-(int)getMinutes
{ 
	int i; 
	NSString *theString = [fieldMinutes stringValue];
	
	i = [theString intValue]; 
	NSLog(@"getMinutes is %i", i );
	NSLog(@"theString is %@", theString); 
	return i; 
}

-(int)getHours
{ 
	int i; 
	i = [fieldHours intValue]; 
	return i; 
}

//When the user types in a textfield, update the pref file
- (void)controlTextDidChange:(NSNotification *)JATBackUpTextChangeNotification 
{ 
	NSLog(@"Notification Sent!!!");
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
	NSString *minutesString = [fieldMinutes stringValue]; 
	NSString *hoursString = [fieldHours stringValue];
	
	
	
	[defaults setObject:minutesString forKey:JATMinutesFieldKey]; 
	[defaults setObject:hoursString forKey:JATHoursFieldKey]; 
	
	
	
	[self setMinutesField]; 
	[self setHoursField]; 
}

-(IBAction) testButton: (id) sender
{
	[myPrefs getSaveUnmodifiedBoxState]; 
	
}

#pragma mark Notification Center 

-(void) handleFeedback:(NSNotification *)note 
{ 
	NSLog(@"Recived NotificationL %@", note); 
	[feedBackBox setStringValue:[qlabScripts feedBackText]];

}

-(void) restoreDefaults:(NSNotification *)note
{ 
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
	
	[defaults removeObjectForKey:JATHoursFieldKey]; 
	[defaults removeObjectForKey:JATMinutesFieldKey]; 
	
	[self setMinutesField];
	[self setHoursField]; 

}	
	
@end
