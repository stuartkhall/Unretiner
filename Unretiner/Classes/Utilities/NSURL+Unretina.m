//
//  NSURL+Unretina.m
//  Unretiner
//
//  Created by Stuart Hall on 31/07/11.
//

#import "NSURL+Unretina.h"
#import "NSBitmapImageRep+Resizing.h"

@implementation NSURL (Unretina)

static NSString* const kRetinaString = @"@2x";
static NSString* const kHdString = @"-hd";

- (BOOL)unretina:(NSURL*)folder errors:(NSMutableArray*)errors warnings:(NSMutableArray*)warnings {
    if ([self isRetinaImage]) {
		NSImage *sourceImage = [[NSImage alloc] initWithContentsOfURL:self];
        if (sourceImage && [sourceImage isValid]) {
            // Hack to ensure the size is set correctly independent of the dpi
            NSImageRep *rep = [[sourceImage representations] objectAtIndex:0]; 
			[sourceImage setScalesWhenResized:YES]; 
			[sourceImage setSize:NSMakeSize([rep pixelsWide], [rep pixelsHigh])]; 
            
            // Warn if either dimension is odd
			if (((int)[sourceImage size].width) % 2 != 0 || ((int)[sourceImage size].height) % 2 != 0) {
				[warnings addObject:[NSString stringWithFormat:@"%@ : has dimensions not divisible by 2", [[self absoluteString] lastPathComponent]]];
			}
            
            // Determine the image type
            NSBitmapImageFileType imageType = [self imageType];
            if ((int)imageType >= 0) {
                // Create a bitmap representation
                NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithWidth:[sourceImage size].width / 2.0 andHeight:[sourceImage size].height / 2.0];
                [imageRep setImage:sourceImage];
                
                // New path is the same file minus the @2x
                NSString* newFilename = [[self lastPathComponent] stringByReplacingOccurrencesOfString:@"@2x" withString:@""];
                newFilename = [newFilename stringByReplacingOccurrencesOfString:@"-hd" withString:@""];
                NSString* newPath = [NSString stringWithFormat:@"%@%@", [folder relativeString], newFilename];

                // Write out the new image
                NSData *imageData = [imageRep representationUsingType:imageType properties:nil];
                if (![imageData writeToURL:[NSURL URLWithString:newPath] atomically:YES]) {
                    [errors addObject:[NSString stringWithFormat:@"%@ : Error creating file", newPath]];
                } 
            }
            else {
                [errors addObject:[NSString stringWithFormat:@"%@ : Unknown image type", [[self absoluteString] lastPathComponent]]];
            }
        }
        else {
            // Invalid
            [errors addObject:[NSString stringWithFormat:@"%@ : Appears to be invalid", [[self absoluteString] lastPathComponent]]];
        }
        
        // Cleanup
        if (sourceImage) {
            [sourceImage release];
        }
    }
    else if (errors) {
        // Not a valid retina file
        [errors addObject:[NSString stringWithFormat:@"%@ : Not a @2x or -hd file", [[self absoluteString] lastPathComponent]]];
    }
    
    return NO;
}

- (NSBitmapImageFileType)imageType {
    NSString* extension = [[self pathExtension] lowercaseString];
    if ([extension caseInsensitiveCompare:@"jpg"] == NSOrderedSame || [extension caseInsensitiveCompare:@"jpeg"] == NSOrderedSame) {
        // JPG
        return NSJPEGFileType;
    }
    else if ([extension caseInsensitiveCompare:@"png"] == NSOrderedSame) {
        // PNG
        return NSPNGFileType;
    }
    else if ([extension caseInsensitiveCompare:@"gif"] == NSOrderedSame) {
        // GIF
        return NSGIFFileType;
    }
    else if ([extension caseInsensitiveCompare:@"tif"] == NSOrderedSame || [extension caseInsensitiveCompare:@"tiff"] == NSOrderedSame) {
        // TIFF
        return NSTIFFFileType;
    }
    
    // Hack
    return -1;
}

- (BOOL)isRetinaImage {
    // See if the file is a retina image
    NSString* lastComponent = [[self absoluteString] lastPathComponent];
    lastComponent = [lastComponent stringByDeletingPathExtension];
    return [lastComponent hasSuffix:kRetinaString] || [lastComponent hasSuffix:kHdString];
}

@end
