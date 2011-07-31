//
//  NSDroppableView.m
//  Unretiner
//
//  Created by Stuart Hall on 31/07/11.
//

#import "NSDroppableView.h"

@implementation NSDroppableView

@synthesize delegate;

- (void)dealloc {
    self.delegate = nil;
    
    [super dealloc];
}

- (id)initWithFrame:(NSRect)frame {
    if (self = [super initWithFrame:frame]) {
		[self registerForDraggedTypes:[NSArray arrayWithObjects:
									   NSFilenamesPboardType, nil]];
    }
    return self;
}

#pragma mark - Drag and Drop



- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender {
	return NSDragOperationCopy;
}

- (NSDragOperation)draggingUpdated:(id <NSDraggingInfo>)sender {
	return NSDragOperationCopy;
}

- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender {
	return YES;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender {
    // Files dropped
	NSPasteboard *pboard = [sender draggingPasteboard];
	NSArray *files = [pboard propertyListForType:NSFilenamesPboardType];
    NSMutableArray* urls = [NSMutableArray arrayWithCapacity:[files count]];
	for (NSString* file in files) {
		[urls addObject:[NSURL fileURLWithPath:file]];
	}
    
    // Alert the delegate about the drop
    if (delegate) {
        [delegate filesDropped:urls];
    }
    
	
	return YES;
}

@end
