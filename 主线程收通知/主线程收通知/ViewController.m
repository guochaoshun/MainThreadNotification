//
//  ViewController.m
//  主线程收通知
//
//  Created by 郭朝顺 on 2022/5/4.
//

#import "ViewController.h"
#import "NSNotificationCenter+MainThread.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(aaa:) name:@"aaa" object:nil];

    __weak typeof(self) weakSelf = self;
    [[NSNotificationCenter defaultCenter] gcs_addObserver:self name:@"aaa" mainThreadBlock:^(NSNotification * _Nonnull noti) {
        [weakSelf aaa:noti];
    }];

}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"aaa" object:nil];
    });
}


- (void)aaa:(NSNotification *)noti {
    [self showAlertWithTitle:[[NSThread currentThread] description]];
}

- (void)showAlertWithTitle:(NSString *)title {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}

@end
