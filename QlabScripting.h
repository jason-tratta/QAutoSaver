//
//  QlabScripting.h
//  QAutoSaver
//
//  Created by Jason Tratta on 6/10/09.
//  Copyright 2009 Sound Character. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PreferenceController.h"

extern NSString const * JATFeedBackNotification;

@interface QlabScripting : NSObject {
	
int arrayNumber;
int incrementFileName;
BOOL active; 
NSFileManager *fileManager;
NSString *workspaceName;
NSString *feedBackText; 
PreferenceController *myPrefs;


}

@property (readwrite, assign) NSString *feedBackText;

-(BOOL)isRunning; 
-(BOOL)isQlabActive; 
-(BOOL)isModified; 
-(void) saveAllWorkspaces; 
-(void)saveSpecifiedWorkspace: (int) a; 
-(void)saveWorkspaceLogic; 
-(id) workspaceNamer;
-(void)moveFiles;
-(int)getArrayNumber;



@end
