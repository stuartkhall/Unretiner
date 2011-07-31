//
//  UnretinaViewController.h
//  Unretiner
//
//  Created by Stuart Hall on 31/07/11.
//

#import <Cocoa/Cocoa.h>
#import "NSDroppableView.h"

@interface UnretinaViewController : NSViewController<NSOpenSavePanelDelegate, NSDroppableViewDelegate>

@property (assign) IBOutlet NSButton* checkBox;

// Plus button handler
- (IBAction)onSelectFolder:(id)sender;

// Converts an array of URLs to non retina files
- (void)unretinaUrls:(NSArray*)urls;

@end
