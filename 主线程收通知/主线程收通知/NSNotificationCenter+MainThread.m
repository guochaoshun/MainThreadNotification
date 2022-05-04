//
//  NSNotificationCenter+MainThread.m
//  日期测试
//
//  Created by 郭朝顺 on 2022/4/27.
//

#import "NSNotificationCenter+MainThread.h"

@implementation NSNotificationCenter (MainThread)

static NSMutableDictionary *dic = nil;

- (void)loadDic {
    if (dic == nil) {
        dic = [NSMutableDictionary dictionary];
    }
}

- (void)gcs_addObserver:(id)object name:(nullable NSNotificationName)aName mainThreadBlock:(GCSNotificationBlock)block {

    if (object == nil) {
        NSLog(@"object必须有值才可以");
        return;
    }
    if (aName == nil) {
        NSLog(@"通知名字不存在");
        return;
    }

    if (block == nil) {
        NSLog(@"block不存在");
        return;
    }
    [self loadDic];
    NSMutableArray *array = dic[aName];
    if (array == nil) {
        array = [NSMutableArray array];
        dic[aName] = array;
    }
    GCSNotificationInfo *info = [[GCSNotificationInfo alloc] init];
    info.object = object;
    info.notiBlock = block;
    info.name = aName;
    [array addObject:info];
    [self addObserver:self selector:@selector(gcs_notiAction:) name:aName object:nil];
}

- (void)gcs_removeObserver:(id)object name:(nullable NSNotificationName)aName {
    if (object == nil) {
        NSLog(@"object必须有值才可以");
        return;
    }
    if (aName == nil) {
        NSLog(@"通知名字不存在");
        return;
    }

    NSMutableArray *notiArray = dic[aName];
    NSArray *tempArray = [notiArray copy];
    for (GCSNotificationInfo * info in tempArray) {
        if ([info.object isEqual:object]) {
            [notiArray removeObject:info];
            break;
        }
    }
    if (notiArray.count == 0) {
        [self gcs_removeObserverName:aName];
    }
}

- (void)gcs_notiAction:(NSNotification *)noti {

    if (dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL) == dispatch_queue_get_label(dispatch_get_main_queue())) {
        [self callAction:noti];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self callAction:noti];
        });
    }
    // 上下的目的一致, 上面的写法更严谨,https://blog.csdn.net/u014600626/article/details/122288475
//    if ([NSThread isMainThread]) {
//        [self callAction:noti];
//    } else {
//        dispatch_async(dispatch_get_main_queue(), ^{
//        });
//    }
}

- (void)callAction:(NSNotification *)noti {
    NSMutableArray *notiArray = dic[noti.name];
    NSArray *tempArray = [notiArray copy];
    for (GCSNotificationInfo * info in tempArray) {
        if (info.object) {
            info.notiBlock(noti);
        } else {
            [notiArray removeObject:info];
        }
    }
    if (notiArray.count == 0) {
        [self gcs_removeObserverName:noti.name];
    }
}

- (void)gcs_removeObserverName:(nullable NSNotificationName)aName {
    dic[aName] = nil;
    [self removeObserver:self name:aName object:nil];
}


@end
