//
//  ViewController.m
//  runtimeTest
//
//  Created by lbe on 2018/3/30.
//  Copyright © 2018年 liwuyang. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "UIViewController+Tracking.h"
#import "BBMessageForwardProxy.h"
#import "Car.h"
#import "MyCar.h"
@interface ViewController ()

-(void)methodDynamicHandleTest;
-(void)methodFowardingTest;
@end

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"xxxxxxx");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    void (*setter)(id, SEL, BOOL);
//    int i;
//
//    setter = (void (*)(id, SEL, BOOL))[self methodForSelector:@selector(addTen:)];
    
//    Method addImp = class_getInstanceMethod(self, @selector(addTen:));
    
//    for (NSInteger i = 0; i < 1000; i++) {
////        NSLog(@"%ld", (long)[self addTen:i]);
//        [self callFunctionUsingIMP];
////         setter(self, @selector(setFilled:), YES);
//    }
    
    //直接通过IMP调用方法
//    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
//    void (*imp)(id, SEL, id, id) = (void(*)(id,SEL,id,id))[dict methodForSelector:@selector(setObject:forKey:)];
//    if( imp ) imp(dict, @selector(setObject:forKey:), @"obj", @"key");
//
//    NSLog(@"%@", dict);
    
    //消息动态转发
  //  [self methodFowardingTest];
    
    
    //method swizzle
    Car *car = [[Car alloc] init];
    [car run:10];
    
//    MyCar *mycar = [[MyCar alloc] init];
//    
//    [car run:110];
//    [car run:130];
//    [car run:120];
    
    
}
//************ 消息转发
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSLog(@"消息签名");
    NSLog(@"methodSignatureForSelector:sel is %@", NSStringFromSelector(aSelector));
    NSMethodSignature *sig = [BBMessageForwardProxy instanceMethodSignatureForSelector:@selector(bb_dealNotRecognizedMessage:)];
    return sig;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    NSLog(@"消息转发");
    NSLog(@"forwardInvocation:sel is %@", NSStringFromSelector(anInvocation.selector));
    NSString *debugInfo = [NSString stringWithFormat:@"[debug]unRecognizedMessage:[%@] sent to [%@]",NSStringFromSelector(anInvocation.selector),NSStringFromClass([self class])];
    //重定向方法
    [anInvocation setSelector:@selector(bb_dealNotRecognizedMessage:)];
    //传递调用信息
    [anInvocation setArgument:&debugInfo atIndex:2];
    //BBMessageForwardProxy对象接收转发的消息并打印调用信息
    [anInvocation invokeWithTarget:[BBMessageForwardProxy new]];
}


//******************消息动态处理
void dynamicMethodIMP(id self, SEL _cmd)
{
    // implementation ....
    NSLog(@"hahaxxxxxx");
}

+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    NSLog(@"消息动态处理");
    NSLog(@"resolveInstanceMethod,sel is %@", NSStringFromSelector(sel));
//    if(sel == @selector(methodDynamicHandleTest)){
//        class_addMethod([self class],sel,(IMP)dynamicMethodIMP,"v@:");
//        return YES;
//    }
//    return [super resolveInstanceMethod:sel];
    return false;
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
//    //如果代理对象能处理，则转接给代理对象
//    if ([proxyObj respondsToSelector:aSelector]) {
//        return proxyObj;
//    }
    NSLog(@"消息动态处理");
    NSLog(@"forwardingTargetForSelector,sel is %@", NSStringFromSelector(aSelector));
    //不能处理进入转发流程
    return nil;
}


//********* 直接调用IMP，类似C函数调用
- (void)callFunctionUsingIMP
{
    //Build Setting --> Enable Strict Checking of objc_msgSend Calls  改为 NO
    void (*imp) (id,SEL,id) = (void (*)(id,SEL,id))[self methodForSelector:@selector(testImp:)];
    imp(self,@selector(testImp:),@"hello");
}

- (void)testImp:(NSString *)string
{
    NSLog(@"%@",string);
}



-(NSInteger)addTen:(NSInteger)value {
    return value + 10;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
