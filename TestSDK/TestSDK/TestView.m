//
//  TestView.m
//  TestSDK
//
//  Created by zbwx on 2018/4/13.
//  Copyright © 2018年 zbwx. All rights reserved.
//

#import "TestView.h"

@implementation TestView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor orangeColor];
    }
    return self;
}
+ (TestView*) testView{
    TestView * view = [[TestView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    return view;
}
@end
