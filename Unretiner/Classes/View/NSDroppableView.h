//
//  NSDroppableView.h
//  Unretiner
//
//  Created by Stuart Hall on 31/07/11.
//

#import <Cocoa/Cocoa.h>

@protocol NSDroppableViewDelegate;

@interface NSDroppableView : NSView

@property (nonatomic, assign) IBOutlet id<NSDroppableViewDelegate> delegate;

@end

@protocol NSDroppableViewDelegate <NSObject>

- (void)filesDropped:(NSArray*)urls;

@end
