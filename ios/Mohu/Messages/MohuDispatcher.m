//
//  Tim Kendrick
//

#import "MohuDispatcher.h"

#import "MohuMessage.h"

@implementation MohuDispatcher

- (id)init {
	self = [super init];
	if (self != nil) {
		listeners = [[NSMutableArray alloc] init];
		runOnceListeners = [[NSMutableSet alloc] init];
	}
	return self;
}

- (id)initWithTarget:(id)dispatchTarget {
	self = [super init];
	if (self != nil) {
		listeners = [[NSMutableArray alloc] init];
		runOnceListeners = [[NSMutableSet alloc] init];
		target = [dispatchTarget retain];
	}
	return self;
}

- (void)dealloc {
	
	[self removeAllListeners];
	
	[target release];
	[listeners release];
	[runOnceListeners release];
	
	[super dealloc];
}

- (void)addListener:(id)listener selector:(SEL)selector {
	NSNumber *selectorValue = [NSNumber numberWithInt:(int)selector];
	for (NSArray *listenerArray in listeners) if (((id)[listenerArray objectAtIndex:0] == listener) && [(NSNumber *)[listenerArray objectAtIndex:1] isEqualToNumber:selectorValue]) return;
	NSArray *listenerArray = [NSArray arrayWithObjects:listener, selectorValue, nil];
	[listeners addObject:listenerArray];
	[listener release];
}

- (void)addListener:(id)listener selector:(SEL)selector runOnce:(BOOL)runOnce {
	NSNumber *selectorValue = [NSNumber numberWithInt:(int)selector];
	for (NSArray *listenerArray in listeners) if (((id)[listenerArray objectAtIndex:0] == listener) && [(NSNumber *)[listenerArray objectAtIndex:1] isEqualToNumber:selectorValue]) return;
	NSArray *listenerArray = [NSArray arrayWithObjects:listener, selectorValue, nil];
	[listeners addObject:listenerArray];
	[listener release];
	if (runOnce) [runOnceListeners addObject:listenerArray];
}

- (BOOL)hasListener:(id)listener selector:(SEL)selector {
	NSNumber *selectorValue = [NSNumber numberWithInt:(int)selector];
	for (NSArray *listener in listeners) if (((id)[listener objectAtIndex:0] == listener) && [(NSNumber *)[listener objectAtIndex:1] isEqualToNumber:selectorValue]) return YES;
	return NO;
}

- (void)removeListener:(id)listener selector:(SEL)selector {
	NSNumber *selectorValue = [NSNumber numberWithInt:(int)selector];
	for (NSArray *listenerArray in listeners) {
		if (((id)[listenerArray objectAtIndex:0] == listener) && ([(NSNumber *)[listenerArray objectAtIndex:1] isEqualToNumber:selectorValue])) {
			[listener retain];
			[listeners removeObject:listenerArray];
			if ([runOnceListeners containsObject:listenerArray]) [runOnceListeners removeObject:listenerArray];
			return;
		}
	}
}

- (void)removeAllListeners {
	for (NSArray *listenerArray in listeners) {
		[[listenerArray objectAtIndex:0] retain];
		[listeners removeObject:listenerArray];
		if ([runOnceListeners containsObject:listenerArray]) [runOnceListeners removeObject:listenerArray];
	}
	[listeners removeAllObjects];
	[runOnceListeners removeAllObjects];
}

- (void)dispatch {
	[self dispatch:nil withTarget:target];
}

- (void)dispatch:(MohuMessage *)message {
	[self dispatch:message withTarget:(message.target ? message.target : target)];
}

- (void)dispatch:(MohuMessage *)message withTarget:(id)customTarget {
	message = (message ? [message copy] : [[MohuMessage alloc] init]);
	message.target = customTarget;
	message.currentTarget = target;
	message.dispatcher = self;
	for (int i = 0; i < [listeners count]; i++) {
		NSArray *listener = [listeners objectAtIndex:i];
		if ([runOnceListeners containsObject:listener]) {
			[runOnceListeners removeObject:listener];
			[listeners removeObject:listener];
		}
		[(id)[listener objectAtIndex:0] performSelector:(SEL)[(NSNumber *)[listener objectAtIndex:1] intValue] withObject:message];
	}
	[message release];
}
@end
