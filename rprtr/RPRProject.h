//
//  RPRProject.h
//  rprtr
//
//  Created by Karolis Stasaitis on 7/25/14.
//  Copyright (c) 2014 delanoir. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RPRTask;
@protocol RPRTimeEntry;

@interface RPRProject : RLMObject

@property NSInteger projectId;
@property NSString *name;
@property NSString *projectDescription;
@property double rate;
@property NSString *billMethod;
@property NSInteger clientId;
@property NSInteger hourBudget;

@property RLMArray<RPRTask> *tasks;
@property RLMArray<RPRTimeEntry> *timeEntries;

@end

RLM_ARRAY_TYPE(RPRProject)
