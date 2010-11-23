//
//  Tim Kendrick
//

#import <Foundation/Foundation.h>

@class MohuDispatcher;

@interface MohuMessage : NSObject <NSCopying> {
	id target;
	id currentTarget;
	MohuDispatcher *dispatcher;
}

@property (nonatomic, retain) id target;
@property (nonatomic, retain) id currentTarget;
@property (nonatomic, retain) MohuDispatcher *dispatcher;

+ (id)message;

@end
