//
//  BezierPathView.m
//  GCD
//
//  Created by wahaha on 2018/11/8.
//  Copyright © 2018年 LWX. All rights reserved.
//

#import "BezierPathView.h"

@implementation BezierPathView
- (void)drawRect:(CGRect)rect {
    [[UIColor yellowColor] set];
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(100, 100, 200, 400)];
    path.lineWidth = 2;
    [path stroke];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
