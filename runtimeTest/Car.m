//
//  Car.m
//  runtimeTest
//
//  Created by lbe on 2018/3/30.
//  Copyright © 2018年 liwuyang. All rights reserved.
//

#import "Car.h"

@implementation Car

-(void)run:(double)speed {
    NSLog(@"speed is %fl", speed);
}

-(void)xxx_run: (double)speed {
    if (speed > 100) {
        NSLog(@"speed is %f", speed);
    }
}
@end
