//
//  BBMessageForwardProxy.m
//  runtimeTest
//
//  Created by lbe on 2018/3/30.
//  Copyright © 2018年 liwuyang. All rights reserved.
//

#import "BBMessageForwardProxy.h"

@implementation BBMessageForwardProxy
- (void)bb_dealNotRecognizedMessage:(NSString *)debugInfo
{
    NSLog(@"%@",debugInfo);
}
@end
