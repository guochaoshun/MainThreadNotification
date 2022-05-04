//
//  NSNotificationCenter+MainThread.h
//  日期测试
//
//  Created by 郭朝顺 on 2022/4/27.
//

#import <Foundation/Foundation.h>
#import "GCSNotificationInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSNotificationCenter (MainThread)


/// 使用此方法,可以保证通知在主线程回调,
/// @param object  block关联生命周期的对象,对象dealloc时,会取消监听通知, 不可以传nil, 使用weak持有,不增加引用计数
/// @param aName  通知的名字
/// @param block  收到通知的回调, 保证在主线程执行回调, block中必须使用weakSelf, 因为单例会持有block, block中持有self, 会导致对象引用计数增加, 无法正确释放
- (void)gcs_addObserver:(id)object name:(nullable NSNotificationName)aName mainThreadBlock:(GCSNotificationBlock)block;

///  主动移除此通知, 也可以不调用, 只要object能正确释放, 就不会在触发对应的block
/// @param object  block关联的对象
/// @param aName  通知名字
- (void)gcs_removeObserver:(id)object name:(nullable NSNotificationName)aName;


/// 慎用!!! 移除此通知的所有观察者,  比如有3个对象监听同一个通知, 此处移除, 会把这3个对象的监听都移除掉
/// @param aName 通知名字
//- (void)gcs_removeObserverName:(nullable NSNotificationName)aName;


@end

NS_ASSUME_NONNULL_END
