//
//  NSURL+Unretina.h
//  Unretiner
//
//  Created by Stuart Hall on 31/07/11.
//

#import <Foundation/Foundation.h>

@interface NSURL (Unretina)

// Converts an image to a non-retina version
- (BOOL)unretina:(NSURL*)folder errors:(NSMutableArray*)errors warnings:(NSMutableArray*)warnings overwrite:(BOOL)overwrite;

// Determines if it is a retina image
- (BOOL)isRetinaImage;

// Attempts to determine the image type
- (NSBitmapImageFileType)imageType;

@end
