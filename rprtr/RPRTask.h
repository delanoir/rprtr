//
//  RPRTask.h
//  rprtr
//
//  Created by Karolis Stasaitis on 7/25/14.
//  Copyright (c) 2014 delanoir. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RPRProject;
@protocol RPRTimeEntry;

@interface RPRTask : RLMObject

@property NSInteger taskId;
@property NSString *name;
@property NSString *taskDescription;
@property BOOL billable;
@property double rate;

@property RLMArray<RPRProject> *projects;
@property RLMArray<RPRTimeEntry> *timeEntries;

@end

RLM_ARRAY_TYPE(RPRTask)
