//
//  BBMessageForwardProxy.h
//  runtimeTest
//
//  Created by lbe on 2018/3/30.
//  Copyright © 2018年 liwuyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBMessageForwardProxy : NSObject
- (void)bb_dealNotRecognizedMessage:(NSString *)debugInfo;
@end
