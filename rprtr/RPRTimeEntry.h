//
//  RPRTimeEntry.h
//  rprtr
//
//  Created by Karolis Stasaitis on 7/25/14.
//  Copyright (c) 2014 delanoir. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RPRProject;
@class RPRTask;

@interface RPRTimeEntry : RLMObject

@property NSInteger timeEntryId;
@property NSInteger staffId;
@property NSInteger projectId;
@property NSInteger taskId;
@property double hours;
@property NSDate *date;
@property NSString *notes;
@property BOOL billed;

@property RPRProject *project;
@property RPRTask *task;

@end

RLM_ARRAY_TYPE(RPRTimeEntry)