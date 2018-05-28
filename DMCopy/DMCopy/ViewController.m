//
//  ViewController.m
//  DMCopy
//
//  Created by lbq on 2018/5/28.
//  Copyright © 2018年 lbq. All rights reserved.
//

#import "ViewController.h"
#import "DMUser.h"
@interface ViewController ()

@property (nonatomic, strong) NSCache *cache;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self test9];
}

- (void)test0{
    self.cache = [[NSCache alloc] init];
    DMUser *user = [DMUser new];
    user.name = @"Tom";
    user.age = 18;
    user._id = @1;
    
    [self.cache setObject:user forKey:user._id];
    
    DMUser *fetchUser = [self fetchUserForId:@1];
    fetchUser.name = @"John";
    
    DMUser *fetchUser1 = [self fetchUserForId:@1];
    NSLog(@"fetchUser1 = %@",fetchUser1.name);//fetchUser1 = John
}

- (DMUser *)fetchUserForId:(NSNumber *)userId
{
    DMUser *fetchUser = [self.cache objectForKey:userId];
    return fetchUser;
}

//不可变对象mutableCopy后变为可变对象，深拷贝
- (void)test1{
    NSString *str =@"hello";
    NSMutableString *mutableStr = [str mutableCopy];
    NSLog(@"%p==%p",str,mutableStr);
    [mutableStr appendString:@" world"];
    NSLog(@"%p==%p;%@==%@",str,mutableStr,str,mutableStr);
    
    /*
     0x10f9af0f8==0x600000442070
     0x10f9af0f8==0x600000442070;hello==hello world
     */
}

//不可变对象的copy 浅拷贝
- (void)test2{
    NSString *str = @"hello";
    NSString *copyStr = [str copy];
//    NSLog(@"%p==%p",str,copyStr);
    NSLog(@"%p==%p;%@==%@",str,copyStr,str,copyStr);
//    0x109d580f8==0x109d580f8;hello==hello
}

//可变对象的copy操作 深拷贝
- (void)test3
{
    NSMutableString *mutableStr = [[NSMutableString alloc] initWithString:@"hello"];
    NSString *copyStr = [mutableStr copy];
    NSLog(@"%p==%p",copyStr,mutableStr);
    [mutableStr appendString:@" world"];
    NSLog(@"%p==%p;%@==%@",copyStr,mutableStr,copyStr,mutableStr);
    /*
    0xa00006f6c6c65685==0x600000448160
    0xa00006f6c6c65685==0x600000448160;hello==hello world
     */
}

//可变对象的mutableCopy操作 深拷贝
- (void)test4
{
    NSMutableString *mutableStr = [[NSMutableString alloc] initWithString:@"hello"];
    NSString *mutableCopyStr = [mutableStr copy];
    NSLog(@"%p==%p",mutableCopyStr,mutableStr);
    [mutableStr appendString:@" world"];
    NSLog(@"%p==%p;%@==%@",mutableCopyStr,mutableStr,mutableCopyStr,mutableStr);
    /*
     0xa00006f6c6c65685==0x60000025fc20
     0xa00006f6c6c65685==0x60000025fc20;hello==hello world
     */
}

//集合类型 浅拷贝
- (void)test5
{
    NSArray *arr = @[@1,@2];
    NSArray *copyArr = [arr copy];
    NSLog(@"%p==%p",arr,copyArr);
}

// 深拷贝
- (void)test6
{
    NSArray *arr = @[@1,@2];
    NSMutableArray *mutableCopyArr = [arr mutableCopy];
    NSLog(@"%p==%p",arr,mutableCopyArr);
    [mutableCopyArr removeObjectAtIndex:0];
    NSLog(@"%p==%p;%@==%@",arr,mutableCopyArr,arr,mutableCopyArr);
}


- (void)test7
{
    NSMutableString *mutableStr1 = [[NSMutableString alloc] initWithString:@"hello"];
    NSMutableString *mutableStr2 = [[NSMutableString alloc] initWithString:@"world"];
    NSArray *arr = @[mutableStr1,mutableStr2];
    NSLog(@"%p==%p",arr.firstObject,arr[1]);
    
    NSArray *copyArr = [arr copy];
    [mutableStr1 appendString:@"--"];
     NSLog(@"%p==%p==%p==%p",arr.firstObject,arr[1],copyArr.firstObject,copyArr[1]);
}

- (void)test8
{
    NSMutableString *mutableStr1 = [[NSMutableString alloc] initWithString:@"hello"];
    NSMutableString *mutableStr2 = [[NSMutableString alloc] initWithString:@"world"];
    NSArray *arr = @[mutableStr1,mutableStr2];
    NSLog(@"%p==%p",arr.firstObject,arr[1]);
    
    NSArray *mutableCopyArr = [arr mutableCopy];
    [mutableStr1 appendString:@"--"];
    NSLog(@"%p==%p==%p==%p;%@==%@",arr.firstObject,arr[1],mutableCopyArr.firstObject,mutableCopyArr[1],mutableCopyArr.firstObject,mutableCopyArr[1]);
    /*
     0x6040002458e0==0x604000244530
     0x6040002458e0==0x604000244530==0x6040002458e0==0x604000244530;hello--==world
     */
}

- (void)test9
{
    NSMutableString *mutableStr1 = [[NSMutableString alloc] initWithString:@"hello"];
    NSMutableString *mutableStr2 = [[NSMutableString alloc] initWithString:@"world"];
    NSMutableArray *mutableArr = [[NSMutableArray alloc] initWithObjects:mutableStr1,mutableStr2, nil];
    NSLog(@"%p==%p",mutableArr.firstObject,mutableArr[1]);
    
    NSArray *mutableCopyArr = [mutableArr copy];//与[mutableArr copy]效果一样
    [mutableStr1 appendString:@"--"];
    NSLog(@"%p==%p==%p==%p;%@==%@",mutableArr.firstObject,mutableArr[1],mutableCopyArr.firstObject,mutableCopyArr[1],mutableArr.firstObject,mutableCopyArr.firstObject);
    /*
     0x600000241fb0==0x6000002402a0
     0x600000241fb0==0x6000002402a0==0x600000241fb0==0x6000002402a0;hello--==hello--
     */
}

- (void)test10
{
    NSString *str1 = @"hello";
    NSString *str2 = @"world";
    
    NSArray *arr = @[str1,str2];
    
    NSLog(@"%p==%p",arr.firstObject,arr[1]);
    NSMutableArray *mutableArr = [arr copy];//与[arr mutableCopy]效果一样
    str1 = @"hello---";
    NSLog(@"%p==%p;%@==%@",mutableArr.firstObject,mutableArr[1],mutableArr.firstObject,arr.firstObject);
    /*
     0x102f64108==0x102f64188
     0x102f64108==0x102f64188;hello==hello
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
