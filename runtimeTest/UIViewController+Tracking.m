//
//  UIViewController+Tracking.m
//  runtimeTest
//
//  Created by lbe on 2018/3/30.
//  Copyright © 2018年 liwuyang. All rights reserved.
//

#import "UIViewController+Tracking.h"
#import <objc/message.h>
@implementation UIViewController (Tracking)
/*
 通过在Category的+ (void)load方法中添加Method Swizzling的代码,在类初始加载时自动被调用,load方法按照父类到子类,类自身到Category的顺序被调用.
 在dispatch_once中执行Method Swizzling是一种防护措施,以保证代码块只会被执行一次并且线程安全,不过此处并不需要,因为当前Category中的load方法并不会被多次调用.
 尝试先调用class_addMethod方法,以保证即便originalSelector只在父类中实现,也能达到Method Swizzling的目的.
 xxx_viewWillAppear:方法中[self xxx_viewWillAppear:animated];代码并不会造成死循环,因为Method Swizzling之后, 调用xxx_viewWillAppear:实际执行的代码已经是原来viewWillAppear中的代码了.
 */
//+ (void)load {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        Class class = [self class];
//        SEL originalSelector = @selector(viewWillAppear:);
//        SEL swizzledSelector = @selector(xxx_viewWillAppear:);
//        Method originalMethod = class_getInstanceMethod(class, originalSelector);
//        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
//        BOOL didAddMethod =
//        class_addMethod(class,
//                        swizzledSelector,
//                        method_getImplementation(swizzledMethod),
//                        method_getTypeEncoding(swizzledMethod));
//        if (!didAddMethod) {
//           method_exchangeImplementations(originalMethod, swizzledMethod);
//        }
//    });
//}


+ (void)load {
    Class class = [self class];

    SEL originalSelector = @selector(viewWillAppear:);
    SEL swizzledSelector = @selector(xxx_viewWillAppear:);
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    if (!originalMethod || !swizzledMethod) {
        return;
    }

    IMP originalIMP = method_getImplementation(originalMethod);
    IMP swizzledIMP = method_getImplementation(swizzledMethod);
    const char *originalType = method_getTypeEncoding(originalMethod);
    const char *swizzledType = method_getTypeEncoding(swizzledMethod);

    // 这儿的先后顺序是有讲究的,如果先执行后一句,那么在执行完瞬间方法被调用容易引发死循环
    class_replaceMethod(class,swizzledSelector,originalIMP,originalType);
    class_replaceMethod(class,originalSelector,swizzledIMP,swizzledType);
}

#pragma mark - Method Swizzling
- (void)xxx_viewWillAppear:(BOOL)animated {
    [self xxx_viewWillAppear:animated];
    NSLog(@"kkkkkkkk viewWillAppear: %@", self);
}

@end
