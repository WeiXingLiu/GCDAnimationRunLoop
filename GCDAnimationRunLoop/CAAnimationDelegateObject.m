//
//  CAAnimationDelegateObject.m
//  GCD
//
//  Created by wahaha on 2018/11/13.
//  Copyright © 2018年 LWX. All rights reserved.
//

#import "CAAnimationDelegateObject.h"

@implementation CAAnimationDelegateObject
- (void)dealloc {
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (self.disStop) {
        self.disStop();
    }
}
@end
