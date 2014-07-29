//
//  RPRFreshbooksTask.m
//  rprtr
//
//  Created by Karolis Stasaitis on 7/22/14.
//  Copyright (c) 2014 delanoir. All rights reserved.
//

#import "RPRFreshbooksTask.h"

@implementation RPRFreshbooksTask

- (NSString *)description
{
    return [@{
              @"taskId" : self.taskId ?: [NSNull null],
              @"name" : self.name ?: [NSNull null],
              @"taskDescription" : self.taskDescription ?: [NSNull null],
              @"billable" : self.billable ?: [NSNull null],
              @"rate" : self.rate ?: [NSNull null],
              } description];
}

@end
