//
//  CAAnimationDelegateObject.h
//  GCD
//
//  Created by wahaha on 2018/11/13.
//  Copyright © 2018年 LWX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^CAAnimationDelegateBlock)(void);
NS_ASSUME_NONNULL_BEGIN

@interface CAAnimationDelegateObject : NSObject<CAAnimationDelegate>
@property (nonatomic, copy) CAAnimationDelegateBlock disStop;

@end

NS_ASSUME_NONNULL_END
