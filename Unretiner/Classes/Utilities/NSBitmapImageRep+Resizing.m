//
//  NSBitmapImageRep+Resizing.m
//

#import "NSBitmapImageRep+Resizing.h"

@implementation NSBitmapImageRep (Resizing)

+ (NSBitmapImageRep *)imageRepWithWidth:(NSInteger)width andHeight:(NSInteger)height {
	return [[[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL 
													pixelsWide:width 
													pixelsHigh:height 
												 bitsPerSample:8 
											   samplesPerPixel:4 
													  hasAlpha:YES 
													  isPlanar:NO 
												colorSpaceName:NSCalibratedRGBColorSpace 
												   bytesPerRow:0
												  bitsPerPixel:0] autorelease];
}


-(void)setImage:(NSImage *)image {
	CGImageRef cgImage = [image CGImageForProposedRect:NULL context:nil hints:nil];
	
	CGContextRef context = CGBitmapContextCreate([self bitmapData], 
												 [self pixelsWide], 
												 [self pixelsHigh], 
												 [self bitsPerSample], 
												 [self bytesPerRow], 
												 [[self colorSpace] CGColorSpace], 
												 kCGImageAlphaPremultipliedLast);

	CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
	
	CGContextDrawImage(context, CGRectMake(0, 0, [self pixelsWide], [self pixelsHigh]), cgImage);
	CGContextRelease(context);
}

@end
