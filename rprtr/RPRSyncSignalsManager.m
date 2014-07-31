//
//  RPRSyncSignalsManager.m
//  rprtr
//
//  Created by Karolis Stasaitis on 7/28/14.
//  Copyright (c) 2014 delanoir. All rights reserved.
//

#import "RPRSyncSignalsManager.h"
#import <Realm/Realm.h>
#import "RPRWebSignalsManager.h"

#import "RPRTimeEntryParserDelegate.h"

#import "RPRTask.h"
#import "RPRProject.h"
#import "RPRTimeEntry.h"

#import "RPRFreshbooksTimeEntry.h"
#import "RPRProjectParserDelegate.h"
#import "RPRFreshbooksProject.h"
#import "RPRTaskParserDelegate.h"
#import "RPRFreshbooksTask.h"

#include <libkern/OSAtomic.h>

typedef void(^RPRVoidBlock)();
typedef void(^RPRVoidBlockWithError)(NSError *);

static volatile int32_t writerCount = 0;

@interface RPRSyncSignalsManager ()

@property (nonatomic, strong, readonly) RLMRealm *realm;
@property (nonatomic, strong, readonly) RACScheduler *realmScheduler;
@property (nonatomic, strong, readonly) NSDateFormatter *defaultDateFormater;

@end

@implementation RPRSyncSignalsManager

+ (id)sharedManager
{
    static RPRSyncSignalsManager *sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        _realm = [RLMRealm defaultRealm];
        _realmScheduler = [RACScheduler schedulerWithPriority:RACSchedulerPriorityBackground name:@"RealmScheduler"];
        _defaultDateFormater = [[NSDateFormatter alloc] init];
        _defaultDateFormater.dateFormat = @"yyyy-MM-dd";
    }
    return self;
}

- (RPRVoidBlock)beginTransactionBlock
{
    return ^{
        if (OSAtomicIncrement32(&writerCount) == 1) {
            NSLog(@"Began");
            [self.realm beginWriteTransaction];
        }
    };
}

- (RPRVoidBlock)commitTransactionBlock
{
    return ^{
        if (OSAtomicDecrement32(&writerCount) == 0) {
            [self.realm commitWriteTransaction];
            NSLog(@"Commit");
        }
    };
}

- (RPRVoidBlockWithError)failTransactionBlock
{
    return ^(NSError *error) {
        //This should cancel the changes but it seems that relam hasn't implemented that.
        //NSLog(@"Refresh");
    };
}

- (RACSignal *)databaseSignalForSignal:(RACSignal *)signal block:(RACStream * (^)(id value))block
{
    return [[[[[[signal
                 initially:[self beginTransactionBlock]]
                 subscribeOn:self.realmScheduler]
                 flattenMap:block]
                 deliverOn:RACScheduler.mainThreadScheduler]
                 doCompleted:[self commitTransactionBlock]]
                 doError:[self failTransactionBlock]];
}

- (RACSignal *)syncTasks
{
    RACSignal *taskSignal = [[[RPRWebSignalsManager sharedManager] getTasks]
                             flattenMap:^RACStream *(NSXMLParser *xmlParser) {
                                 return [RPRTaskParserDelegate getTaskListWithParser:xmlParser];
                             }];
    
    return [self databaseSignalForSignal:taskSignal block:^id(RPRFreshbooksTask *fbTask) {
        
        RPRTask *task = [[RPRTask alloc] init];
        
        task.taskId = fbTask.taskId.integerValue;
        task.name = fbTask.name ?: @"";
        task.taskDescription = fbTask.taskDescription ?: @"";
        task.billable = fbTask.billable.boolValue;
        task.rate = fbTask.rate.doubleValue;
        
        [self.realm addObject:task];
        
        return [RACSignal return:task];
        
    }];
}

- (RACSignal *)syncProjects
{
    RACSignal *projectSignal = [[[RPRWebSignalsManager sharedManager] getProjects]
                                flattenMap:^RACStream *(NSXMLParser *xmlParser) {
                                    return [RPRProjectParserDelegate getProjectListWithParser:xmlParser];
                                }];
    
    return [self databaseSignalForSignal:projectSignal block:^id(RPRFreshbooksProject *fbProject) {
        
        RPRProject *project = [[RPRProject alloc] init];
        
        project.projectId = fbProject.projectId.integerValue;
        project.name = fbProject.name ?: @"";
        project.projectDescription = project.projectDescription ?: @"";
        project.rate = fbProject.rate.doubleValue;
        project.billMethod = project.billMethod ?: @"";
        project.clientId = fbProject.clientId.integerValue;
        project.hourBudget = fbProject.hourBudget.doubleValue;
        
//        for (RPRFreshbooksProjectTask *fbProjectTask in fbProject.tasks) {
//            RPRTask *task = [[RPRTask objectsWhere:@"taskId == %d", [fbProjectTask.taskId integerValue]] firstObject];
//            if (task) {
//                [task.projects addObject:project];
//                [project.tasks addObject:task];
//            }
//        }
        
        [self.realm addObject:project];
        
        return [RACSignal return:project];

    }];
}

- (RACSignal *)syncTimeEntries
{
    RACSignal *timeEntrySignal = [[[RPRWebSignalsManager sharedManager] getTimeEntries]
                            flattenMap:^RACStream *(NSXMLParser *xmlParser) {
                                return [RPRTimeEntryParserDelegate getTimeEntryListWithParser:xmlParser];
                            }];
    
    return [self databaseSignalForSignal:timeEntrySignal block:^id(RPRFreshbooksTimeEntry *fbTimeEntry) {
        //NSLog(@"Time Entry");
        //return [RACSignal empty];
        RPRTimeEntry *timeEntry = [[RPRTimeEntry alloc] init];
        
        timeEntry.timeEntryId = fbTimeEntry.timeEntryId.integerValue;
        timeEntry.staffId = fbTimeEntry.staffId.integerValue;
        timeEntry.projectId = fbTimeEntry.projectId.integerValue;
        timeEntry.taskId = fbTimeEntry.taskId.integerValue;
        timeEntry.hours = fbTimeEntry.hours.doubleValue;
        timeEntry.date = [self.defaultDateFormater dateFromString:fbTimeEntry.date];
        timeEntry.notes = fbTimeEntry.notes ?: @"";
        timeEntry.billed = [fbTimeEntry.billed boolValue];
        
//        RPRProject *project = [[RPRProject objectsInRealm:self.realm where:@"projectId == %d", timeEntry.projectId] firstObject];
//        if (project) {
//            [project.timeEntries addObject:timeEntry];
//            timeEntry.project = project;
//        }
//        
////        RPRTask *task = [[RPRTask objectsInRealm:self.realm where:@"projectId == %d", timeEntry.projectId] firstObject];
////        if (task) {
////            [task.timeEntries addObject:timeEntry];
////            timeEntry.task = task;
////        }
        
        [self.realm addObject:timeEntry];
        
        //return [RACSignal error:[NSError errorWithDomain:@"fuck" code:123 userInfo:@{NSLocalizedDescriptionKey: @"shit"}]];
        
        return [RACSignal return:timeEntry];
        
    }];
}

@end
