//
//  GCSNotificationInfo.m
//  主线程收通知
//
//  Created by 郭朝顺 on 2022/5/4.
//

#import "GCSNotificationInfo.h"

@implementation GCSNotificationInfo

- (void)dealloc {
    NSLog(@"%s %@ %@ %@",__func__,self.name,self.object,self.notiBlock);
}

@end
