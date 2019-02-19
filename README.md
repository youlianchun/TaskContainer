# TaskContainer
TaskContainer 任务捆绑

### TaskContainer
```
typedef BOOL(^TaskReter)(BOOL success);
typedef void(^TasksReter)(BOOL success);
typedef void(^TaskIterator)(id data, TaskReter taskReter);
typedef void(^TaskUnit)(TasksReter);
typedef void(^TaskBlock)(TaskReter taskReter);

OBJC_EXTERN void tasksIterator(NSArray* datas, TaskIterator iterator, TasksReter tasksReter);

// getTaskUnit  tasksGroup  两函数结合使用
OBJC_EXTERN TaskUnit getTaskUnit(TaskBlock taskBlock);
OBJC_EXTERN void tasksGroupRun(NSArray<TaskUnit>* tasks, TasksReter tasksReter);
```

### 使用帮助

资源任务
```
tasksIterator(@[@"0", @"1", @"2"], ^(id data, TaskReter taskReter) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"task:%@", data);
        taskReter(YES);
    });
}, ^(BOOL success) {
    NSLog(@"finish");
});
```

任务捆绑
```
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

...
NSArray * tasks = createTasks();
tasksGroupRun(tasks, ^(BOOL success) {
    NSLog(@"finish a");
});
```
