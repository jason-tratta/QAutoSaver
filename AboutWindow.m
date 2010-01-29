//
//  About.m
//  QAutoSaver
//
//  Created by Jason Tratta 2/4/09.
//  Copyright 2009 Sound Character. All rights reserved.
//

#import "AboutWindow.h"


@implementation AboutWindow

-(id)init 
{ 
	if (![super initWithWindowNibName:@"AboutWindow"])
		return nil;
	return self; 
}

-(void)windowDidLoad 
{ 
	NSLog(@"About Nib is loaded"); 
	
}



-(IBAction)openPayPalInBrowser: (id) sender
{ 
	
	NSWorkspace *payWorkSpace = [NSWorkspace sharedWorkspace]; 
	NSURL *donateURL = [NSURL URLWithString:@"https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=5729107"];
	NSLog(@"URL is %@", donateURL);
	
	[payWorkSpace openURL:donateURL];
	
	
}

-(IBAction)imageGoHome:(id) sender
{
	NSWorkspace *goHomeSpace = [NSWorkspace sharedWorkspace]; 
	NSURL *homeURL = [NSURL URLWithString:@"http://www.jasontratta.com/qautosaver"]; 
	
	[goHomeSpace openURL:homeURL]; 
	
}



@end
