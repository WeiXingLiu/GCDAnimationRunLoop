//
//  LWXNavigationController.m
//  GCD
//
//  Created by wahaha on 2018/11/9.
//  Copyright © 2018年 LWX. All rights reserved.
//

#import "LWXNavigationController.h"
#import "UIViewController+NavigationBar.h"

@interface LWXNavigationController ()

@end

@implementation LWXNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [viewController initLeftBackBtn];
    [super pushViewController:viewController animated:animated];
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
