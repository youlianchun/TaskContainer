//
//  TaskExample.m
//  TaskContainer
//
//  Created by YLCHUN on 2018/5/30.
//  Copyright © 2018年 YLCHUN. All rights reserved.
//

#import "TaskExample.h"
#import "TaskContainer.h"

void testTasksIterator()
{
    tasksIterator(@[@"0", @"1", @"2"], ^(id data, TaskReter taskReter) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"task:%@", data);
            taskReter(YES);
        });
    }, ^(BOOL success) {
        NSLog(@"finish");
    });
}

static NSArray* createTasks()
{
    NSMutableArray *tasks = [NSMutableArray array];
    [tasks addObject:getTaskUnit(^(TaskReter taskReter) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"task0");
            taskReter(YES);
        });
    })];
    [tasks addObject:getTaskUnit(^(TaskReter taskReter) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"task1");
            taskReter(YES);
        });
    })];
    [tasks addObject:getTaskUnit(^(TaskReter taskReter) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"task2");
            taskReter(YES);
        });
    })];
    return tasks;
}

void testTasksGroup()
{
    NSArray * tasks = createTasks();
    tasksGroupRun(tasks, ^(BOOL success) {
        NSLog(@"finish a");
    });
    tasksGroupRun(tasks, ^(BOOL success) {
        NSLog(@"finish b");
    });
}
