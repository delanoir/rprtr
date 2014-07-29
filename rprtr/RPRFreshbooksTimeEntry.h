//
//  RPRFreshbooksTimeEntry.h
//  rprtr
//
//  Created by Karolis Stasaitis on 7/23/14.
//  Copyright (c) 2014 delanoir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RPRFreshbooksTimeEntry : NSObject

@property (nonatomic, strong) NSString *timeEntryId;
@property (nonatomic, strong) NSString *staffId;
@property (nonatomic, strong) NSString *projectId;
@property (nonatomic, strong) NSString *taskId;
@property (nonatomic, strong) NSString *hours;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *notes;
@property (nonatomic, strong) NSString *billed;

@end
