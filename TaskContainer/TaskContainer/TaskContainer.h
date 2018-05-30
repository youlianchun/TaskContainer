//
//  TaskContainer.h
//  TaskContainer
//
//  Created by YLCHUN on 2018/5/30.
//  Copyright © 2018年 ylchun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef BOOL(^TaskReter)(BOOL success);
typedef void(^TasksReter)(BOOL success);
typedef void(^TaskIterator)(id data, TaskReter taskReter);
typedef void(^TaskUnit)(TasksReter);
typedef void(^TaskBlock)(TaskReter taskReter);

OBJC_EXTERN void tasksIterator(NSArray* datas, TaskIterator iterator, TasksReter tasksReter);

// getTaskUnit  tasksGroup  两函数结合使用
OBJC_EXTERN TaskUnit getTaskUnit(TaskBlock taskBlock);
OBJC_EXTERN void tasksGroupRun(NSArray<TaskUnit>* tasks, TasksReter tasksReter);
