//
//  RPRFreshbooksTask.h
//  rprtr
//
//  Created by Karolis Stasaitis on 7/22/14.
//  Copyright (c) 2014 delanoir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RPRFreshbooksTask : NSObject

@property (nonatomic, strong) NSString *taskId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *taskDescription;
@property (nonatomic, strong) NSString *billable;
@property (nonatomic, strong) NSString *rate;

@end
