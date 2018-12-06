//
//  RunLoopViewController.m
//  GCD
//
//  Created by wahaha on 2018/11/15.
//  Copyright © 2018年 LWX. All rights reserved.
//

#import "RunLoopViewController.h"

@interface RunLoopViewController ()
@property (nonatomic, strong) UIScrollView* scrollView;

/**
 使用weak，防止循环引用内存泄漏
 */
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, weak) NSThread *thread;

@end

@implementation RunLoopViewController

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.scrollView];
//    self.timer.tolerance = 0.1;
    [self initRunLoop];
    [self initThread];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    // Do any additional setup after loading the view.
//    [self performSelector:@selector(initTimer) onThread:<#(nonnull NSThread *)#> withObject:<#(nullable id)#> waitUntilDone:<#(BOOL)#> modes:<#(nullable NSArray<NSString *> *)#>]
    [self performSelector:@selector(performSelector) onThread:self.thread withObject:nil waitUntilDone:NO];
}

- (void)performSelector {
    NSLog(@"1234512345");
//    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, <#dispatchQueue#>);
//    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, <#intervalInSeconds#> * NSEC_PER_SEC, <#leewayInSeconds#> * NSEC_PER_SEC);
//    dispatch_source_set_event_handler(timer, ^{
//        <#code to be executed when timer fires#>
//    });
//    dispatch_resume(timer);
}

- (void)initRunLoop {
//    UIImageView *imageView = [UIImageView new];
//    [imageView performSelector:@selector(setImage:) withObject:[UIImage new] afterDelay:0 inModes:@[NSDefaultRunLoopMode]];
    dispatch_async(dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_DEFAULT), ^{
        CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
            switch (activity) {
                case kCFRunLoopEntry:
                    NSLog(@"即将进入runloop");
                    break;
                case kCFRunLoopBeforeTimers:
                    NSLog(@"即将处理timer");
                    break;
                case kCFRunLoopBeforeSources:
                    NSLog(@"即将处理input source");
                    break;
                case kCFRunLoopBeforeWaiting:
                    NSLog(@"即将进入休眠");
                    break;
                case kCFRunLoopAfterWaiting:
                    /*
                     判断是否是timer唤醒，是就处理timer
                     否则判断是否是y异步线程唤醒，是就处理
                     否则就处理source1
                     */
                    NSLog(@"即将被唤醒处理唤醒源");
                    break;
                case kCFRunLoopExit:
                    NSLog(@"即将推出runloop");
                    break;
                default:
                    break;
            }
        });
        [NSTimer scheduledTimerWithTimeInterval:5.0 repeats:NO block:^(NSTimer * _Nonnull timer) {
            NSLog(@"哈哈哈");
        }];
        CFRunLoopAddCommonMode(CFRunLoopGetCurrent(), (CFStringRef)UITrackingRunLoopMode);
        CFRunLoopAddObserver([[NSRunLoop currentRunLoop] getCFRunLoop], observer, kCFRunLoopCommonModes);
        [[NSRunLoop currentRunLoop] run];
    });
}

- (void)initThread {
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(initTimer) object:nil];
    self.thread = thread;
    [self.thread start];
}

- (void)initTimer {
    self.timer = self.timer;
}

- (void)timerBegin:(NSTimer *)timer {
    static int value = 1;
    value ++;
    NSLog(@"%@", [NSDate date]);
    NSLog(@"%@", [NSRunLoop currentRunLoop]);
    CFRunLoopStop(CFRunLoopGetCurrent());

    if (value == 7) {
        [timer invalidate];
    }
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.contentSize = CGSizeMake(CGRectGetMaxX(self.view.frame), 20000);
    }
    return _scrollView;
}

- (NSTimer *)timer {
    @autoreleasepool {
        NSTimer *timer = _timer;
        if (!timer) {
            timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerBegin:) userInfo:nil repeats:YES];
            /*
             子线程的runloopmode NSRunLoopCommonModes仅仅包含NSDefaultRunLoopMode,
             不包含UITrackingRunLoopMode,
             因此如果
             [[NSRunLoop currentRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];
             [[NSRunLoop currentRunLoop] runMode:NSRunLoopCommonModes beforeDate:[NSDate distantFuture]];
             是不会运行的
             
             可通过
             CFRunLoopAddCommonMode(CFRunLoopGetCurrent(), (CFStringRef *)UITrackingRunLoopMode);
             手动加入UITrackingRunLoopMode
             */
            CFRunLoopAddCommonMode(CFRunLoopGetCurrent(), (CFStringRef)UITrackingRunLoopMode);
            [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
            
            /*
             子线程的runloop需要手动run，不需要手动创建，懒加载，在调用[NSRunLoop currentRunLoop]的时候会自动创建
             [[NSRunLoop currentRunLoop] run];
             [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantFuture]];
             不可以使用    CFRunLoopStop(CFRunLoopGetCurrent()); 停止runloop的运行
             [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]; 可以使用CFRunLoopStop(CFRunLoopGetCurrent());停止runloop运行
             */
            [[NSRunLoop currentRunLoop] runMode:UITrackingRunLoopMode beforeDate:[NSDate distantFuture]];
        }
        return timer;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
