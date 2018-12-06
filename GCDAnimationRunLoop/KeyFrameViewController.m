//
//  KeyFrameViewController.m
//  GCD
//
//  Created by wahaha on 2018/11/7.
//  Copyright © 2018年 LWX. All rights reserved.
//

#import "KeyFrameViewController.h"
#import "BezierPathView.h"
#import "CAAnimationDelegateObject.h"

NSString *name = @"123";
@interface KeyFrameViewController ()<CAAnimationDelegate>
@property (nonatomic, strong) UIView *animationView;
@property (nonatomic, strong) UIView *pathView;
@property (nonatomic, strong) UIView * ellipsoidView;
@property (nonatomic, strong) UIView *carView;
@property (nonatomic, strong) BezierPathView *beView;
@property (nonatomic, strong) UIView *transtionView;
@property (nonatomic, strong) CAAnimationDelegateObject *object;
@end

@implementation KeyFrameViewController

int age = 8;

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.beView];
    [self initKeyFrameAnimation];
    [self initTranstionView];
    NSLog(@"%@", [NSString stringWithFormat:@"%d",age]);
    NSLog(@"%@", name);
    dispatch_async(dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_DEFAULT), ^{
        for (int i = 0 ; i < 100000; i ++) {
            UIView *view = [UIView new];
        }
    });
}

- (void)initKeyFrameAnimation {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    NSValue *originValue = [NSValue valueWithCGPoint:CGPointMake(100, 100)];
    NSValue *secondValue = [NSValue valueWithCGPoint:CGPointMake(200, 100)];
    NSValue *thirdValue = [NSValue valueWithCGPoint:CGPointMake(200, 200)];
    NSValue *forValue = [NSValue valueWithCGPoint:CGPointMake(200, 300)];
    NSValue *fiveValue = [NSValue valueWithCGPoint:CGPointMake(100, 300)];
    NSValue *sixValue = [NSValue valueWithCGPoint:CGPointMake(100, 200)];
    NSValue *sevenValue = [NSValue valueWithCGPoint:CGPointMake(100, 100)];
    
    animation.values = @[originValue, secondValue, thirdValue, forValue, fiveValue, sixValue, sevenValue];
    
    animation.repeatCount = HUGE_VALF;
    animation.duration = 2.0f;
    animation.autoreverses = YES;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    [self.animationView.layer addAnimation:animation forKey:@"position"];
    
    
    //旋转动画
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    basicAnimation.repeatCount = HUGE_VALF;
    basicAnimation.autoreverses = YES;
    basicAnimation.duration = 2.0f;
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;
    basicAnimation.fromValue = @(0);
    basicAnimation.toValue = @(2 * M_PI);
    [self.animationView.layer addAnimation:basicAnimation forKey:@"transform.rotation.z"];
    
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathAddEllipseInRect(path, NULL, CGRectMake(150, 200, 200, 100));
    CGPathMoveToPoint(path,NULL,0,0);
    CGPathAddQuadCurveToPoint(path, NULL, 400, 200, CGRectGetMinX(self.carView.frame) + 20, CGRectGetMinY(self.carView.frame) + 20);
    pathAnimation.path=path;
    CGPathRelease(path);
    
    pathAnimation.autoreverses = YES;
    pathAnimation.repeatCount = HUGE_VALF;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.duration = 1.0f;
    pathAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    __weak typeof(self) weakSelf = self;
    pathAnimation.delegate = self.object;
    [self.pathView.layer addAnimation:pathAnimation forKey:@"position"];

    CABasicAnimation *pathBasicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    pathBasicAnimation.autoreverses = YES;
    pathBasicAnimation.repeatCount = HUGE_VALF;
    pathBasicAnimation.removedOnCompletion = NO;
    pathBasicAnimation.fillMode = kCAFillModeForwards;
    pathBasicAnimation.fromValue = @(0);
    pathBasicAnimation.toValue = @(2 * M_PI);
    pathBasicAnimation.duration = 1.0f;
    [self.pathView.layer addAnimation:pathBasicAnimation forKey:@"transform.rotation.z"];
    
    CAKeyframeAnimation *elliAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    CGMutablePathRef elliPath = CGPathCreateMutable();
    //椭圆，区域
    CGPathAddEllipseInRect(elliPath, NULL, CGRectMake(100, 100, 200, 400));
    //圆 以某个点为圆心，半径为xx
//    CGPathAddArc(elliPath, NULL, 100, 100, 100, 0, M_PI * 2, YES);
//    CGPathAddRect(elliPath, NULL, CGRectMake(100, 200, 200, 200));
    elliAnimation.path = elliPath;
    CGPathRelease(elliPath);
    elliAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    elliAnimation.repeatCount = HUGE_VALF;
    elliAnimation.autoreverses = YES;
    elliAnimation.removedOnCompletion = NO;
    elliAnimation.fillMode = kCAFillModeForwards;
    elliAnimation.duration = 4.0;
    
    [self.ellipsoidView.layer addAnimation:elliAnimation forKey:@"elliAnimation"];
    
}

- (void)initTranstionView {
    [self.view addSubview:self.transtionView];
    __weak typeof(self) weakSelf = self;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        CATransition *transtionAnimation = [CATransition animation];
        transtionAnimation.type = @"rippleEffect";
//        transtionAnimation.subtype = kCATransitionFromLeft;
        transtionAnimation.duration = 1.0;
        transtionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        float randomRed = (arc4random() % 256) / 255.0;
        float randomGreen = (arc4random() % 256) / 255.0;
        float randomBlue = (arc4random() % 256) / 255.0;
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.transtionView.backgroundColor = [UIColor colorWithRed:randomRed green:randomGreen blue:randomBlue alpha:1.0];
            [weakSelf.transtionView.layer addAnimation:transtionAnimation forKey:@"transtion"];
        });
    }];
    [timer setFireDate:[NSDate distantPast]];
    
}

- (UIView *)animationView {
    if ((!_animationView)) {
        _animationView = [[UIView alloc] initWithFrame:CGRectMake(40, 100, 40, 40)];
        _animationView.backgroundColor = [UIColor purpleColor];
        [self.view addSubview:_animationView];
    }
    return _animationView;
}

- (UIView *)pathView {
    if ((!_pathView)) {
        _pathView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        _pathView.backgroundColor = [UIColor redColor];
        [self.view addSubview:_pathView];
    }
    return _pathView;
}

- (UIView *)ellipsoidView {
    if ((!_ellipsoidView)) {
        _ellipsoidView = [[UIView alloc] initWithFrame:CGRectMake(60, 60, 30, 30)];
        _ellipsoidView.backgroundColor = [UIColor greenColor];
        [self.view addSubview:_ellipsoidView];
    }
    return _ellipsoidView;
}

- (UIView *)carView {
    if (!_carView) {
        _carView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.view.frame) - 80, CGRectGetMaxY(self.view.frame) - 80, 40, 40)];
        _carView.backgroundColor = [UIColor purpleColor];
        [self.view addSubview:_carView];
    }
    return  _carView;
}

- (BezierPathView *)beView {
    if (!_beView) {
        _beView = [[BezierPathView alloc] initWithFrame:self.view.bounds];
        _beView.backgroundColor = [UIColor whiteColor];
    }
    return _beView;
}

- (UIView *)transtionView {
    if (!_transtionView) {
        _transtionView = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 300, 300)];
        _transtionView.backgroundColor = [UIColor redColor];
    }
    return _transtionView;
}

- (CAAnimationDelegateObject *)object {
    if (!_object) {
        _object = [[CAAnimationDelegateObject alloc] init];
        __weak typeof(self) weakSelf = self;
        _object.disStop = ^{
            [weakSelf.pathView.layer removeAllAnimations];
            [weakSelf.pathView removeFromSuperview];
        };
    }
    return _object;
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
