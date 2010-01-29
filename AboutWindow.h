//
//  About.h
//  QAutoSaver
//
//  Created by Jason Tratta 2/4/09.
//  Copyright 2009 Sound Character. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface AboutWindow : NSWindowController {

	IBOutlet NSButton *openPayPal; 
	IBOutlet NSButton *imageHome;
	
	
}


-(IBAction)openPayPalInBrowser: (id) sender; 
-(IBAction)imageGoHome: (id) sender; 

@end


