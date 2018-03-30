//
//  MyCar.m
//  runtimeTest
//
//  Created by lbe on 2018/3/30.
//  Copyright © 2018年 liwuyang. All rights reserved.
//

#import "MyCar.h"

#import <objc/runtime.h>
#import <objc/message.h>
//Hook该方法对速度小于120才执行run的代码, 按照方法交换的流程,
@implementation MyCar

+(void)load {
    
    Class carCls = NSClassFromString(@"Car");
    Class myCarCls = NSClassFromString(@"MyCar");
    
    SEL runSel = NSSelectorFromString(@"run:");
    SEL xxx_runSel = NSSelectorFromString(@"xxx_run:");
    
    Method runMethod = class_getInstanceMethod(carCls,  runSel);
    Method xxRunMethod = class_getInstanceMethod(myCarCls,  xxx_runSel);
    
    //给car添加xxx_run方法
    BOOL addMethod = class_addMethod(carCls, xxx_runSel, method_getImplementation(xxRunMethod), method_getTypeEncoding(xxRunMethod));
    if (addMethod) {
        //交换car中的xxx_run和run方法
        method_exchangeImplementations(runMethod, xxRunMethod);
    } else {
        class_replaceMethod(carCls, runSel, method_getImplementation(xxRunMethod), method_getTypeEncoding(xxRunMethod));
    }
}

-(void)xxx_run: (double)speed {
    if (speed > 120) {
        NSLog(@"speed is %f", speed);
    }
}

@end
