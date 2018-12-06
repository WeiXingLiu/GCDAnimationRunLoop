//
//  ViewController.m
//  GCD
//
//  Created by wahaha on 2018/10/30.
//  Copyright © 2018年 LWX. All rights reserved.
//

#import "ViewController.h"
#import "KeyFrameViewController.h"
#import "RunLoopViewController.h"
@interface ViewController ()
@property (nonatomic, strong) UIView *animationView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAnimation];
    [self initNav];
    // Do any additional setup after loading the view, typically from a nib.
    /*
     dispatch_queue_t myQueue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_CONCURRENT);
     dispatch_async(myQueue, ^{
     for (int i = 0; i < 10; i ++) {
     NSLog(@"%d", i);
     }
     });
     NSLog(@"第1个");
     dispatch_async(myQueue, ^{
     for (int i = 10; i < 20; i ++) {
     NSLog(@"%d", i);
     }
     });
     NSLog(@"第2个");
     
     dispatch_sync(myQueue, ^{
     for (int i = 20; i < 30; i ++) {
     NSLog(@"%d", i);
     }
     });
     NSLog(@"第3个");
     
     dispatch_sync(myQueue, ^{
     for (int i = 30; i < 40; i ++) {
     NSLog(@"%d", i);
     }
     });
     NSLog(@"第4个");
     
     dispatch_barrier_async(myQueue, ^{
     for (int i = 40; i < 50; i ++) {
     NSLog(@"%d", i);
     }
     });
     NSLog(@"第5个");
     
     dispatch_barrier_sync(myQueue, ^{
     for (int i = 50; i < 60; i ++) {
     NSLog(@"%d", i);
     }
     });
     NSLog(@"第6个");
     
     dispatch_sync(myQueue, ^{
     for (int i = 60; i < 70; i ++) {
     NSLog(@"%d", i);
     }
     });
     NSLog(@"第7个");
     
     dispatch_sync(myQueue, ^{
     for (int i = 70; i < 80; i ++) {
     NSLog(@"%d", i);
     }
     });
     
     */
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t groupQueue = dispatch_queue_create("groupQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_enter(group);
    dispatch_group_async(group, groupQueue, ^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            for (int i = 0; i < 10; i ++) {
                NSLog(@"group %d", i);
            }
            dispatch_group_leave(group);
        });
    });
    
    dispatch_group_enter(group);
    dispatch_group_async(group, groupQueue, ^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            for (int i = 10; i < 20; i ++) {
                NSLog(@"group %d", i);
            }
            dispatch_group_leave(group);
        });
    });
    NSLog(@"wait");
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    NSLog(@"waitFinish");
    
    dispatch_group_notify(group, groupQueue, ^{
        for (int i = 20; i < 30; i ++) {
            NSLog(@"group %d", i);
        }
    });
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    NSLog(@"group finish");
    
    dispatch_group_t group2 = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_enter(group2);
    dispatch_group_async(group2, queue, ^{
        for (int i = 100; i < 110; i ++) {
            NSLog(@"%d", i);
        }
        dispatch_group_leave(group2);
    });
    dispatch_group_enter(group2);
    dispatch_group_async(group2, queue, ^{
        for (int i = 110; i < 120; i ++) {
            NSLog(@"%d", i);
        }
        dispatch_group_leave(group2);
    });
}

- (void)initAnimation {
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
//        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];

    animation.autoreverses = YES;
    animation.duration = 0.8;
    animation.repeatCount = HUGE_VALF;
    animation.fromValue = 0;
    animation.toValue = @(20);
    [self.view addSubview:self.animationView];
    [self.animationView.layer addAnimation:animation forKey:@"cornerRadius"];
    
    [self initScaleAnimation];
    [self initRotationAnimation];
    [self initBackColorAnimation];
    [self initOpacityAnimation];
    [self initSpringAnimation];
}

- (void)initScaleAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    animation.delegate = self;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.autoreverses = YES;
    animation.duration = 0.8;
    animation.repeatCount = HUGE_VALF;
    animation.fromValue = @(1);
    animation.toValue = @(2);
    [self.animationView.layer addAnimation:animation forKey:@"transform.scale"];
//    [self.animationView.layer removeAnimationForKey:<#(nonnull NSString *)#>];
}

- (void)initRotationAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
    animation.autoreverses = YES;
    animation.duration = 0.8;
    animation.repeatCount = HUGE_VALF;
    animation.fromValue = 0;
    animation.toValue = @(M_PI * 2);
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
//    animation.valueFunction = [CAValueFunction functionWithName:kCAValueFunctionRotateZ];
    [self.animationView.layer addAnimation:animation forKey:@"ransform.rotation.x"];
}

- (void)initBackColorAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    animation.autoreverses = YES;
    animation.duration = 0.8;
    animation.repeatCount = HUGE_VALF;
    animation.fromValue = (id)[UIColor orangeColor].CGColor;
    animation.toValue = (id)[UIColor redColor].CGColor;
    [self.animationView.layer addAnimation:animation forKey:@"backgroundColor"];
}

- (void)initOpacityAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.autoreverses = YES;
    animation.duration = 0.8;
    animation.repeatCount = HUGE_VALF;
    animation.fromValue = @(1);
    animation.toValue = @(0.3);
    [self.animationView.layer addAnimation:animation forKey:@"opacity"];
}

- (void)initSpringAnimation {
    CASpringAnimation *springAnimation = [CASpringAnimation animationWithKeyPath:@"cornerRadius"];
    
    //路径计算模式 （@"position"）
    
    springAnimation.fromValue = @(0);
    springAnimation.toValue = @(20);
    //质量，影响图层运动时的弹簧惯性，质量越大，弹簧拉伸和压缩的幅度越大 Defaults to one
    springAnimation.mass = 5;
    //刚度系数(劲度系数/弹性系数)，刚度系数越大，形变产生的力就越大，运动越快 Defaults to 100
    springAnimation.stiffness = 100;
    //阻尼系数，阻止弹簧伸缩的系数，阻尼系数越大，停止越快 Defaults to 10
    springAnimation.damping = 10;
    //初始速率，动画视图的初始速度大小 Defaults to zero
    //速率为正数时，速度方向与运动方向一致，速率为负数时，速度方向与运动方向相反
    springAnimation.initialVelocity = 10;
    //估算时间 返回弹簧动画到停止时的估算时间，根据当前的动画参数估算
    NSLog(@"====%f",springAnimation.settlingDuration);
    springAnimation.duration = springAnimation.settlingDuration;
    
    //removedOnCompletion 默认为YES 为YES时，动画结束后，恢复到原来状态
    springAnimation.removedOnCompletion = NO;
    //    springAnimation.fillMode = kCAFillModeBoth;
    
    springAnimation.autoreverses = YES;
    springAnimation.repeatCount = HUGE_VALF;
    [self.animationView.layer addAnimation:springAnimation forKey:@"springAnimation"];
}

- (UIView *)animationView {
    if (!_animationView) {
        _animationView = [[UIView alloc] initWithFrame:CGRectMake(40, 100, 40, 40)];
        _animationView.backgroundColor = [UIColor orangeColor];
        _animationView.clipsToBounds = YES;
        _animationView.layer.cornerRadius = 20;
    }
    return _animationView;
}

- (void)initNav {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor orangeColor];
    btn.frame = CGRectMake(300, 300, 40, 40);
    [btn addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *loopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loopBtn.backgroundColor = [UIColor orangeColor];
    loopBtn.frame = CGRectMake(300, 400, 40, 40);
    [loopBtn addTarget:self action:@selector(pushRunLoop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loopBtn];
}

- (void)push {
    [self.navigationController pushViewController:[[KeyFrameViewController alloc] init] animated:YES];
}

- (void)pushRunLoop {
    [self.navigationController pushViewController:[[RunLoopViewController alloc] init] animated:YES];
}

@end
