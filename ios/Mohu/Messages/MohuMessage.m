//
//  Tim Kendrick
//

#import "MohuMessage.h"


@implementation MohuMessage

@synthesize target;
@synthesize currentTarget;
@synthesize dispatcher;

+ (id)message {
	return [[[self alloc] init] autorelease];
}

- (void)dealloc {
	[target release];
	[currentTarget release];
	[dispatcher release];
	
	[super dealloc];
}

- (id)copyWithZone:(NSZone *)zone {
	MohuMessage *copy = [[[self class] allocWithZone: zone] init];
	copy.target = target;
	copy.currentTarget = currentTarget;
	copy.dispatcher = dispatcher;
	return copy;
}


@end
