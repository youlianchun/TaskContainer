//
//  TaskContainer.m
//  TaskContainer
//
//  Created by YLCHUN on 2018/5/30.
//  Copyright © 2018年 ylchun. All rights reserved.
//

#import "TaskContainer.h"
#import <pthread.h>

static TasksReter getTasksReter(NSUInteger count, TasksReter tasksReter)
{
    __block NSUInteger completedCount = 0;
    __block NSUInteger successedCount = 0;
    return ^(BOOL success) {
        completedCount ++;
        if (success) successedCount ++;
        if (completedCount == count) {
            dispatch_async(dispatch_get_main_queue(), ^{
                tasksReter(completedCount == successedCount);
            });
        }
    };
}

static TaskReter getTaskReter(TasksReter tasksReter)
{
    static pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
    __block BOOL isCompleted = NO;
    return ^BOOL(BOOL success) {
        pthread_mutex_lock(&mutex);
        BOOL b;
        if (isCompleted) {
            assert(false);
            b = NO;
        }else {
            isCompleted = YES;
            tasksReter(success);
            b = YES;
        }
        pthread_mutex_unlock(&mutex);
        return b;
    };
}

void tasksIterator(NSArray* datas, TaskIterator iterator, TasksReter tasksReter)
{
    if (!iterator || !tasksReter) return;
    tasksReter = getTasksReter(datas.count, tasksReter);
    for (id data in datas) {
        iterator(data, getTaskReter(tasksReter));
    }
}



TaskUnit getTaskUnit(TaskBlock taskBlock)
{
    if (!taskBlock) return nil;
    return ^(TasksReter tasksReter) {
        taskBlock(getTaskReter(tasksReter));
    };
}

void tasksGroupRun(NSArray<TaskUnit>* tasks, TasksReter tasksReter)
{
    if (!tasksReter) return;
    tasksReter = getTasksReter(tasks.count, tasksReter);
    for (TaskUnit task in tasks) {
        task(tasksReter);
    }
}
