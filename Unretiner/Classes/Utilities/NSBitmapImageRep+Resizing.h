//
//  NSBitmapImageRep+Resizeing.h
//
//

#import <Cocoa/Cocoa.h>

@interface NSBitmapImageRep (Resizing)

+ (NSBitmapImageRep *)imageRepWithWidth:(NSInteger)width andHeight:(NSInteger)height;

- (void)setImage:(NSImage *)image;

@end
