//
//  RPRFreshbooksProject.h
//  rprtr
//
//  Created by Karolis Stasaitis on 7/23/14.
//  Copyright (c) 2014 delanoir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RPRFreshbooksProject : NSObject

@property (nonatomic, strong) NSString *projectId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *projectDescription;
@property (nonatomic, strong) NSString *rate;
@property (nonatomic, strong) NSString *billMethod;
@property (nonatomic, strong) NSString *clientId;
@property (nonatomic, strong) NSString *hourBudget;

@property (nonatomic, strong) NSArray *tasks;
@property (nonatomic, strong) NSArray *staff;

@end

@interface RPRFreshbooksProjectTask : NSObject

@property (nonatomic, strong) NSString *taskId;
@property (nonatomic, strong) NSString *rate;

@end

@interface RPRFreshbooksProjectStaff : NSObject

@property (nonatomic, strong) NSString *staffId;

@end
