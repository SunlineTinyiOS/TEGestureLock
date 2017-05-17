//
//  TEGestureLockViewController.m
//  TEGestureLock
//
//  Created by sunjf@sunline.cn on 02/06/2017.
//  Copyright (c) 2017 sunjf@sunline.cn. All rights reserved.
//

#import "TEGestureLockViewController.h"
#import <TEGestureLock/TEGestureLock.h>

@interface TEGestureLockViewController ()

@end

@implementation TEGestureLockViewController

- (void)viewDidLoad
{
    TEGestureLock *lock = [[TEGestureLock alloc] init];
    lock.frame = CGRectMake(0, 0, 300, 300);
    [lock performSelector:@selector(setParam: :) withObject:@"lineColor" withObject:@"#FFFF00"];

    [self.view addSubview:lock];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
