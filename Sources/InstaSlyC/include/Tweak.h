#import <Foundation/Foundation.h>

@interface IGUser
@property NSString *username;
@end

@interface IGMedia
@property BOOL hasLiked;
@property IGUser *user;
@end

@interface IGFeedSectionController
@property IGMedia *media;
@end

@interface IGFollowButton
@property NSInteger buttonState;
@end

@interface IGFollowController
@property IGUser *user;
@property IGFollowButton *followAccountButton;
@end
