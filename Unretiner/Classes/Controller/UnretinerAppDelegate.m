//
//  UnretinerAppDelegate.m
//  Unretiner
//
//  Created by Stuart Hall on 30/07/11.
//

#import "UnretinerAppDelegate.h"
#import "UnretinaViewController.h"

@implementation UnretinerAppDelegate

@synthesize window;
@synthesize view;
@synthesize viewController;

- (void)dealloc {
    self.window = nil;
    self.view = nil;
    self.viewController = nil;
    
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Add the view from our controller
    viewController = [[UnretinaViewController alloc] initWithNibName:@"UnretinaViewController" bundle:nil];
    viewController.view.bounds = self.view.bounds;
    [view addSubview:viewController.view];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
	// Close when the window is closed
	return YES;
}

- (void)application:(NSApplication *)sender openFiles:(NSArray *)files {
    // Files dropped onto the icon
    NSMutableArray* urls = [NSMutableArray arrayWithCapacity:[files count]];
	for (NSString* file in files) {
		[urls addObject:[NSURL fileURLWithPath:file]];
	}
    
    // Send to the controller
    [viewController unretinaUrls:urls];
}

- (void)appication:(NSApplication*)sender openFile:(NSString*)file {
    // Send to the controller
    [viewController unretinaUrls:[NSArray arrayWithObject:[NSURL fileURLWithPath:file]]];
}

@end
