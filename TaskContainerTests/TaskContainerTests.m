//
//  TaskContainerTests.m
//  TaskContainerTests
//
//  Created by YLCHUN on 2018/5/30.
//  Copyright © 2018年 YLCHUN. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "unit_tool.h"
#import "TaskContainer.h"

@interface TaskContainerTests : XCTestCase

@end

@implementation TaskContainerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}


-(void)testTasksIterator
{
    XCTestWait(self, 5, ^(void (^fulfill)(void)) {
        tasksIterator(@[@"0", @"1", @"2"], ^(NSString* data, BOOL (^taskCompleted)(bool success)) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSLog(@"task%@", data);
                taskCompleted(YES);
            });
        }, ^(bool allSuccess) {
            fulfill();
        });
    });
}

static NSArray* createTasks()
{
    NSMutableArray *tasks = [NSMutableArray array];
    [tasks addObject:getTaskUnit(^(BOOL (^taskCompleted)(bool success)) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"task0");
            taskCompleted(YES);
        });
    })];
    [tasks addObject:getTaskUnit(^(BOOL (^taskCompleted)(bool success)) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"task1");
            taskCompleted(YES);
        });
    })];
    [tasks addObject:getTaskUnit(^(BOOL (^taskCompleted)(bool success)) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"task2");
            taskCompleted(YES);
        });
    })];
    return tasks;
}

-(void)testTasksGroup
{
    NSArray * tasks = createTasks();
    XCTestWait(self, 100, ^(void (^fulfill)(void)) {
        concurrent_test(100, 100, ^{
            tasksGroupRun(tasks, ^(bool allSuccess) {
                NSLog(@"a");
            });
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            fulfill();
        });
    });
}

@end
