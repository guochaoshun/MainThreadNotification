//
//  GCSNotificationInfo.h
//  主线程收通知
//
//  Created by 郭朝顺 on 2022/5/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^GCSNotificationBlock)(NSNotification *noti);

@interface GCSNotificationInfo : NSObject

@property (nonatomic, weak) id object;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) GCSNotificationBlock notiBlock;

@end

NS_ASSUME_NONNULL_END
