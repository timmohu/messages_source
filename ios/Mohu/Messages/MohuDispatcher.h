//
//  Tim Kendrick
//

#import <Foundation/Foundation.h>

@class MohuMessage;

@interface MohuDispatcher : NSObject {
	id target;
	NSMutableArray *listeners;
	NSMutableSet *runOnceListeners;
}

- (id)initWithTarget:(id)dispatchTarget;

- (void)addListener:(id)listener selector:(SEL)selector;

- (void)addListener:(id)listener selector:(SEL)selector runOnce:(BOOL)runOnce;

- (BOOL)hasListener:(id)listener selector:(SEL)selector;

- (void)removeListener:(id)listener selector:(SEL)selector;

- (void)removeAllListeners;

- (void)dispatch;

- (void)dispatch:(MohuMessage *)message;

- (void)dispatch:(MohuMessage *)message withTarget:(id)customTarget;

@end
