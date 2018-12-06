//
//  UIViewController+NavigationBar.m
//  GCD
//
//  Created by wahaha on 2018/11/9.
//  Copyright © 2018年 LWX. All rights reserved.
//

#import "UIViewController+NavigationBar.h"

@implementation UIViewController (NavigationBar)
- (void)initLeftBackBtn {
    [[UIBarButtonItem appearance] setBackButtonBackgroundVerticalPositionAdjustment:-20 forBarMetrics:UIBarMetricsDefault];
    
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
//    item.width = 20;
//    self.navigationItem.leftBarButtonItem = item;
}
@end
