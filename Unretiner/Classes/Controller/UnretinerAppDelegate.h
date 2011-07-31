//
//  UnretinerAppDelegate.h
//  Unretiner
//
//  Created by Stuart Hall on 30/07/11.
//

#import <Cocoa/Cocoa.h>

@class UnretinaViewController;

@interface UnretinerAppDelegate : NSObject <NSApplicationDelegate> {
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSView *view;
@property (nonatomic, retain) UnretinaViewController *viewController;

@end
