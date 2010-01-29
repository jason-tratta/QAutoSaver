//
//  PreferenceController.m
//  QAutoSaver
//
//  Created by Jason Tratta 2/4/09.
//  Copyright 2009 Sound Character. All rights reserved.
//

#import "PreferenceController.h"

NSString * const JATRestoreDefaultsNotification = @"RestoreDefaults";
NSString * const JATBackUpTextKey = @"BackUpText"; 
NSString * const JATBackUpTextChangeNotification = @"BackUpTextChanged";
NSString * const JATSavePathKey = @"SavePathControl"; 
NSString * const JATBackUpCheckKey = @"BackupCheckBox"; 
NSString * const JATTimeCheckKey = @"TimeCheckBox"; 
NSString * const JATSaveUnModKey = @"ModToggle";
NSString * const JATDateBoxState = @"DateBoxState";
NSString * const JATDateBoxString = @"DateBoxString";

@implementation PreferenceController

@synthesize path;
@synthesize stringName;
@synthesize workspaceName;
@synthesize capturedPath;
@synthesize savePath;
@synthesize modState; 




// Register the preferance defaults
+(void) initialize 
{ 
	//Create a dictionary 
	NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary]; 
	
	//Create the defaults 
	NSString *defaultBackUpText = @"_BACKUP";
	NSString *defaultSavePath = @"file://localhost/";
	NSString *defaultBackupCheckBox = @"1"; 
	NSString *defaultTimeCheckBox = @"1"; 
	NSString *defaultSaveModBox = @"1"; 
	NSString *defaultDateBoxState =@"0";
	NSString *defaultDateString =@"_MMddYY_HHmm";
	
	//Put the defaults in the dictionary 
	[defaultValues setObject:defaultBackUpText	forKey:JATBackUpTextKey]; 
	[defaultValues setObject:defaultSavePath forKey:JATSavePathKey]; 
	[defaultValues setObject:defaultBackupCheckBox forKey:JATBackUpCheckKey];
	[defaultValues setObject:defaultTimeCheckBox forKey:JATTimeCheckKey];
	[defaultValues setObject:defaultSaveModBox forKey:JATSaveUnModKey]; 
	[defaultValues setObject:defaultDateBoxState forKey:JATDateBoxState];
	[defaultValues setObject:defaultDateString forKey:JATDateBoxString];

	//Register the Dictionary of defualts 
	[[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues]; 
	NSLog(@"registed defaults: %@", defaultValues);
	

	
}

-(id)init	
{
	[super init];
	//Build Array for TimeStamp Data Source 
	times = [NSArray arrayWithObjects:  @"_MMddYY_HHmm", @"_MM_dd_YY", @"_MMdd_HHmm", @"_MM-dd-hh-mm", @"_dd-hh-mm", nil];
	
	return self;
}

-(void)awakeFromNib
{ 
	//Get and set all user pref fields 
	[self setBackUpTextField]; 
	[self setBackupCheckBox];
	[self setTimeCheckBox]; 
	[self setPathControl]; 
	[self setSaveModBox]; 
	[self setDateComboBox];
	
}


#pragma mark BackUp Text Methods 

-(void)setBackUpTextField
{ 
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
	NSString *backUpString = [defaults objectForKey:JATBackUpTextKey]; 
	
	[backUpTextField setStringValue:backUpString]; 	
	
	NSLog(@"BackupString is %@", backUpString);
	NSLog(@"Field Says %@", [backUpTextField stringValue]);
	
}

-(NSString *) backUpTextField
{ 
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *backUpString = [defaults objectForKey:JATBackUpTextKey]; 
	return backUpString; 
}


//When the user types in a textfield, update the pref file
- (void)controlTextDidChange:(NSNotification *)JATBackUpTextChangeNotification 
{ 
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
	NSString *backUpString = [backUpTextField stringValue]; 
	
	[defaults setObject:backUpString forKey:JATBackUpTextKey]; 

	[self setBackUpTextField]; 

}



#pragma mark Restore defaults 

// Restores the default preferances
-(IBAction)restorePrefDefaults: (id) sender
{ 
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter]; 
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
	
	[defaults removeObjectForKey:JATBackUpTextKey]; 
	[defaults removeObjectForKey:JATSavePathKey]; 
	[defaults removeObjectForKey:JATBackUpCheckKey]; 
	[defaults removeObjectForKey:JATTimeCheckKey]; 
	[defaults removeObjectForKey:JATSaveUnModKey]; 
	[defaults removeObjectForKey:JATDateBoxState]; 
	[defaults removeObjectForKey:JATDateBoxString]; 
	
	[self setBackUpTextField]; 
	[self setBackupCheckBox];
	[self setTimeCheckBox]; 	
	[self setSaveModBox]; 
	[self setDateComboBox]; 
	[self setPathControl];
	[nc postNotificationName:(NSString *) JATRestoreDefaultsNotification object:self];
}

#pragma mark CheckBox Checking


-(IBAction)backupCheckBoxToggle: (id) sender
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
	int i = [backUpTextOptionCheckBox state]; 
	NSString *backUpBoxState = [[NSNumber numberWithInt:i] stringValue];
	
	[defaults setObject:backUpBoxState forKey:JATBackUpCheckKey]; 
}	

-(IBAction)dateCheckBoxToggle: (id) sender
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
	int i = [dateTextOptionCheckBox state]; 
	NSString *dateBoxState = [[NSNumber numberWithInt:i] stringValue];
	
	[defaults setObject:dateBoxState forKey:JATTimeCheckKey]; 
	NSLog(@"Date CheckBox Changed"); 
}	


-(void)setBackupCheckBox
{ 
		
	int i; 
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
	NSString *backUpCheck = [defaults objectForKey:JATBackUpCheckKey]; 
	
	i = [backUpCheck intValue]; 

	[backUpTextOptionCheckBox setState:i]; 
	
	
}

-(void)setTimeCheckBox
{ 
	
	int i; 
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
	NSString *timeCheck = [defaults objectForKey:JATTimeCheckKey]; 
	
	i = [timeCheck intValue]; 
	
	[dateTextOptionCheckBox setState:i]; 
	
	
}

-(void)setSaveModBox
{ 
	
	int i; 
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
	NSString *modCheck = [defaults objectForKey:JATSaveUnModKey]; 
	
	i = [modCheck intValue]; 
	
	[saveUnmodifiedBox setState:i]; 
	
}
	

-(IBAction)saveUnModBoxToggle: (id) sender
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
	int i = [saveUnmodifiedBox state]; 
	NSString *modBoxState = [[NSNumber numberWithInt:i] stringValue];
	
	[defaults setObject:modBoxState forKey:JATSaveUnModKey]; 
	
	
}	
	

	

-(int)getSaveUnmodifiedBoxState
{ 
	int i; 
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
	NSString *modCheck = [defaults objectForKey:JATSaveUnModKey]; 
	
	i = [modCheck intValue]; 
	return i; 
}


-(int) getBackupCheckBoxState
{ 
	int i; 
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
	NSString *boxCheck = [defaults objectForKey:JATBackUpCheckKey]; 
	
	i = [boxCheck intValue]; 
	return i; 
	
}

-(int) getDateCheckBoxState
{ 
	int i; 
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
	NSString *boxCheck = [defaults objectForKey:JATTimeCheckKey]; 
	
	i = [boxCheck intValue]; 
	return i; 
	
}
	

#pragma mark Path Control / Save Window 

-(IBAction) pathControl: (id) sender
{
	
	[self pathControl]; 
	
} 


-(void) pathControl

{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
	NSString *pathString;
	
	// Values to recongifure NSOpenPanel
	NSString *title = @"Select Path";
	NSString *message = @"Select or create a directory. Tags will be added to the filename based on your preferences";
	NSString *choose = @"Choose";
	int spaceName;
	
	
	
	// Recongifure the standard NSOpenPanel
	save = [NSOpenPanel openPanel];         // Opens the open panel
	
	[save setTitle:title];					// Sets the Tile of the window to select path
	[save setCanCreateDirectories:YES];		//Allows user to create new folders
	[save setMessage:message];				//Explanation text above the save text box
	[save setPrompt:choose];				//Changes the default save button to say "Choose"
	[save setCanCreateDirectories:YES];
	[save setCanChooseDirectories:YES];
	[save setCanChooseFiles:NO];
	[save setDelegate:self];
	
	
	spaceName = [save runModalForTypes:nil];  //Inits the default file name 
	
	if (spaceName == NSOKButton){
		path = [save URL]; 
		savePath = [save URL];
		pathString = [savePath absoluteString];
		[pathController setURL:path];
		NSLog(@"Path is %@", path);
		[defaults setObject:pathString forKey:JATSavePathKey];
		
	}
	
	
} 


-(void)setPathControl

{ 
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
	NSString *pathString = [defaults objectForKey:JATSavePathKey]; 
	NSURL *pathURL = [NSURL URLWithString:pathString];
	
	path = pathURL;
	[pathController setURL:path];	
	
	
	
	
}

-(NSString *)getSavePath
{ 
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
	NSString *pathString = [defaults objectForKey:JATSavePathKey]; 
	NSString *returnString, *returnStringPassOne;
	 
	
	//NSFileManager in the MoveFiles Method does not work when passed file:// This removes it from the string
	
	returnStringPassOne = [pathString stringByReplacingOccurrencesOfString:@"file://localhost" withString:@""];
	returnString = [returnStringPassOne stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
	NSLog(@"ReturnString is %@", returnString); 
	
	return returnString; 
}
	

#pragma mark Date Stamps


-(void)setDateComboBox 
{ 
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
	NSString *selectionString = [defaults objectForKey:JATDateBoxState]; 
	
	int i; 
	i = [selectionString intValue]; 
	NSLog(@"Save Pref int is %i", i);
	
	[timeStampSelector selectItemAtIndex:i];
	
}

-(NSString *)getDateString
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *dateString = [defaults objectForKey:JATDateBoxString]; 
	return dateString; 
	
}

- (void)comboBoxSelectionDidChange:(NSNotification *)notification
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
	
	int i = [timeStampSelector indexOfSelectedItem]; 
	NSString *dateSelectionState = [[NSNumber numberWithInt:i] stringValue];
	[defaults setObject:dateSelectionState forKey:JATDateBoxState]; 
	
	NSString *stringValue = [times objectAtIndex:i];
	[defaults setObject:stringValue forKey:JATDateBoxString]; 
	
	
	NSLog(@"Item Selected is %i", i); 
	NSString *test = [defaults objectForKey:JATDateBoxString];
	NSLog(@"SavedString is %@", test);
	[self setDateComboBox];
	
	

}



// Combo box data source methods


- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)aComboBox 
{
	
    return [times count];
}

- (id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(NSInteger)index 
{
    return [times objectAtIndex:index];
}


- (NSUInteger)comboBox:(NSComboBox *)aComboBox indexOfItemWithStringValue:(NSString *)string {
    return [times indexOfObject: string];
}



@end
