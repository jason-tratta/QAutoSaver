//
//  PreferenceController.h
//  QAutoSaver
//
//  Created by Jason Tratta 2/4/09.
//  Copyright 2009 Sound Character. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern NSString * const JATRestoreDefaultsNotification;
NSString * const JATBackUpTextKey;
NSString * const JATBackUpTextChangeNotification;
NSString * const JATSavePathKey;
NSString * const JATBackUpCheckKey; 
NSString * const JATTimeCheckKey; 
NSString * const JATSaveUnModKey;
NSString * const JATDateBoxState;
NSString * const JATDateBoxString;



@interface PreferenceController : NSObject {
	
	
	IBOutlet NSTextField *backUpTextField;
	IBOutlet NSComboBox *timeStampSelector; 
	IBOutlet NSButton *backUpTextOptionCheckBox; 
	IBOutlet NSButton *dateTextOptionCheckBox; 
	IBOutlet NSButton *defualtsRestoreButton;
	IBOutlet NSButton *saveUnmodifiedBox;
	IBOutlet NSPathControl *pathController; 
	
	
	NSURL *savePath;
	NSOpenPanel *save;
	id path;
	NSString *stringName;
	NSString *workspaceName;
	NSString *capturedPath; 
	int modState; 
	NSMutableArray *times;
	


}

@property (readwrite, assign) NSString *stringName;
@property (readwrite, assign) NSString *workspaceName;
@property (readwrite, assign) id path;
@property (readwrite, assign) NSURL *savePath;
@property (readwrite, assign) NSString *capturedPath;
@property (readwrite, assign) int modState; 




-(void) setBackUpTextField; 
-(void)setBackupCheckBox;
-(void)setSaveModBox;
-(IBAction) pathControl: (id) sender; 
-(void)setTimeCheckBox;
-(void)setPathControl;
-(NSString *) backUpTextField;
-(int) getBackupCheckBoxState;
-(int) getDateCheckBoxState;
-(IBAction)restorePrefDefaults: (id) sender;
-(IBAction)backupCheckBoxToggle: (id) sender;
-(IBAction)dateCheckBoxToggle: (id) sender;
-(IBAction)saveUnModBoxToggle: (id) sender;
-(int)getSaveUnmodifiedBoxState; 
-(void) pathControl;
-(NSString *)getSavePath;
-(NSString *)getDateString; 
-(void)setDateComboBox;



@end
