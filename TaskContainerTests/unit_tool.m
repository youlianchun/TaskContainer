//
//  unit_tool.m
//  UnitTests
//
//  Created by YLCHUN on 2018/5/7.
//  Copyright © 2018年 YLCHUN. All rights reserved.
//

#import "unit_tool.h"
#import <XCTest/XCTest.h>

void XCTestWait(XCTestCase* self, NSTimeInterval timeout, void(^block)(void(^fulfill)(void)))
{
    if (!block) return;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"XCTestWait"];
    
    block(^{
        [expectation fulfill];
    });
    
    [self waitForExpectationsWithTimeout:timeout handler:^(NSError * _Nullable error) {
        if (error)
            NSLog(@"XCTestWait timeout: %@", error.description);
    }];
}


NSUInteger concurrent_test(NSUInteger threadCount, NSUInteger runCount, dispatch_block_t block)
{
    if (!block) return 0;
    if (threadCount == 0) threadCount = 1;
    if (runCount == 0) runCount = 1;
    
    dispatch_queue_t queue = dispatch_queue_create("com.test.concurrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    dispatch_suspend(queue);
    __block BOOL jam = YES;
    
    for (int i = 0; i < threadCount; i++) {
        dispatch_group_async(group, queue, ^{
            NSUInteger i = 0;
            while (i++ < runCount) {
                block();
            }
        });
    }
    dispatch_group_notify(group, queue, ^{
        jam = YES;
    });
    jam = NO;
    dispatch_resume(queue);
    NSLog(@"The concurrency test is ready to complete and start concurrency.");
    
    NSUInteger n = 0;
    while (!jam) {
        n++;
        block();
    }
    
    NSLog(@"The concurrency test ended.");
    return n + threadCount * runCount;
}
